import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/import_expense_review.dart';
import 'package:easy_fin/models/import_income_review.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:equatable/equatable.dart';

sealed class ImportState extends Equatable {
  const ImportState();

  bool get isLoading => switch (this) {
    ImportLoading() => true,
    _ => false,
  };

  bool get isImportInProgress => switch (this) {
    ImportLoading() ||
    ImportAwaitingBase() ||
    ImportAwaitingBalanceConfirmation() ||
    ImportAwaitingOutOfOrderConfirmation() ||
    ImportAwaitingIncomeReview() ||
    ImportAwaitingExpenseReview() ||
    ImportPeriodOverlapBlocked() =>
      true,
    _ => false,
  };

  @override
  List<Object?> get props => [];
}

final class ImportIdle extends ImportState {
  const ImportIdle();
}

enum ImportLoadingPhase {
  readingFiles,
  processing,
}

final class ImportLoading extends ImportState {
  const ImportLoading({
    this.completed = 0,
    this.total = 0,
    this.phase = ImportLoadingPhase.processing,
  });

  final int completed;
  final int total;
  final ImportLoadingPhase phase;

  double? get progress => total > 0 ? completed / total : null;

  int get percent => progress == null ? 0 : (progress! * 100).round();

  String get label => switch (phase) {
    ImportLoadingPhase.readingFiles => 'Чтение файлов',
    ImportLoadingPhase.processing => 'Импорт выписок',
  };

  @override
  List<Object?> get props => [completed, total, phase];
}

final class ImportAwaitingBase extends ImportState {
  const ImportAwaitingBase({
    required this.accountNumber,
    required this.bankName,
  });

  final AccountNumber accountNumber;
  final String bankName;

  @override
  List<Object?> get props => [accountNumber, bankName];
}

final class ImportAwaitingBalanceConfirmation extends ImportState {
  const ImportAwaitingBalanceConfirmation({
    required this.previousEndDate,
    required this.previousFinalBalance,
    required this.newInitialBalance,
    required this.newStartDate,
    required this.newEndDate,
  });

  final DateTime previousEndDate;
  final double previousFinalBalance;
  final double newInitialBalance;
  final DateTime newStartDate;
  final DateTime newEndDate;

  @override
  List<Object?> get props => [
    previousEndDate,
    previousFinalBalance,
    newInitialBalance,
    newStartDate,
    newEndDate,
  ];
}

final class ImportAwaitingOutOfOrderConfirmation extends ImportState {
  const ImportAwaitingOutOfOrderConfirmation({
    required this.newStartDate,
    required this.newEndDate,
    required this.newFinalBalance,
    required this.nextStartDate,
    required this.nextEndDate,
    required this.nextInitialBalance,
    required this.hasBalanceGap,
  });

  final DateTime newStartDate;
  final DateTime newEndDate;
  final double newFinalBalance;
  final DateTime nextStartDate;
  final DateTime nextEndDate;
  final double nextInitialBalance;
  final bool hasBalanceGap;

  @override
  List<Object?> get props => [
    newStartDate,
    newEndDate,
    newFinalBalance,
    nextStartDate,
    nextEndDate,
    nextInitialBalance,
    hasBalanceGap,
  ];
}

final class ImportPeriodOverlapBlocked extends ImportState {
  const ImportPeriodOverlapBlocked({
    required this.existingStartDate,
    required this.existingEndDate,
    required this.newStartDate,
    required this.newEndDate,
  });

  final DateTime existingStartDate;
  final DateTime existingEndDate;
  final DateTime newStartDate;
  final DateTime newEndDate;

  @override
  List<Object?> get props => [
    existingStartDate,
    existingEndDate,
    newStartDate,
    newEndDate,
  ];
}

final class ImportAwaitingIncomeReview extends ImportState {
  const ImportAwaitingIncomeReview({
    required this.statement,
    required this.baseId,
    required this.baseName,
    required this.autoMatchedRenterIds,
    required this.reviewItems,
    required this.pendingExpenseResult,
  });

  final BankStatement statement;
  final BaseId baseId;
  final String baseName;
  final Map<int, String> autoMatchedRenterIds;
  final List<ImportIncomeReviewItem> reviewItems;
  final StatementExpenseReviewResult pendingExpenseResult;

  @override
  List<Object?> get props => [
    statement,
    baseId,
    baseName,
    autoMatchedRenterIds,
    reviewItems,
    pendingExpenseResult,
  ];
}

final class ImportAwaitingExpenseReview extends ImportState {
  const ImportAwaitingExpenseReview({
    required this.statement,
    required this.baseId,
    required this.baseName,
    required this.autoMatchedCategoryIds,
    required this.reviewItems,
    this.pendingRentersToSave = const [],
  });

  final BankStatement statement;
  final BaseId baseId;
  final String baseName;
  final Map<int, int> autoMatchedCategoryIds;
  final List<ImportExpenseReviewItem> reviewItems;
  final List<Renter> pendingRentersToSave;

  @override
  List<Object?> get props => [
    statement,
    baseId,
    baseName,
    autoMatchedCategoryIds,
    reviewItems,
    pendingRentersToSave,
  ];
}

final class ImportError extends ImportState {
  const ImportError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
