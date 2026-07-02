import 'package:equatable/equatable.dart';

sealed class ImportIncomeReviewItem extends Equatable {
  const ImportIncomeReviewItem();

  List<int> get operationIndices;
}

/// Группа приходов с одного р/с
class ImportIncomeCounterpartyItem extends ImportIncomeReviewItem {
  const ImportIncomeCounterpartyItem({
    required this.originalAccountNumber,
    required this.suggestedName,
    required this.operations,
    this.otherBaseRenterName,
  });

  final String originalAccountNumber;
  final String suggestedName;
  final List<ReviewableOperation> operations;
  final String? otherBaseRenterName;

  @override
  List<int> get operationIndices =>
      operations.map((operation) => operation.statementOperationIndex).toList();

  @override
  List<Object?> get props => [
    originalAccountNumber,
    suggestedName,
    operations,
    otherBaseRenterName,
  ];
}

/// Один приход без узнаваемого контрагента
class ImportIncomeStandaloneItem extends ImportIncomeReviewItem {
  const ImportIncomeStandaloneItem({required this.operation});

  final ReviewableOperation operation;

  @override
  List<int> get operationIndices => [operation.statementOperationIndex];

  @override
  List<Object?> get props => [operation];
}

class ReviewableOperation extends Equatable {
  const ReviewableOperation({
    required this.statementOperationIndex,
    required this.date,
    required this.amount,
    required this.note,
  });

  final int statementOperationIndex;
  final DateTime date;
  final double amount;
  final String note;

  @override
  List<Object?> get props => [
    statementOperationIndex,
    date,
    amount,
    note,
  ];
}

class StatementIncomeReviewResult extends Equatable {
  const StatementIncomeReviewResult({
    required this.autoMatchedRenterIds,
    required this.reviewItems,
  });

  final Map<int, String> autoMatchedRenterIds;
  final List<ImportIncomeReviewItem> reviewItems;

  @override
  List<Object?> get props => [autoMatchedRenterIds, reviewItems];
}

enum ImportIncomeClassification { renter, other, unclassified }

enum ImportRenterAction { create, link }

enum ImportCategoryAction { select, create }

class ImportIncomeResolution extends Equatable {
  const ImportIncomeResolution({
    required this.operationIndices,
    required this.classification,
    this.name,
    this.accountNumber,
    this.renterAction,
    this.linkedRenterId,
    this.incomeCategoryId,
  });

  final List<int> operationIndices;
  final ImportIncomeClassification classification;
  final String? name;
  final String? accountNumber;
  final ImportRenterAction? renterAction;
  final String? linkedRenterId;
  final int? incomeCategoryId;

  @override
  List<Object?> get props => [
    operationIndices,
    classification,
    name,
    accountNumber,
    renterAction,
    linkedRenterId,
    incomeCategoryId,
  ];
}
