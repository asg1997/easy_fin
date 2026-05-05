import 'dart:io';

import 'package:easy_fin/data/bank_statement_parser/sber_parser.dart';
import 'package:easy_fin/data/bank_statement_parser/vtb_parser.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BankAccount {
  sber,
  vtb,
}

final bankStatementParserProvider = Provider<BankStatementParser>(
  BankStatementParserImpl.new,
);

/// Парсит выписки по банковскому счету из списка файлов.
/// Автоматически определяет банк по файлу
abstract class BankStatementParser {
  Future<List<BankStatement>> parse(List<File> files);
}

class BankStatementParserImpl implements BankStatementParser {
  BankStatementParserImpl(this.ref);

  final Ref ref;
  @override
  Future<List<BankStatement>> parse(List<File> files) async {
    final bankStatements = <BankStatement>[];
    for (final file in files) {
      final bankAccount = await _detectBankAccount(file);
      final bankStatement = switch (bankAccount) {
        BankAccount.sber => await SberParser().parse(file),
        BankAccount.vtb => await VtbParser().parse(file),
      };
      bankStatements.add(bankStatement);
    }
    return bankStatements;
  }

  Future<BankAccount> _detectBankAccount(
    File file,
  ) async {
    return BankAccount.sber;
  }
}
