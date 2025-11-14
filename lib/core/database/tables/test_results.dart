import 'package:drift/drift.dart';
import 'test_sessions.dart';
import 'patterns.dart';

class TestResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(TestSessions, #id)();
  TextColumn get patternId => text().references(Patterns, #id)();
  IntColumn get operand1 => integer()();
  IntColumn get operand2 => integer()();
  IntColumn get correctAnswer => integer()();
  IntColumn get userAnswer => integer()();
  BoolColumn get isCorrect => boolean()();
  IntColumn get responseTime => integer()(); // milliseconds
  TextColumn get detectedErrorType => text().nullable()();
  DateTimeColumn get answeredAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}
