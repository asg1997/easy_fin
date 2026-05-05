import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:equatable/equatable.dart';

/// Выписка по банковскому счету
class BankStatement extends Equatable {
  const BankStatement({
    required this.startDate,
    required this.endDate,
    required this.accountNumber,
    required this.bankName,
    required this.initialBalance,
    required this.finalBalance,
    required this.operations,
  });

  final DateTime startDate;
  final DateTime endDate;
  final String accountNumber;
  final String bankName;
  final double initialBalance;
  final double finalBalance;
  final List<BankStatementOperation> operations;

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    accountNumber,
    bankName,
    initialBalance,
    finalBalance,
  ];
}
