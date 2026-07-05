import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/expense_categories_table.dart';
import 'package:easy_fin/drift/models/expense_documents_table.dart';

/// Строка документа расхода
@DataClassName('ExpenseLineRow')
class ExpenseLines extends Table {
  TextColumn get id => text()();

  TextColumn get documentId =>
      text().references(ExpenseDocuments, #id, onDelete: KeyAction.cascade)();

  IntColumn get amountMinor => integer()();

  IntColumn get categoryId => integer().references(
    ExpenseCategories,
    #id,
    onDelete: KeyAction.restrict,
  )();

  TextColumn get note => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
