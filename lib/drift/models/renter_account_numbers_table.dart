import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/renters_table.dart';

/// Банковский счёт, привязанный к арендатору
class RenterAccountNumbers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get renterId =>
      text().references(Renters, #id, onDelete: KeyAction.cascade)();

  TextColumn get accountNumber => text().unique()();
}
