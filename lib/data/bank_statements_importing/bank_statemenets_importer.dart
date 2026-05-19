import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/bank_statement_parser.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/xls2_cvs_converter.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/models/bank_statement_import_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BankStatementResult = List<BankStatement>;

final bankStatementsImporterProvider = Provider<BankStatementsImporter>(
  (ref) => BankStatementsImporterImpl(
    ref.read(bankStatementParserProvider),
    Xls2CvsConverter.instance,
  ),
);

/// Импортер выписок по банковскому счету
abstract class BankStatementsImporter {
  Future<BankStatementResult> import(BankStatementImportRequest request);
}

class BankStatementsImporterImpl implements BankStatementsImporter {
  BankStatementsImporterImpl(
    this._bankStatementParser,
    this._xls2CsvConverter,
  );

  final BankStatementParser _bankStatementParser;
  final Xls2CvsConverter _xls2CsvConverter;

  @override
  Future<BankStatementResult> import(BankStatementImportRequest request) async {
    final csvFiles = await Future.wait(
      request.xlsFiles.map(_xls2CsvConverter.convert),
    );
    final bankStatements = await _bankStatementParser.parse(csvFiles);
    return bankStatements;
  }
}
