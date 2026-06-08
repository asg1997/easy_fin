import 'package:drift/drift.dart';
import 'package:easy_fin/data/models/back_statement.dart' as domain;
import 'package:easy_fin/data/models/bank_statement_operation.dart' as domain;
import 'package:easy_fin/drift/bank_statement_database/db/bank_statement_database.dart';

extension BankStatementMapper on domain.BankStatement {
  BankStatementsCompanion toCompanion() {
    return BankStatementsCompanion(
      startDate: Value(startDate),
      endDate: Value(endDate),
      accountNumber: Value(accountNumber),
      initialBalance: Value(initialBalance),
      finalBalance: Value(finalBalance),
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
      debit: Value(debit),
      credit: Value(credit),
      note: Value(note),
    );
  }
}

extension BankStatementRowMapper on BankStatement {
  domain.BankStatement toDomain({
    required List<domain.BankStatementOperation> operations,
  }) {
    return domain.BankStatement(
      startDate: startDate,
      endDate: endDate,
      accountNumber: accountNumber,
      initialBalance: initialBalance,
      finalBalance: finalBalance,
      operations: operations,
    );
  }
}

extension BankStatementOperationRowMapper on BankStatementOperation {
  domain.BankStatementOperation toDomain() {
    return domain.BankStatementOperation(
      date: date,
      debitInn: debitInn,
      debitBankAccount: debitBankAccount,
      creditInn: creditInn,
      creditBankAccount: creditBankAccount,
      debit: debit,
      credit: credit,
      note: note,
    );
  }
}
