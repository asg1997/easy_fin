import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:equatable/equatable.dart';

typedef RenterAssignmentDocumentId = String;
typedef RenterAssignmentLineId = String;

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

/// Документ начисления по аренде: заголовок + строки.
class RenterAssignmentDocument extends Document {
  const RenterAssignmentDocument({
    required super.id,
    required super.createdAt,
    required super.baseId,
    required this.date,
    required this.lines,
  });

  /// Дата начисления
  final DateTime date;

  final List<RenterAssignmentLine> lines;

  double get totalSum => lines.fold<double>(0, (sum, line) => sum + line.sum);

  @override
  List<Object?> get props => [id, createdAt, baseId, date, lines];
}

/// Строка документа начисления по аренде.
class RenterAssignmentLine extends Equatable {
  const RenterAssignmentLine({
    required this.id,
    required this.renterId,
    required this.accountNumber,
    required this.sum,
  });

  final RenterAssignmentLineId id;

  /// ID арендатора
  final RenterId renterId;

  /// Номер р/с арендатора (пусто — общее начисление без привязки к р/с)
  final AccountNumber accountNumber;

  /// Сумма начисления
  final double sum;

  @override
  List<Object?> get props => [id, renterId, accountNumber, sum];
}
