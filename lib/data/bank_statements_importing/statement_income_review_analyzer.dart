import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/import_income_review.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final statementIncomeReviewAnalyzerProvider =
    Provider<StatementIncomeReviewAnalyzer>(
      (ref) => StatementIncomeReviewAnalyzer(ref.read(rentersStorageProvider)),
    );

class StatementIncomeReviewAnalyzer {
  const StatementIncomeReviewAnalyzer(this._rentersStorage);

  final RentersStorage _rentersStorage;

  Future<StatementIncomeReviewResult> analyze(
    BankStatement statement, {
    required BaseId baseId,
  }) async {
    final autoMatchedRenterIds = <int, String>{};
    final pendingByAccount = <String, List<_PendingOperation>>{};
    final standaloneOperations = <_PendingOperation>[];

    for (var index = 0; index < statement.operations.length; index++) {
      final operation = statement.operations[index];
      if (operation.credit == null) continue;
      if (operation.debitBankAccount == statement.accountNumber) continue;

      final pending = _PendingOperation(
        index: index,
        operation: operation,
      );

      if (isValidAccountNumber(operation.debitBankAccount)) {
        pendingByAccount
            .putIfAbsent(operation.debitBankAccount, () => [])
            .add(pending);
      } else {
        standaloneOperations.add(pending);
      }
    }

    final reviewByAccount = <String, List<_PendingOperation>>{};

    for (final entry in pendingByAccount.entries) {
      final accountNumber = entry.key;
      final operations = entry.value;
      final renter = await _rentersStorage.findByAccount(accountNumber);

      if (renter != null && renter.baseId == baseId) {
        for (final pending in operations) {
          autoMatchedRenterIds[pending.index] = renter.id;
        }
        continue;
      }

      reviewByAccount[accountNumber] = operations;
    }

    final reviewItems = <ImportIncomeReviewItem>[];

    for (final entry in reviewByAccount.entries) {
      final accountNumber = entry.key;
      final operations = entry.value;
      final renter = await _rentersStorage.findByAccount(accountNumber);

      reviewItems.add(
        ImportIncomeCounterpartyItem(
          originalAccountNumber: accountNumber,
          suggestedName: _longestCounterpartyName(operations),
          operations: operations.map(_toReviewable).toList(),
          otherBaseRenterName:
              renter != null && renter.baseId != baseId ? renter.name : null,
        ),
      );
    }

    for (final pending in standaloneOperations) {
      reviewItems.add(
        ImportIncomeStandaloneItem(operation: _toReviewable(pending)),
      );
    }

    return StatementIncomeReviewResult(
      autoMatchedRenterIds: autoMatchedRenterIds,
      reviewItems: reviewItems,
    );
  }

  ReviewableOperation _toReviewable(_PendingOperation pending) {
    return ReviewableOperation(
      statementOperationIndex: pending.index,
      date: pending.operation.date,
      amount: pending.operation.credit!,
      note: pending.operation.note,
    );
  }

  String _longestCounterpartyName(List<_PendingOperation> operations) {
    var longest = '';
    for (final pending in operations) {
      final name = pending.operation.debitCounterpartyName?.trim() ?? '';
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

BankStatement applyIncomeClassification(
  BankStatement statement, {
  required Map<int, String> autoMatchedRenterIds,
  List<ImportIncomeResolution> resolutions = const [],
}) {
  final operations = List<BankStatementOperation>.from(statement.operations);

  for (final entry in autoMatchedRenterIds.entries) {
    operations[entry.key] = operations[entry.key].copyWith(
      renterId: entry.value,
      clearIncomeCategoryId: true,
    );
  }

  for (final resolution in resolutions) {
    for (final index in resolution.operationIndices) {
      operations[index] = switch (resolution.classification) {
        ImportIncomeClassification.renter => operations[index].copyWith(
          renterId: resolution.linkedRenterId,
          clearIncomeCategoryId: true,
        ),
        ImportIncomeClassification.other => operations[index].copyWith(
          incomeCategoryId: resolution.incomeCategoryId,
          clearRenterId: true,
        ),
        ImportIncomeClassification.unclassified => operations[index].copyWith(
          clearRenterId: true,
          clearIncomeCategoryId: true,
        ),
      };
    }
  }

  return statement.copyWith(operations: operations);
}
