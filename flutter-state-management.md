# Flutter State Management Rules

## State Management Approach

**Riverpod** is used. Modern, simple and powerful state management solution.

**Why Riverpod?**
- Simpler than Bloc
- Less boilerplate code
- Excellent for async operations
- Suitable for AI assistant collaboration
- Compile-time safety

## Provider Types

### AsyncNotifierProvider (Preferred)

Use for async operations (database, API calls).

**When to use:**
- Database read/write
- Supabase operations
- Complex state management
- Loading/error states needed

**Example:**
```dart
@riverpod
class AdditionPractice extends _$AdditionPractice {
  @override
  FutureOr<PracticeState> build() async {
    // Load initial state
    return PracticeState.initial();
  }
  
  Future<void> startPractice() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Logic
      return newState;
    });
  }
}
```

### StateProvider (Simple State)

Use for simple, synchronous state.

**When to use:**
- Simple value storage (counter, toggle)
- Synchronous operations
- UI state (selected tab, open/closed)

**Example:**
```dart
final selectedModuleProvider = StateProvider<ModuleType?>((ref) => null);
```

### Provider (Read-Only)

For immutable values or service instances.

**When to use:**
- Service instances
- Repository instances
- Constant values

**Example:**
```dart
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final questionEngineProvider = Provider<QuestionEngine>((ref) {
  return QuestionEngine(ref.watch(databaseProvider));
});
```

## Provider Organization

### File Structure

Each feature's providers in its own folder:

```
features/{feature_name}/providers/
├── {feature_name}_provider.dart
├── {screen_name}_provider.dart
└── {specific_logic}_provider.dart
```

### Naming Rules

**File name:** `snake_case`
```
addition_practice_provider.dart
home_provider.dart
auth_provider.dart
```

**Provider name:** `camelCase` + `Provider` suffix
```dart
final additionPracticeProvider = ...
final homeProvider = ...
final authProvider = ...
```

**Class name (NotifierProvider):** `PascalCase`
```dart
class AdditionPractice extends _$AdditionPractice { }
class HomeController extends _$HomeController { }
```

## Provider Usage Rules

### 1. One Provider Per Screen

Each screen should have its own provider.

**❌ Wrong:**
```dart
// Multiple screens using same provider
final sharedProvider = ...
```

**✅ Correct:**
```dart
// Each screen has its own provider
final additionPracticeProvider = ...
final additionTimedProvider = ...
```

### 2. Provider Scope

**Feature-level provider:**
- Used within feature
- In `features/{feature}/providers/`

**Global provider:**
- Used in multiple features
- In `core/` at appropriate location

**Example:**
```dart
// Global - core/providers/auth_provider.dart
final authProvider = ...

// Feature-level - features/addition/providers/
final additionPracticeProvider = ...
```

### 3. Provider Dependencies

Providers can use each other:

```dart
@riverpod
class AdditionPractice extends _$AdditionPractice {
  @override
  FutureOr<PracticeState> build() async {
    // Use other providers
    final database = ref.watch(databaseProvider);
    final questionEngine = ref.watch(questionEngineProvider);
    final adaptiveEngine = ref.watch(adaptiveEngineProvider);
    
    // Logic
  }
}
```

## State Model Rules

### State Class Definition

One state class per provider:

```dart
// models/practice_state.dart
class PracticeState {
  final Question? currentQuestion;
  final int score;
  final int totalQuestions;
  final bool isCompleted;
  
  const PracticeState({
    this.currentQuestion,
    required this.score,
    required this.totalQuestions,
    required this.isCompleted,
  });
  
  factory PracticeState.initial() {
    return const PracticeState(
      score: 0,
      totalQuestions: 0,
      isCompleted: false,
    );
  }
  
  PracticeState copyWith({
    Question? currentQuestion,
    int? score,
    int? totalQuestions,
    bool? isCompleted,
  }) {
    return PracticeState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
```

### Freezed Usage (Optional)

Use Freezed for less boilerplate:

```dart
@freezed
class PracticeState with _$PracticeState {
  const factory PracticeState({
    Question? currentQuestion,
    required int score,
    required int totalQuestions,
    required bool isCompleted,
  }) = _PracticeState;
  
  factory PracticeState.initial() {
    return const PracticeState(
      score: 0,
      totalQuestions: 0,
      isCompleted: false,
    );
  }
}
```

## Using Providers in Widgets

