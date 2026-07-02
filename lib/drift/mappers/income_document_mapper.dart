import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/income.dart' as domain;
import 'package:easy_fin/models/income_document.dart' as domain;
import 'package:easy_fin/utils/money.dart';

const _sourceTypeRenter = 'renter';
const _sourceTypeOther = 'other';
const _accountTypeCash = 'cash';
const _accountTypeBank = 'bank';

extension IncomeDocumentMapper on domain.IncomeDocument {
  IncomeDocumentsCompanion toHeaderCompanion() {
    final account = this.account;
    return IncomeDocumentsCompanion(
      id: Value(id),
      baseId: Value(baseId),
      date: Value(date),
      accountType: Value(
        account is domain.IncomeDocumentCashAccount
            ? _accountTypeCash
            : _accountTypeBank,
      ),
      accountRef: Value(
        account is domain.IncomeDocumentBankAccount
            ? account.accountNumber
            : '',
      ),
      createdAt: Value(createdAt),
    );
  }

  List<IncomeLinesCompanion> toLineCompanions() {
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

extension IncomeLineMapper on domain.Income {
  IncomeLinesCompanion toCompanion({
    required String documentId,
    required DateTime createdAt,
  }) {
    final source = incomeSource;
    return IncomeLinesCompanion(
      id: Value(id),
      documentId: Value(documentId),
      amountMinor: Value(moneyToMinor(sum)),
      sourceType: Value(
        source is domain.IncomeSourceFromRenter
            ? _sourceTypeRenter
            : _sourceTypeOther,
      ),
      renterId: Value(
        source is domain.IncomeSourceFromRenter ? source.renterId : null,
      ),
      accountNumber: Value(
        source is domain.IncomeSourceFromRenter ? source.accountNumber : null,
      ),
      categoryId: Value(
        source is domain.IncomeSourceFromOther ? source.categoryId : null,
      ),
      note: Value(note ?? ''),
      createdAt: Value(createdAt),
    );
  }
}

extension IncomeDocumentRowMapper on IncomeDocumentRow {
  domain.IncomeDocument toDomain(List<IncomeLineRow> lineRows) {
    final account = accountType == _accountTypeCash
        ? const domain.IncomeDocumentCashAccount()
        : domain.IncomeDocumentBankAccount(accountNumber: accountRef);

    return domain.IncomeDocument(
      id: id,
      createdAt: createdAt,
      baseId: baseId,
      date: date,
      account: account,
      lines: lineRows.map((row) => row.toDomain()).toList(),
    );
  }
}

extension IncomeLineRowMapper on IncomeLineRow {
  domain.Income toDomain() {
    final source = sourceType == _sourceTypeRenter
        ? domain.IncomeSourceFromRenter(
            renterId: renterId!,
            accountNumber: accountNumber ?? '',
          )
        : domain.IncomeSourceFromOther(categoryId: categoryId!);

    return domain.Income(
      id: id,
      sum: moneyFromMinor(amountMinor),
      incomeSource: source,
      note: note.isEmpty ? null : note,
    );
  }
}
