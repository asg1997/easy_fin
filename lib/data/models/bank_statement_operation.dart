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
    this.creditCounterpartyName,
    this.renterId,
    this.incomeCategoryId,
    this.expenseCategoryId,
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
  final String? creditCounterpartyName;
  final RenterId? renterId;
  final int? incomeCategoryId;
  final int? expenseCategoryId;

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
    String? creditCounterpartyName,
    RenterId? renterId,
    int? incomeCategoryId,
    int? expenseCategoryId,
    bool clearRenterId = false,
    bool clearIncomeCategoryId = false,
    bool clearExpenseCategoryId = false,
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
      creditCounterpartyName:
          creditCounterpartyName ?? this.creditCounterpartyName,
      renterId: clearRenterId ? null : (renterId ?? this.renterId),
      incomeCategoryId: clearIncomeCategoryId
          ? null
          : (incomeCategoryId ?? this.incomeCategoryId),
      expenseCategoryId: clearExpenseCategoryId
          ? null
          : (expenseCategoryId ?? this.expenseCategoryId),
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
    creditCounterpartyName,
    renterId,
    incomeCategoryId,
    expenseCategoryId,
  ];
}
