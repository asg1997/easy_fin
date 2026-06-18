import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/bases_table.dart';
import 'package:easy_fin/drift/models/renters_table.dart';

/// Начисление по аренде
@DataClassName('RenterAssignmentRow')
class RenterAssignments extends Table {
  TextColumn get id => text()();

  TextColumn get baseId =>
      text().references(Bases, #id, onDelete: KeyAction.cascade)();

  TextColumn get renterId =>
      text().references(Renters, #id, onDelete: KeyAction.cascade)();

  TextColumn get accountNumber => text()();

  DateTimeColumn get date => dateTime()();

  IntColumn get amountMinor => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
