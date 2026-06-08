import 'package:drift/drift.dart';
import 'package:easy_fin/drift/bank_statement_database/models/bank_statements_table.dart';

/// Операция в выписке по банковскому счету
class BankStatementOperations extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get statementId =>
      integer().references(BankStatements, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get date => dateTime()();

  TextColumn get debitInn => text()();

  TextColumn get debitBankAccount => text()();

  TextColumn get creditInn => text()();

  TextColumn get creditBankAccount => text()();

  RealColumn get debit => real().nullable()();

  RealColumn get credit => real().nullable()();

  TextColumn get note => text()();
}
