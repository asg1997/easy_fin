import 'package:easy_fin/models/import_income_review.dart';
import 'package:equatable/equatable.dart';

sealed class ImportExpenseReviewItem extends Equatable {
  const ImportExpenseReviewItem();

  List<int> get operationIndices;
}

/// Группа расходов на один р/с получателя
class ImportExpenseCounterpartyItem extends ImportExpenseReviewItem {
  const ImportExpenseCounterpartyItem({
    required this.originalAccountNumber,
    required this.suggestedName,
    required this.operations,
  });

  final String originalAccountNumber;
  final String suggestedName;
  final List<ReviewableOperation> operations;

  @override
  List<int> get operationIndices =>
      operations.map((operation) => operation.statementOperationIndex).toList();

  @override
  List<Object?> get props => [
    originalAccountNumber,
    suggestedName,
    operations,
  ];
}

/// Один расход без узнаваемого получателя
class ImportExpenseStandaloneItem extends ImportExpenseReviewItem {
  const ImportExpenseStandaloneItem({required this.operation});

  final ReviewableOperation operation;

  @override
  List<int> get operationIndices => [operation.statementOperationIndex];

  @override
  List<Object?> get props => [operation];
}

class StatementExpenseReviewResult extends Equatable {
  const StatementExpenseReviewResult({
    required this.autoMatchedCategoryIds,
    required this.reviewItems,
  });

  final Map<int, int> autoMatchedCategoryIds;
  final List<ImportExpenseReviewItem> reviewItems;

  @override
  List<Object?> get props => [autoMatchedCategoryIds, reviewItems];
}

enum ImportExpenseClassification { other, unclassified }

class ImportExpenseResolution extends Equatable {
  const ImportExpenseResolution({
    required this.operationIndices,
    required this.classification,
    this.expenseCategoryId,
    this.accountNumber,
  });

  final List<int> operationIndices;
  final ImportExpenseClassification classification;
  final int? expenseCategoryId;
  final String? accountNumber;

  @override
  List<Object?> get props => [
    operationIndices,
    classification,
    expenseCategoryId,
    accountNumber,
  ];
}
