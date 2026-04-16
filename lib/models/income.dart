import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/models/transaction.dart';
import 'package:equatable/equatable.dart';

/// Доход
class Income extends Transaction {
  const Income({
    required super.id,
    required super.createdAt,
    required super.baseId,
    required super.sum,
    required super.account,
    required this.incomeSource,
    this.note,
  });

  final IncomeSource incomeSource;
  final String? note;

  @override
  List<Object?> get props => [super.id];
}

/// Источник дохода
sealed class IncomeSource extends Equatable {
  const IncomeSource();
}

/// Источник дохода - арендатор
class IncomeSourceFromRenter extends IncomeSource {
  const IncomeSourceFromRenter({required this.renterId});

  final RenterId renterId;

  @override
  List<Object?> get props => [renterId];
}

/// Источник дохода - другой
class IncomeSourceFromOther extends IncomeSource {
  const IncomeSourceFromOther({required this.name, required this.id});
  final String name;
  final int id;
  @override
  List<Object?> get props => [name, id];
}
