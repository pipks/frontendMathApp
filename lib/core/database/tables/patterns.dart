import 'package:drift/drift.dart';

class Patterns extends Table {
  TextColumn get id => text()();
  IntColumn get version => integer()();
  TextColumn get moduleType => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get difficulty => integer()();
  IntColumn get minValue => integer()();
  IntColumn get maxValue => integer()();
  BoolColumn get hasCarryOver => boolean()();
  IntColumn get digitCount => integer()();
  TextColumn get metadata => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
