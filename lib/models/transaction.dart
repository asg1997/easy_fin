import 'package:easy_fin/models/account.dart';
import 'package:easy_fin/models/document.dart';

class Transaction extends Document {
  const Transaction({
    required super.id,
    required super.createdAt,
    required super.baseId,
    required this.sum,
    required this.account,
  });

  final double sum;
  final Account account;
}
