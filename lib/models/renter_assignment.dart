import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document.dart';
import 'package:easy_fin/models/renter.dart';

/// Первый день месяца для группировки и выборки начислений.
DateTime normalizeRenterAssignmentMonth(DateTime date) =>
    DateTime(date.year, date.month);

/// Дата без времени.
DateTime normalizeRenterAssignmentDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Начало следующего месяца (исключающая граница диапазона).
DateTime renterAssignmentMonthEndExclusive(DateTime date) {
  final month = normalizeRenterAssignmentMonth(date);
  return DateTime(month.year, month.month + 1);
}

/// Начисление по аренде
class RenterAssignment extends Document {
  const RenterAssignment({
    required super.id,
    required super.createdAt,
    required super.baseId,
    required this.date,
    required this.sum,
    required this.renterId,
    required this.accountNumber,
  });

  factory RenterAssignment.create({
    required BaseId baseId,
    required RenterId renterId,
    required AccountNumber accountNumber,
    required DateTime date,
    required double sum,
  }) =>
      RenterAssignment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        baseId: baseId,
        renterId: renterId,
        accountNumber: accountNumber,
        date: date,
        sum: sum,
      );

  /// Дата начисления
  final DateTime date;

  /// Сумма начисления
  final double sum;

  /// ID арендатора
  final RenterId renterId;

  /// Номер р/с арендатора
  final AccountNumber accountNumber;
}
