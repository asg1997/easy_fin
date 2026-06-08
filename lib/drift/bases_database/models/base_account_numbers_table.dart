import 'package:drift/drift.dart';
import 'package:easy_fin/drift/bases_database/models/bases_table.dart';

/// Банковский счёт, привязанный к базе
class BaseAccountNumbers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get baseId =>
      text().references(Bases, #id, onDelete: KeyAction.cascade)();

  TextColumn get accountNumber => text().unique()();
}
