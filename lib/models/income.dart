import 'package:easy_fin/models/income_category.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:equatable/equatable.dart';

typedef IncomeLineId = String;

/// Строка документа прихода.
class Income extends Equatable {
  const Income({
    required this.id,
    required this.sum,
    required this.incomeSource,
    this.note,
  });

  final IncomeLineId id;
  final double sum;
  final IncomeSource incomeSource;
  final String? note;

  @override
  List<Object?> get props => [id, sum, incomeSource, note];
}

/// Источник дохода
sealed class IncomeSource extends Equatable {
  const IncomeSource();
}

/// Источник дохода — арендатор
class IncomeSourceFromRenter extends IncomeSource {
  const IncomeSourceFromRenter({
    required this.renterId,
    required this.accountNumber,
  });

  final RenterId renterId;
  final String accountNumber;

  @override
  List<Object?> get props => [renterId, accountNumber];
}

/// Источник дохода — прочий (категория из справочника)
class IncomeSourceFromOther extends IncomeSource {
  const IncomeSourceFromOther({required this.categoryId});

  final IncomeCategoryId categoryId;

  @override
  List<Object?> get props => [categoryId];
}
