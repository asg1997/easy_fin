import 'package:easy_fin/models/document.dart';
import 'package:easy_fin/models/income.dart';
import 'package:equatable/equatable.dart';

typedef IncomeDocumentId = String;

/// Счёт документа прихода (общий для всех строк).
sealed class IncomeDocumentAccount extends Equatable {
  const IncomeDocumentAccount();
}

class IncomeDocumentCashAccount extends IncomeDocumentAccount {
  const IncomeDocumentCashAccount();

  @override
  List<Object?> get props => [];
}

class IncomeDocumentBankAccount extends IncomeDocumentAccount {
  const IncomeDocumentBankAccount({required this.accountNumber});

  final String accountNumber;

  @override
  List<Object?> get props => [accountNumber];
}

/// Документ ручного прихода: заголовок + строки.
class IncomeDocument extends Document {
  const IncomeDocument({
    required super.id,
    required super.createdAt,
    required super.baseId,
    required this.date,
    required this.account,
    required this.lines,
  });

  final DateTime date;
  final IncomeDocumentAccount account;
  final List<Income> lines;

  double get totalSum => lines.fold<double>(0, (sum, line) => sum + line.sum);

  @override
  List<Object?> get props => [id, createdAt, baseId, date, account, lines];
}
