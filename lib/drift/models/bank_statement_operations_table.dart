import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/bank_statements_table.dart';
import 'package:easy_fin/drift/models/expense_categories_table.dart';
import 'package:easy_fin/drift/models/income_categories_table.dart';
import 'package:easy_fin/drift/models/renters_table.dart';

/// Операция в выписке по банковскому счету
@DataClassName('BankStatementOperationRow')
class BankStatementOperations extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get statementId =>
      integer().references(BankStatements, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get date => dateTime()();

  TextColumn get debitInn => text()();

  TextColumn get debitBankAccount => text()();

  TextColumn get creditInn => text()();

  TextColumn get creditBankAccount => text()();

  IntColumn get debitMinor => integer().nullable()();

  IntColumn get creditMinor => integer().nullable()();

  TextColumn get note => text()();

  TextColumn get renterId =>
      text().nullable().references(Renters, #id, onDelete: KeyAction.setNull)();

  IntColumn get incomeCategoryId => integer().nullable().references(
    IncomeCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();

  IntColumn get expenseCategoryId => integer().nullable().references(
    ExpenseCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();
}
