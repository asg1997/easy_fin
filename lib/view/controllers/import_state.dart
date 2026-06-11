import 'package:easy_fin/models/base.dart';
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

final class ImportLoading extends ImportState {
  const ImportLoading();
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

final class ImportError extends ImportState {
  const ImportError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
