import 'package:equatable/equatable.dart';

sealed class BankStatementImportError with EquatableMixin implements Exception {
  BankStatementImportError({
    this.message,
  });

  final String? message;
}

/// Неизвестный банк
class BankStatementUnknownBankError extends BankStatementImportError {
  BankStatementUnknownBankError({super.message});

  @override
  List<Object?> get props => [message];
}

/// Неизвестная ошибка при импорте выписок
class BankStatementImportErrorUnknown extends BankStatementImportError {
  BankStatementImportErrorUnknown({super.message});

  @override
  List<Object?> get props => [message];
}
