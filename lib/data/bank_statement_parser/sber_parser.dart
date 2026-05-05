import 'dart:io';

import 'package:easy_fin/data/models/back_statement.dart';

class SberParser {
  Future<BankStatement> parse(File files) async {
    return BankStatement(
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      accountNumber: '1234567890',
      bankName: 'Sberbank',
      initialBalance: 0,
      finalBalance: 0,
      operations: const [],
    );
  }
}
