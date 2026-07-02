import 'package:easy_fin/models/renter.dart';
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
    this.debitCounterpartyName,
    this.renterId,
    this.incomeCategoryId,
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
  final String? debitCounterpartyName;
  final RenterId? renterId;
  final int? incomeCategoryId;

  bool get isDebit => debit != null;
  bool get isCredit => credit != null;

  BankStatementOperation copyWith({
    DateTime? date,
    String? debitInn,
    String? debitBankAccount,
    String? creditInn,
    String? creditBankAccount,
    double? debit,
    double? credit,
    String? note,
    int? id,
    String? debitCounterpartyName,
    RenterId? renterId,
    int? incomeCategoryId,
    bool clearRenterId = false,
    bool clearIncomeCategoryId = false,
  }) {
    return BankStatementOperation(
      date: date ?? this.date,
      debitInn: debitInn ?? this.debitInn,
      debitBankAccount: debitBankAccount ?? this.debitBankAccount,
      creditInn: creditInn ?? this.creditInn,
      creditBankAccount: creditBankAccount ?? this.creditBankAccount,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      note: note ?? this.note,
      id: id ?? this.id,
      debitCounterpartyName:
          debitCounterpartyName ?? this.debitCounterpartyName,
      renterId: clearRenterId ? null : (renterId ?? this.renterId),
      incomeCategoryId: clearIncomeCategoryId
          ? null
          : (incomeCategoryId ?? this.incomeCategoryId),
    );
  }

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
    debitCounterpartyName,
    renterId,
    incomeCategoryId,
  ];
}