### Use ConsumerWidget

Use ConsumerWidget instead of StatelessWidget:

```dart
class AdditionPracticeScreen extends ConsumerWidget {
  const AdditionPracticeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practiceState = ref.watch(additionPracticeProvider);
    
    return practiceState.when(
      data: (state) => _buildContent(state, ref),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
  
  Widget _buildContent(PracticeState state, WidgetRef ref) {
    // UI
  }
}
```

### ref.watch vs ref.read vs ref.listen

**ref.watch** - For widget rebuild:
```dart
// Widget rebuilds
final state = ref.watch(additionPracticeProvider);
```

**ref.read** - One-time read (in event handlers):
```dart
// In button onPressed
onPressed: () {
  ref.read(additionPracticeProvider.notifier).startPractice();
}
```

**ref.listen** - For side effects:
```dart
ref.listen(additionPracticeProvider, (previous, next) {
  next.whenData((state) {
    if (state.isCompleted) {
      // Navigate or show snackbar
      context.go('/results');
    }
  });
});
```

## Async State Management

### Loading State

```dart
Future<void> loadData() async {
  state = const AsyncValue.loading();
  
  state = await AsyncValue.guard(() async {
    // Async operation
    final data = await database.getData();
    return data;
  });
}
```

### Error Handling

```dart
Future<void> submitAnswer(int answer) async {
  state = await AsyncValue.guard(() async {
    try {
      // Logic
      return newState;
    } catch (e) {
      // Log error
      rethrow;
    }
  });
}
```

### Optimistic Update

```dart
Future<void> saveProgress() async {
  final currentState = state.value;
  
  // Update UI first
  state = AsyncValue.data(currentState!.copyWith(isSaved: true));
  
  // Then save to database
  try {
    await database.saveProgress(currentState);
  } catch (e) {
    // Rollback on error
    state = AsyncValue.data(currentState.copyWith(isSaved: false));
  }
}
```

## Provider Best Practices

1. **Keep providers small**
   - Single responsibility principle
   - Move to service layer if too much logic

2. **State should be immutable**
   - Don't modify state directly
   - Always create new instance (copyWith)

3. **Separate side effects**
   - Navigation, snackbar with ref.listen
   - State change and UI update separate

4. **Provider dispose**
   - Riverpod auto-disposes
   - Use `ref.onDispose` if manual dispose needed

5. **Minimize global state**
   - Only truly global state should be global
   - Feature-specific state stays in feature

## Example Provider Structure

```dart
// features/addition/providers/addition_practice_provider.dart

@riverpod
class AdditionPractice extends _$AdditionPractice {
  late final QuestionEngine _questionEngine;
  late final AdaptiveEngine _adaptiveEngine;
  late final AppDatabase _database;
  
  @override
  FutureOr<PracticeState> build() async {
    // Dependencies
    _questionEngine = ref.watch(questionEngineProvider);
    _adaptiveEngine = ref.watch(adaptiveEngineProvider);
    _database = ref.watch(databaseProvider);
    
    // Initial state
    return PracticeState.initial();
  }
  
  Future<void> startPractice() async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      // Get recommendations from adaptive engine
      final recommendations = await _adaptiveEngine.getRecommendations(
        studentId: 1,
        moduleType: ModuleType.addition,
      );
      
      // Generate first question
      final question = await _questionEngine.generateQuestion(
        recommendations: recommendations,
      );
      
      return PracticeState.initial().copyWith(
        currentQuestion: question,
      );
    });
  }
  
  Future<void> submitAnswer(int answer) async {
    final currentState = state.value;
    if (currentState == null) return;
    
    state = await AsyncValue.guard(() async {
      final isCorrect = currentState.currentQuestion!.checkAnswer(answer);
      
      // Save to database
      await _database.saveAnswer(
        questionId: currentState.currentQuestion!.id,
        answer: answer,
        isCorrect: isCorrect,
      );
      
      // Generate new question
      final nextQuestion = await _questionEngine.generateQuestion(
        recommendations: await _adaptiveEngine.getRecommendations(
          studentId: 1,
          moduleType: ModuleType.addition,
        ),
      );
      
      return currentState.copyWith(
        currentQuestion: nextQuestion,
        score: isCorrect ? currentState.score + 1 : currentState.score,
        totalQuestions: currentState.totalQuestions + 1,
      );
    });
  }
}
```
