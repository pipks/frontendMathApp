import 'package:drift/drift.dart';
import 'students.dart';

class StudentAnalytics extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id)();
  TextColumn get moduleType => text()();
  TextColumn get analysisData => text()(); // JSON string
  DateTimeColumn get analyzedAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}
