# Flutter Database and Sync Rules

## Database Strategy

**Offline-First Approach**

- **Drift (SQLite)** = Main database (single source of truth)
- **Supabase** = Cloud backup and sync

## Core Principles

1. **All operations write to Drift first**
   - Fast, works offline
   - Seamless user experience

2. **Background sync to Supabase**
   - Auto sync when internet available
   - Queue when offline

3. **New device login = Pull from Supabase to Drift**
   - User sees same data on different devices
   - Conflict resolution strategy exists

## Drift Setup

### Database File

**Location:** `core/database/app_database.dart`

```dart
@DriftDatabase(tables: [
  Students,
  Patterns,
  ErrorTypes,
  TestSessions,
  TestResults,
  StudentAnalytics,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 1;
  
  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'math_app.sqlite'));
      return NativeDatabase(file);
    });
  }
}
```

### Table Definitions

**Location:** `core/database/tables/`

Each table in separate file:

```
tables/
├── students.dart
├── patterns.dart
├── error_types.dart
├── test_sessions.dart
├── test_results.dart
└── student_analytics.dart
```

**Table definition format:**

```dart
// core/database/tables/students.dart
class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 50)();
  TextColumn get passwordHash => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get supabaseId => text().nullable()();
}
```

**Rules:**
- Table name plural (Students, Patterns)
- Primary key always `id`
- Timestamp columns: `createdAt`, `updatedAt`, `lastSyncAt`
- Supabase ID column: `supabaseId`
- Soft delete: `deletedAt` column (nullable)

### DAO Pattern

One DAO (Data Access Object) per table:

```dart
// core/database/daos/students_dao.dart
@DriftAccessor(tables: [Students])
class StudentsDao extends DatabaseAccessor<AppDatabase> with _$StudentsDaoMixin {
  StudentsDao(AppDatabase db) : super(db);
  
  Future<List<Student>> getAllStudents() => select(students).get();
  
  Future<Student?> getStudentById(int id) {
    return (select(students)..where((s) => s.id.equals(id))).getSingleOrNull();
  }
  
  Future<int> insertStudent(StudentsCompanion student) {
    return into(students).insert(student);
  }
  
  Future<bool> updateStudent(StudentsCompanion student) {
    return update(students).replace(student);
  }
  
  Future<int> deleteStudent(int id) {
    return (delete(students)..where((s) => s.id.equals(id))).go();
  }
}
```

**DAO Rules:**
- One DAO per table
- CRUD operations (Create, Read, Update, Delete)
- Complex queries in DAO
- DAOs in `core/database/daos/`

## Pattern and Error Type Seed

### Seed Strategy

On app startup, pattern and error definitions from Dart files are written to database.

**Location:** `core/database/seed/pattern_seeder.dart`

```dart
class PatternSeeder {
  final AppDatabase _database;
  
  PatternSeeder(this._database);
  
  Future<void> seedPatterns() async {
    // Addition patterns
    await _seedModulePatterns(
      ModuleType.addition,
      AdditionPatterns.getAll(),
    );
    
    // Subtraction patterns
    await _seedModulePatterns(
      ModuleType.subtraction,
      SubtractionPatterns.getAll(),
    );
    
    // ... other modules
  }
  
  Future<void> _seedModulePatterns(
    ModuleType moduleType,
    List<PatternConfig> patterns,
  ) async {
    for (final pattern in patterns) {
      // Upsert (update if exists, insert if not)
      final existing = await _database.patternsDao.getPatternById(pattern.id);
      
      if (existing == null) {
        await _database.patternsDao.insertPattern(pattern.toCompanion());
      } else if (existing.version < pattern.version) {
        await _database.patternsDao.updatePattern(pattern.toCompanion());
      }
    }
  }
}
```

**Seed Rules:**
- Runs on every app start
- Updates if exists, inserts if not (upsert)
- Version control
- Soft delete for removed patterns

### Pattern Definition Format

**Location:** `features/{module}/data/{module}_patterns.dart`

```dart
class AdditionPatterns {
  static List<PatternConfig> getAll() => [
    PatternConfig(
      id: 'add_single_digit',
      version: 1,
      moduleType: ModuleType.addition,
      name: 'Single Digit Addition',
      description: 'Addition with numbers 1-9',
      difficulty: 1,
      minValue: 1,
      maxValue: 9,
      hasCarryOver: false,
      digitCount: 1,
    ),
    PatternConfig(
      id: 'add_two_digit_no_carry',
      version: 1,
      moduleType: ModuleType.addition,
      name: 'Two Digit (No Carry)',
      description: '10-99 addition without carry',
      difficulty: 2,
      minValue: 10,
      maxValue: 99,
      hasCarryOver: false,
      digitCount: 2,
    ),
    // ... more patterns
  ];
}
```

**Pattern Rules:**
- Each pattern has unique ID
- Version number (for updates)
- ModuleType specified
- Difficulty level 1-5

## Supabase Setup

### Supabase Service

**Location:** `core/services/supabase_service.dart`

