import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/bases_table.dart';

/// Арендатор
@DataClassName('RenterRow')
class Renters extends Table {
  TextColumn get id => text()();

  TextColumn get baseId =>
      text().references(Bases, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()();

  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
