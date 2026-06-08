import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/base_account_numbers_table.dart';
import 'package:easy_fin/drift/models/bases_table.dart';

/// Выписка по банковскому счету
@DataClassName('BankStatementRow')
@TableIndex(
  name: 'bank_statements_account_period',
  columns: {#accountNumber, #startDate, #endDate},
  unique: true,
)
@TableIndex(
  name: 'bank_statements_base_start_date',
  columns: {#baseId, #startDate},
)
class BankStatements extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get baseId =>
      text().references(Bases, #id, onDelete: KeyAction.cascade)();

  TextColumn get accountNumber => text().references(
    BaseAccountNumbers,
    #accountNumber,
    onDelete: KeyAction.restrict,
  )();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime()();

  IntColumn get initialBalanceMinor => integer()();

  IntColumn get finalBalanceMinor => integer()();
}
