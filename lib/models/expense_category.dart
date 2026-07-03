import 'package:equatable/equatable.dart';

typedef ExpenseCategoryId = int;

class ExpenseCategory extends Equatable {
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.isArchived,
    required this.sortOrder,
    required this.createdAt,
  });

  final ExpenseCategoryId id;
  final String name;
  final bool isArchived;
  final int sortOrder;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, name, isArchived, sortOrder, createdAt];
}
