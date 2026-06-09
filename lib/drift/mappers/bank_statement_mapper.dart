import 'package:drift/drift.dart';
import 'package:easy_fin/data/models/back_statement.dart' as domain;
import 'package:easy_fin/data/models/bank_statement_operation.dart' as domain;
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/money.dart';

extension BankStatementMapper on domain.BankStatement {
  BankStatementsCompanion toCompanion({required BaseId baseId}) {
    return BankStatementsCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      baseId: Value(baseId),
      accountNumber: Value(accountNumber),
      startDate: Value(startDate),
      endDate: Value(endDate),
      initialBalanceMinor: Value(moneyToMinor(initialBalance)),
      finalBalanceMinor: Value(moneyToMinor(finalBalance)),
    );
  }
}

extension BankStatementOperationMapper on domain.BankStatementOperation {
  BankStatementOperationsCompanion toCompanion({required int statementId}) {
    return BankStatementOperationsCompanion(
      statementId: Value(statementId),
      date: Value(date),
      debitInn: Value(debitInn),
      debitBankAccount: Value(debitBankAccount),
      creditInn: Value(creditInn),
      creditBankAccount: Value(creditBankAccount),
      debitMinor: Value(moneyToMinorNullable(debit)),
      creditMinor: Value(moneyToMinorNullable(credit)),
      note: Value(note),
    );
  }
}

extension BankStatementRowMapper on BankStatementRow {
  domain.BankStatement toDomain({
    required List<domain.BankStatementOperation> operations,
  }) {
    return domain.BankStatement(
      id: id,
      startDate: startDate,
      endDate: endDate,
      accountNumber: accountNumber,
      initialBalance: moneyFromMinor(initialBalanceMinor),
      finalBalance: moneyFromMinor(finalBalanceMinor),
      operations: operations,
    );
  }
}

extension BankStatementOperationRowMapper on BankStatementOperationRow {
  domain.BankStatementOperation toDomain() {
    return domain.BankStatementOperation(
      id: id,
      date: date,
      debitInn: debitInn,
      debitBankAccount: debitBankAccount,
      creditInn: creditInn,
      creditBankAccount: creditBankAccount,
      debit: moneyFromMinorNullable(debitMinor),
      credit: moneyFromMinorNullable(creditMinor),
      note: note,
    );
  }
}
