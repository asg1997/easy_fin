import 'package:easy_fin/data/bank_statements_importing/bank_statement_import_validator.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/bank_statement_parser.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/xls2_cvs_converter.dart';
import 'package:easy_fin/data/bank_statements_importing/errors/bank_statement_import_error.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/models/bank_statement_import_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BankStatementResult = List<BankStatement>;

final bankStatementsImporterProvider = Provider<BankStatementsImporter>(
  (ref) => BankStatementsImporterImpl(
    ref.read(bankStatementParserProvider),
    Xls2CvsConverter.instance,
    const BankStatementImportValidator(),
  ),
);

/// Импортер выписок по банковскому счету
///
/// Выбрасывает ошибку [BankStatementImportError].
///
/// Если возникает ошибка при конвертации, выбрасывает ошибку [Xls2CvsConverterError].

abstract class BankStatementsImporter {
  Future<BankStatementResult> import(BankStatementImportRequest request);
}

class BankStatementsImporterImpl implements BankStatementsImporter {
  BankStatementsImporterImpl(
    this._bankStatementParser,
    this._xls2CsvConverter,
    this._importValidator,
  );

  final BankStatementParser _bankStatementParser;
  final Xls2CvsConverter _xls2CsvConverter;
  final BankStatementImportValidator _importValidator;

  @override
  Future<BankStatementResult> import(BankStatementImportRequest request) async {
    final csvGroups = await Future.wait(
      request.xlsFiles.map(_xls2CsvConverter.convert),
    );
    final bankStatements = <BankStatement>[];
    for (final csvFiles in csvGroups) {
      bankStatements.addAll(await _bankStatementParser.parse(csvFiles));
    }
    for (final statement in bankStatements) {
      final issue = _importValidator.findInternalBalanceIssue(statement);
      if (issue != null) {
        throw BankStatementInternalBalanceError(message: issue.message);
      }
    }
    return bankStatements;
  }
}
