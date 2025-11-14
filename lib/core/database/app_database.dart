import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/students.dart';
import 'tables/patterns.dart';
import 'tables/error_types.dart';
import 'tables/test_sessions.dart';
import 'tables/test_results.dart';
import 'tables/student_analytics.dart';

part 'app_database.g.dart';

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