```dart
class SupabaseService {
  late final SupabaseClient _client;
  
  SupabaseService() {
    _client = SupabaseClient(
      'YOUR_SUPABASE_URL',
      'YOUR_SUPABASE_ANON_KEY',
    );
  }
  
  SupabaseClient get client => _client;
  
  // Auth
  Future<AuthResponse> signIn(String username, String password) async {
    return await _client.auth.signInWithPassword(
      email: username,
      password: password,
    );
  }
  
  Future<AuthResponse> signUp(String username, String password) async {
    return await _client.auth.signUp(
      email: username,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  User? get currentUser => _client.auth.currentUser;
}
```

### Supabase Table Structure

Supabase tables should match Drift tables:

- `students`
- `test_sessions`
- `test_results`
- `student_analytics`

**Note:** Pattern and error types not synced to Supabase (local only).

## Sync Service

### Sync Strategy

**Location:** `core/services/sync_service.dart`

```dart
class SyncService {
  final AppDatabase _database;
  final SupabaseService _supabase;
  
  SyncService(this._database, this._supabase);
  
  // Auto sync (background)
  Future<void> startAutoSync() async {
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (await _hasInternetConnection()) {
        await syncAll();
      }
    });
  }
  
  // Manual sync
  Future<void> syncAll() async {
    await syncTestSessions();
    await syncTestResults();
    await syncStudentAnalytics();
  }
  
  Future<void> syncTestSessions() async {
    // Get unsynced sessions from Drift
    final unsyncedSessions = await _database.testSessionsDao
        .getUnsyncedSessions();
    
    for (final session in unsyncedSessions) {
      try {
        // Send to Supabase
        await _supabase.client
            .from('test_sessions')
            .upsert(session.toJson());
        
        // Update sync flag
        await _database.testSessionsDao.markAsSynced(session.id);
      } catch (e) {
        // Log error, continue
        print('Sync error: $e');
      }
    }
  }
  
  // Pull from Supabase (new device login)
  Future<void> pullFromSupabase(String studentSupabaseId) async {
    // Test sessions
    final sessions = await _supabase.client
        .from('test_sessions')
        .select()
        .eq('student_supabase_id', studentSupabaseId);
    
    for (final session in sessions) {
      await _database.testSessionsDao.insertOrUpdate(
        TestSession.fromJson(session),
      );
    }
    
    // Test results
    // Student analytics
    // ...
  }
  
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
```

**Sync Rules:**
1. **Push (Local → Supabase):**
   - Auto every 5 minutes
   - Manual sync button
   - Only unsynced records

2. **Pull (Supabase → Local):**
   - On new device login
   - Manual sync button
   - Conflict resolution: "last write wins"

3. **Conflict Resolution:**
   - Compare timestamps
   - Latest update wins
   - Show notification to user (optional)

## Database Migration

### Schema Changes

Increment `schemaVersion` when schema changes:

```dart
@override
int get schemaVersion => 2; // From 1 to 2

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        // Migration from version 1 to 2
        await m.addColumn(students, students.newColumn);
      }
    },
  );
}
```

**Migration Rules:**
- Increment version on every schema change
- Write migration logic
- Test (old version → new version)
- Have rollback plan

## Database Best Practices

1. **Use transactions**
   ```dart
   await database.transaction(() async {
     await database.studentsDao.insertStudent(student);
     await database.testSessionsDao.insertSession(session);
   });
   ```

2. **Add indexes (for performance)**
   ```dart
   class Students extends Table {
     TextColumn get username => text().withLength(min: 3, max: 50)();
     
     @override
     List<Set<Column>> get uniqueKeys => [
       {username}, // Username unique
     ];
   }
   ```

3. **Use soft delete**
   ```dart
   DateTimeColumn get deletedAt => dateTime().nullable()();
   
   // Set flag instead of deleting
   Future<void> softDeleteStudent(int id) async {
     await (update(students)..where((s) => s.id.equals(id)))
         .write(StudentsCompanion(deletedAt: Value(DateTime.now())));
   }
   ```

4. **Batch operations**
   ```dart
   await database.batch((batch) {
     batch.insertAll(students, studentList);
   });
   ```

## Provider Integration

Provide database as provider:

```dart
// core/providers/database_provider.dart
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// DAO providers
final studentsDaoProvider = Provider<StudentsDao>((ref) {
  return ref.watch(databaseProvider).studentsDao;
});
```

Use in features:

```dart
@riverpod
class AdditionPractice extends _$AdditionPractice {
  @override
  FutureOr<PracticeState> build() async {
    final database = ref.watch(databaseProvider);
    // Use database
  }
}
```

## Testing (Manual Test Notes)

When testing database:

1. **Works offline?**
   - Turn off internet
   - App works?
   - Data saves?

2. **Sync works?**
   - Turn on internet
   - Data goes to Supabase?
   - Data comes on new device?

3. **Conflict resolution works?**
   - Change same data on two devices
   - Sync
   - Correct data remains?

4. **Migration works?**
   - Load old version
   - Update to new version
   - Data not lost?
