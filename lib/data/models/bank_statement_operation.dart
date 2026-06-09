import 'package:equatable/equatable.dart';

/// Операция в выписке по банковскому счету
class BankStatementOperation extends Equatable {
  const BankStatementOperation({
    required this.date,
    required this.debitInn,
    required this.debitBankAccount,
    required this.creditInn,
    required this.creditBankAccount,
    required this.debit,
    required this.credit,
    required this.note,
    this.id,
  });

  final DateTime date;
  final String debitInn;
  final String debitBankAccount;
  final String creditInn;
  final String creditBankAccount;
  // расходы
  final double? debit;
  // доходы
  final double? credit;
  final String note;
  final int? id;

  bool get isDebit => debit != null;
  bool get isCredit => credit != null;

  @override
  List<Object?> get props => [
    id,
    date,

    debitInn,
    debitBankAccount,
    creditInn,
    creditBankAccount,
    debit,
    credit,
    note,
  ];
}
