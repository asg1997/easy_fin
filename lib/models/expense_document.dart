import 'package:easy_fin/models/document.dart';
import 'package:easy_fin/models/expense.dart';
import 'package:equatable/equatable.dart';

typedef ExpenseDocumentId = String;

/// Счёт документа расхода (общий для всех строк).
sealed class ExpenseDocumentAccount extends Equatable {
  const ExpenseDocumentAccount();
}

class ExpenseDocumentCashAccount extends ExpenseDocumentAccount {
  const ExpenseDocumentCashAccount();

  @override
  List<Object?> get props => [];
}

class ExpenseDocumentBankAccount extends ExpenseDocumentAccount {
  const ExpenseDocumentBankAccount({required this.accountNumber});

  final String accountNumber;

  @override
  List<Object?> get props => [accountNumber];
}

/// Документ ручного расхода: заголовок + строки.
class ExpenseDocument extends Document {
  const ExpenseDocument({
    required super.id,
    required super.createdAt,
    required super.baseId,
    required this.date,
    required this.account,
    required this.lines,
  });

  final DateTime date;
  final ExpenseDocumentAccount account;
  final List<Expense> lines;

  double get totalSum => lines.fold<double>(0, (sum, line) => sum + line.sum);

  @override
  List<Object?> get props => [id, createdAt, baseId, date, account, lines];
}
