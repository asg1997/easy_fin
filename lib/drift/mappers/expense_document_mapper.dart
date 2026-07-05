import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/expense.dart' as domain;
import 'package:easy_fin/models/expense_document.dart' as domain;
import 'package:easy_fin/utils/money.dart';

const _accountTypeCash = 'cash';
const _accountTypeBank = 'bank';

extension ExpenseDocumentMapper on domain.ExpenseDocument {
  ExpenseDocumentsCompanion toHeaderCompanion() {
    final account = this.account;
    return ExpenseDocumentsCompanion(
      id: Value(id),
      baseId: Value(baseId),
      date: Value(date),
      accountType: Value(
        account is domain.ExpenseDocumentCashAccount
            ? _accountTypeCash
            : _accountTypeBank,
      ),
      accountRef: Value(
        account is domain.ExpenseDocumentBankAccount
            ? account.accountNumber
            : '',
      ),
      createdAt: Value(createdAt),
    );
  }

  List<ExpenseLinesCompanion> toLineCompanions() {
    return lines
        .map(
          (line) => line.toCompanion(
            documentId: id,
            createdAt: createdAt,
          ),
        )
        .toList();
  }
}

extension ExpenseLineMapper on domain.Expense {
  ExpenseLinesCompanion toCompanion({
    required String documentId,
    required DateTime createdAt,
  }) {
    return ExpenseLinesCompanion(
      id: Value(id),
      documentId: Value(documentId),
      amountMinor: Value(moneyToMinor(sum)),
      categoryId: Value(categoryId),
      note: Value(note ?? ''),
      createdAt: Value(createdAt),
    );
  }
}

extension ExpenseDocumentRowMapper on ExpenseDocumentRow {
  domain.ExpenseDocument toDomain(List<ExpenseLineRow> lineRows) {
    final account = accountType == _accountTypeCash
        ? const domain.ExpenseDocumentCashAccount()
        : domain.ExpenseDocumentBankAccount(accountNumber: accountRef);

    return domain.ExpenseDocument(
      id: id,
      createdAt: createdAt,
      baseId: baseId,
      date: date,
      account: account,
      lines: lineRows.map((row) => row.toDomain()).toList(),
    );
  }
}

extension ExpenseLineRowMapper on ExpenseLineRow {
  domain.Expense toDomain() {
    return domain.Expense(
      id: id,
      sum: moneyFromMinor(amountMinor),
      categoryId: categoryId,
      note: note.isEmpty ? null : note,
    );
  }
}
