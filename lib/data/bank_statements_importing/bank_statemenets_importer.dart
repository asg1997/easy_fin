import 'dart:io';

import 'package:easy_fin/data/bank_statements_importing/bank_statement_import_validator.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/bank_statement_parser.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/xls2_cvs_converter.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/xlsx2_csv_converter.dart';
import 'package:easy_fin/data/bank_statements_importing/errors/bank_statement_import_error.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/models/bank_statement_import_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BankStatementResult = List<BankStatement>;

final bankStatementsImporterProvider = Provider<BankStatementsImporter>(
  (ref) => BankStatementsImporterImpl(
    ref.read(bankStatementParserProvider),
    Xls2CvsConverter.instance,
    Xlsx2CsvConverter.instance,
    const BankStatementImportValidator(),
  ),
);

/// Импортер выписок по банковскому счету
///
/// Выбрасывает ошибку [BankStatementImportError].
///
/// При ошибке конвертации `.xls` — [Xls2CvsConverterError],
/// при ошибке чтения `.xlsx` — [Xlsx2CsvConverterError].
abstract class BankStatementsImporter {
  Future<BankStatementResult> import(BankStatementImportRequest request);
}

class BankStatementsImporterImpl implements BankStatementsImporter {
  BankStatementsImporterImpl(
    this._bankStatementParser,
    this._xls2CsvConverter,
    this._xlsx2CsvConverter,
    this._importValidator,
  );

  final BankStatementParser _bankStatementParser;
  final Xls2CvsConverter _xls2CsvConverter;
  final Xlsx2CsvConverter _xlsx2CsvConverter;
  final BankStatementImportValidator _importValidator;

  @override
  Future<BankStatementResult> import(BankStatementImportRequest request) async {
    final csvGroups = await Future.wait(
      request.files.map(_convertToCsv),
    );
    final bankStatements = <BankStatement>[];
    for (final csvFiles in csvGroups) {
      bankStatements.addAll(await _bankStatementParser.parse(csvFiles));
    }
    for (final statement in bankStatements) {
      if (statement.accountNumber.trim().isEmpty) {
        throw BankStatementImportErrorUnknown(
          message: 'Не удалось определить номер счёта в выписке',
        );
      }

      final issue = _importValidator.findInternalBalanceIssue(statement);
      if (issue != null) {
        throw BankStatementInternalBalanceError(message: issue.message);
      }
    }
    return bankStatements;
  }

  Future<List<File>> _convertToCsv(File file) {
    final lowerPath = file.path.toLowerCase();
    if (lowerPath.endsWith('.xlsx')) {
      return _xlsx2CsvConverter.convert(file);
    }
    if (lowerPath.endsWith('.xls')) {
      return _xls2CsvConverter.convert(file);
    }
    throw BankStatementImportErrorUnknown(
      message: 'Поддерживаются только файлы .xls и .xlsx',
    );
  }
}
