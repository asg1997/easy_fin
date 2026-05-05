import 'dart:io';

import 'package:easy_fin/data/models/back_statement.dart';

class VtbParser {
  Future<BankStatement> parse(File file) async {
    return BankStatement(
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      accountNumber: '1234567890',
      bankName: 'VTB',
      initialBalance: 0,
      finalBalance: 0,
      operations: const [],
    );
  }
}
