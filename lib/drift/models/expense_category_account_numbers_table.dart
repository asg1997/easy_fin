import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/bases_table.dart';
import 'package:easy_fin/drift/models/expense_categories_table.dart';

/// Р/с получателя, привязанный к категории расхода в рамках базы
class ExpenseCategoryAccountNumbers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get baseId =>
      text().references(Bases, #id, onDelete: KeyAction.cascade)();

  IntColumn get expenseCategoryId => integer().references(
    ExpenseCategories,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get accountNumber => text()();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {baseId, accountNumber},
  ];
}
