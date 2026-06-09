import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/view/models/documents_table_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentsStorageProvider = Provider<DocumentsStorage>(
  DocumentsStorageImpl.new,
);

abstract class DocumentsStorage {
  Future<List<DocumentsTableItem>> getDocuments(
    GetStatementsFilters filters,
  );
}

class DocumentsStorageImpl implements DocumentsStorage {
  const DocumentsStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<List<DocumentsTableItem>> getDocuments(
    GetStatementsFilters filters,
  ) async {
    final statements = await ref
        .read(bankStatementStorageProvider)
        .getStatements(filters);

    if (statements.isEmpty) return [];

    final bases = await ref.read(basesStorageProvider).getAll();
    final baseByAccountNumber = <String, String>{};
    for (final base in bases) {
      for (final accountNumber in base.accountNumbers) {
        baseByAccountNumber[accountNumber] = base.name;
      }
    }

    final items = <DocumentsTableItem>[];
    for (final statement in statements) {
      final baseName = baseByAccountNumber[statement.accountNumber] ?? '';

      for (final operation in statement.operations) {
        final operationId = operation.id;
        if (operationId == null) continue;

        items.add(
          DocumentsTableItem(
            operationId: operationId,
            date: operation.date,
            documentType: _documentType(operation.isCredit),
            accountType: AccountFilterType.bank.label,
            baseName: baseName,
            amount: operation.credit ?? operation.debit ?? 0,
            note: operation.note,
          ),
        );
      }
    }

    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  DocumentType _documentType(bool isCredit) {
    return isCredit ? DocumentType.income : DocumentType.outcome;
  }
}
