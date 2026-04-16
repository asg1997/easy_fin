import 'package:equatable/equatable.dart';

typedef AccountTypeId = String;

/// Расчетный счет
sealed class Account extends Equatable {
  const Account({required this.id});

  final AccountTypeId id;
}

/// Кассовый счет
class CashAccount extends Account {
  const CashAccount({required super.id});

  @override
  List<Object?> get props => throw UnimplementedError();
}

/// Банковский счет
class BankAccount extends Account {
  const BankAccount({
    required super.id,
    required this.accountNumber,
    required this.name,
  });
  final int accountNumber;
  final String name;
  @override
  List<Object?> get props => throw UnimplementedError();
}
