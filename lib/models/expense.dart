import 'package:easy_fin/models/expense_category.dart';
import 'package:equatable/equatable.dart';

typedef ExpenseLineId = String;

/// Строка документа расхода.
class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.sum,
    required this.categoryId,
    this.note,
  });

  final ExpenseLineId id;
  final double sum;
  final ExpenseCategoryId categoryId;
  final String? note;

  @override
  List<Object?> get props => [id, sum, categoryId, note];
}
