import 'package:equatable/equatable.dart';

sealed class BankStatementImportError with EquatableMixin implements Exception {
  BankStatementImportError({
    this.message,
  });

  final String? message;
}

class BankStatementImportErrorUnknown extends BankStatementImportError {
  BankStatementImportErrorUnknown({required super.message});

  @override
  List<Object?> get props => [message];
}

class BankStatementUnknownBankError extends BankStatementImportError {
  BankStatementUnknownBankError({required super.message});

  @override
  List<Object?> get props => [message];
}
