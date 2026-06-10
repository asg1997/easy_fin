import 'dart:io';

import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/sber_parser.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/vtb_parser.dart';
import 'package:easy_fin/data/bank_statements_importing/errors/bank_statement_import_error.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/models/bank_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BankAccount {
  sber,
  vtb,
}

extension BankAccountLabel on BankAccount {
  String get label => switch (this) {
    BankAccount.sber => BankName.sber,
    BankAccount.vtb => BankName.vtb,
  };
}

final bankStatementParserProvider = Provider<BankStatementParser>(
  BankStatementParserImpl.new,
);

/// Парсит выписки по банковскому счету из списка файлов.
/// Автоматически определяет банк по файлу
/// Выбрасывает ошибку [BankStatementImportError].
///
/// Если банк не определен, выбрасывает ошибку [BankStatementUnknownBankError].
///
/// Если возникает другая ошибка, выбрасывает ошибку [BankStatementImportErrorUnknown].
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
      bankStatements.add(
        bankStatement.copyWith(bankName: bankAccount.label),
      );
    }
    return bankStatements;
  }

  Future<BankAccount> _detectBankAccount(
    File file,
  ) async {
    final lowerCasePath = file.path.toLowerCase();

    if (lowerCasePath.contains('sber') || lowerCasePath.contains('сбер')) {
      return BankAccount.sber;
    }
    if (lowerCasePath.contains('vtb') || lowerCasePath.contains('втб')) {
      return BankAccount.vtb;
    }
    throw BankStatementUnknownBankError(
      message: 'Неизвестный банк: $lowerCasePath',
    );
  }
}
