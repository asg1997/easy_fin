import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document.dart';
import 'package:easy_fin/models/renter.dart';

DateTime normalizeRenterAssignmentMonth(DateTime date) =>
    DateTime(date.year, date.month);

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

  /// Дата начисления (первый день месяца)
  final DateTime date;

  /// Сумма начисления
  final double sum;

  /// ID арендатора
  final RenterId renterId;

  /// Номер р/с арендатора
  final AccountNumber accountNumber;
}
