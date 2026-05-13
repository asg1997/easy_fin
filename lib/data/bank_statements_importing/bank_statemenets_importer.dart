import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/bank_statement_parser.dart';
import 'package:easy_fin/models/bank_statement_import_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BankStatementResult = String;

final bankStatementsImporterProvider = Provider<BankStatementsImporter>(
  (ref) => BankStatementsImporterImpl(ref.read(bankStatementParserProvider)),
);

/// Импортер выписок по банковскому счету
abstract class BankStatementsImporter {
  Future<BankStatementResult> import(BankStatementImportRequest request);
}

class BankStatementsImporterImpl implements BankStatementsImporter {
  BankStatementsImporterImpl(this._bankStatementParser);

  final BankStatementParser _bankStatementParser;
  @override
  Future<BankStatementResult> import(BankStatementImportRequest request) async {
    final files = request.files;
    final bankStatements = await _bankStatementParser.parse(files);
    // парсим файлы
    // преобразовываем ?
    // возвращаем
    return '';
  }
}
