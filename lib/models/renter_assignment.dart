import 'package:easy_fin/models/document.dart';
import 'package:easy_fin/models/renter.dart';

/// Начисление по аренде
class RenterAssignment extends Document {
  const RenterAssignment({
    required super.id,
    required super.createdAt,
    required super.baseId,
    required this.sum,
    required this.renterId,
  });

  /// Сумма начисления
  final double sum;

  /// ID арендатора
  final RenterId renterId;
}
