import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/expense_category_accounts_storage/expense_category_accounts_storage.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/import_expense_review.dart';
import 'package:easy_fin/models/import_income_review.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final statementExpenseReviewAnalyzerProvider =
    Provider<StatementExpenseReviewAnalyzer>(
      (ref) => StatementExpenseReviewAnalyzer(
        ref.read(basesStorageProvider),
        ref.read(expenseCategoryAccountsStorageProvider),
      ),
    );

class StatementExpenseReviewAnalyzer {
  const StatementExpenseReviewAnalyzer(
    this._basesStorage,
    this._categoryAccountsStorage,
  );

  final BasesStorage _basesStorage;
  final ExpenseCategoryAccountsStorage _categoryAccountsStorage;

  Future<StatementExpenseReviewResult> analyze(
    BankStatement statement, {
    required BaseId baseId,
  }) async {
    final base = await _basesStorage.findById(baseId);
    final ownAccounts = base?.accountNumbers.toSet() ?? {statement.accountNumber};

    final autoMatchedCategoryIds = <int, int>{};
    final pendingByAccount = <String, List<_PendingOperation>>{};
    final standaloneOperations = <_PendingOperation>[];

    for (var index = 0; index < statement.operations.length; index++) {
      final operation = statement.operations[index];
      if (operation.debit == null) continue;
      if (operation.expenseCategoryId != null) continue;
      if (ownAccounts.contains(operation.creditBankAccount)) continue;

      final pending = _PendingOperation(
        index: index,
        operation: operation,
      );

      if (isValidAccountNumber(operation.creditBankAccount)) {
        pendingByAccount
            .putIfAbsent(operation.creditBankAccount, () => [])
            .add(pending);
      } else {
        standaloneOperations.add(pending);
      }
    }

    final reviewByAccount = <String, List<_PendingOperation>>{};

    for (final entry in pendingByAccount.entries) {
      final accountNumber = entry.key;
      final operations = entry.value;
      final categoryId = await _categoryAccountsStorage.findCategoryIdByAccount(
        baseId: baseId,
        accountNumber: accountNumber,
      );

      if (categoryId != null) {
        for (final pending in operations) {
          autoMatchedCategoryIds[pending.index] = categoryId;
        }
        continue;
      }

      reviewByAccount[accountNumber] = operations;
    }

    final reviewItems = <ImportExpenseReviewItem>[];

    for (final entry in reviewByAccount.entries) {
      reviewItems.add(
        ImportExpenseCounterpartyItem(
          originalAccountNumber: entry.key,
          suggestedName: _longestCounterpartyName(entry.value),
          operations: entry.value.map(_toReviewable).toList(),
        ),
      );
    }

    for (final pending in standaloneOperations) {
      reviewItems.add(
        ImportExpenseStandaloneItem(operation: _toReviewable(pending)),
      );
    }

    return StatementExpenseReviewResult(
      autoMatchedCategoryIds: autoMatchedCategoryIds,
      reviewItems: reviewItems,
    );
  }

  ReviewableOperation _toReviewable(_PendingOperation pending) {
    return ReviewableOperation(
      statementOperationIndex: pending.index,
      date: pending.operation.date,
      amount: pending.operation.debit!,
      note: pending.operation.note,
    );
  }

  String _longestCounterpartyName(List<_PendingOperation> operations) {
    var longest = '';
    for (final pending in operations) {
      final name = pending.operation.creditCounterpartyName?.trim() ?? '';
      if (name.length > longest.length) {
        longest = name;
      }
    }
    return longest;
  }
}

class _PendingOperation {
  const _PendingOperation({required this.index, required this.operation});

  final int index;
  final BankStatementOperation operation;
}

BankStatement applyExpenseClassification(
  BankStatement statement, {
  Map<int, int> autoMatchedCategoryIds = const {},
  List<ImportExpenseResolution> resolutions = const [],
}) {
  final operations = List<BankStatementOperation>.from(statement.operations);

  for (final entry in autoMatchedCategoryIds.entries) {
    operations[entry.key] = operations[entry.key].copyWith(
      expenseCategoryId: entry.value,
    );
  }

  for (final resolution in resolutions) {
    for (final index in resolution.operationIndices) {
      operations[index] = switch (resolution.classification) {
        ImportExpenseClassification.other => operations[index].copyWith(
          expenseCategoryId: resolution.expenseCategoryId,
        ),
        ImportExpenseClassification.unclassified => operations[index].copyWith(
          clearExpenseCategoryId: true,
        ),
      };
    }
  }

  return statement.copyWith(operations: operations);
}
