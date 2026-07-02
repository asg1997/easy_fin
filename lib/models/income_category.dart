import 'package:equatable/equatable.dart';

typedef IncomeCategoryId = int;

class IncomeCategory extends Equatable {
  const IncomeCategory({
    required this.id,
    required this.name,
    required this.isArchived,
    required this.sortOrder,
    required this.createdAt,
  });

  final IncomeCategoryId id;
  final String name;
  final bool isArchived;
  final int sortOrder;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, name, isArchived, sortOrder, createdAt];
}
