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
    this.id,
  });

  final int? id;
  final DateTime startDate;
  final DateTime endDate;
  final String accountNumber;
  final String bankName;
  final double initialBalance;
  final double finalBalance;
  final List<BankStatementOperation> operations;

  BankStatement copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    String? accountNumber,
    String? bankName,
    double? initialBalance,
    double? finalBalance,
    List<BankStatementOperation>? operations,
  }) {
    return BankStatement(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      initialBalance: initialBalance ?? this.initialBalance,
      finalBalance: finalBalance ?? this.finalBalance,
      operations: operations ?? this.operations,
    );
  }

  @override
  List<Object?> get props => [
    id,
    startDate,
    endDate,
    accountNumber,
    bankName,
    initialBalance,
    finalBalance,
    operations,
  ];
}
