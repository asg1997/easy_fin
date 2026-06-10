import 'package:easy_fin/models/base.dart';
import 'package:equatable/equatable.dart';

sealed class ImportState extends Equatable {
  const ImportState();

  bool get isLoading => switch (this) {
    ImportLoading() => true,
    _ => false,
  };

  bool get isImportInProgress => switch (this) {
    ImportLoading() || ImportAwaitingBase() => true,
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

final class ImportError extends ImportState {
  const ImportError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
