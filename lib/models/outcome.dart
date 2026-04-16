import 'package:easy_fin/models/transaction.dart';

class Outcome extends Transaction {
  const Outcome({
    required super.id,
    required super.createdAt,
    required super.baseId,
    required super.sum,
    required super.account,
  });
}

enum OutcomeType {
  /// Затрата
  outcome,

  /// Перевод на другой счет
  transfer,

  /// Получение прибыли (вывод средств)
  profit,
}
