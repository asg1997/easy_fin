import 'package:equatable/equatable.dart';

/// Операция в выписке по банковскому счету
class BankStatementOperation extends Equatable {
  const BankStatementOperation({
    required this.date,
    required this.number,
    required this.operationType,
    required this.renterInn,
    required this.renterBankAccount,
    required this.debit,
    required this.credit,
    required this.note,
  });

  final DateTime date;
  final int number;
  final int operationType;
  final String renterInn;
  final String renterBankAccount;
  final double debit;
  final double credit;
  final String note;

  @override
  List<Object?> get props => [
    date,
    number,
    operationType,
    renterInn,
    renterBankAccount,
    debit,
    credit,
    note,
  ];
}
