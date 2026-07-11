import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:intl/intl.dart';

typedef Table = List<List<dynamic>>;
typedef OperationRow = List<dynamic>;

class VtbParser {
  Future<BankStatement> parse(File file) async {
    final rows = await _parseTable(file);
    final operations = _parseOperations(rows);
    final accountNumber = _parseAccountNumber(rows);
    final (startDate, endDate) = _parseStatementPeriod(rows);
    final (initialBalance, finalBalance) = _parseOpeningClosingBalances(rows);
    return BankStatement(
      startDate: startDate,
      endDate: endDate,
      accountNumber: normalizeAccountNumber(accountNumber),
      bankName: '',
      initialBalance: initialBalance,
      finalBalance: finalBalance,
      operations: operations,
    );
  }

  List<BankStatementOperation> _parseOperations(Table rows) {
    var currentOperationIndex = _findOperationsStartIndex(rows);

    final operations = <BankStatementOperation>[];
    while (currentOperationIndex < rows.length) {
      final operationRow = rows[currentOperationIndex];

      if (!isOperationRow(operationRow)) break;

      final operation = _parseOperation(operationRow);
      operations.add(operation);
      currentOperationIndex++;
    }
    return operations;
  }

  Future<Table> _parseTable(File file) async =>
      file.openRead().transform(utf8.decoder).transform(csv.decoder).toList();

  int _findOperationsStartIndex(Table table) {
    final headerIndex = table.indexWhere(
      (row) => row.isNotEmpty && _cellAsString(row[0]).trim() == 'Дата',
    );

    /// TODO: выбрасывать ошибку, если индекс не найден
    return headerIndex + 1;
  }

  bool isOperationRow(OperationRow row) {
    if (row.isEmpty) return false;
    final first = _cellAsString(row[0]).trim();
    if (first.startsWith('ИТОГО')) return false;
    return DateFormat('dd.MM.yyyy').tryParse(first) != null;
  }

  BankStatementOperation _parseOperation(OperationRow row) {
    final debit = _parseDouble(_cellAsString(row[7]));
    final credit = _parseDouble(_cellAsString(row[8]));
    final counterpartyInn = _cellAsString(row[4]).trim();
    final counterpartyAccount = _cellAsString(row[6]).trim();
    final counterpartyName = _cellAsString(row[2]).trim();
    final isOutgoing = (debit ?? 0) > 0;

    return BankStatementOperation(
      date: DateFormat('dd.MM.yyyy').parse(_cellAsString(row[0]).trim()),
      debitInn: isOutgoing ? '' : counterpartyInn,
      debitBankAccount: isOutgoing ? '' : counterpartyAccount,
      creditInn: isOutgoing ? counterpartyInn : '',
      creditBankAccount: isOutgoing ? counterpartyAccount : '',
      debit: isOutgoing ? debit : null,
      credit: isOutgoing ? null : credit,
      note: _cellAsString(row[9]),
      debitCounterpartyName: isOutgoing ? null : counterpartyName,
      creditCounterpartyName: isOutgoing ? counterpartyName : null,
    );
  }

  String _parseAccountNumber(Table rows) {
    for (final row in rows) {
      final labelIndex = row.indexWhere(
        (c) => _cellAsString(c).contains('Номер счета'),
      );
      if (labelIndex < 0) continue;
      if (labelIndex + 1 < row.length) {
        return _cellAsString(row[labelIndex + 1]).trim();
      }
    }

    /// TODO: выбрасывать ошибку, если номер счёта не найден
    return '';
  }

  (DateTime startDate, DateTime endDate) _parseStatementPeriod(Table rows) {
    for (final row in rows) {
      final startLabelIndex = row.indexWhere(
        (c) => _cellAsString(c).contains('Начальная дата'),
      );
      if (startLabelIndex < 0) continue;

      final start = DateFormat('dd.MM.yyyy').tryParse(
        _cellAsString(row[startLabelIndex + 1]).trim(),
      );
      if (start == null) continue;

      final endLabelIndex = row.indexWhere(
        (c) => _cellAsString(c).contains('Конечная дата'),
      );
      DateTime? end;
      if (endLabelIndex >= 0 && endLabelIndex + 1 < row.length) {
        end = DateFormat('dd.MM.yyyy').tryParse(
          _cellAsString(row[endLabelIndex + 1]).trim(),
        );
      }
      return (start, end ?? start);
    }

    /// TODO: выбрасывать ошибку, если период не найден
    final now = DateTime.now();
    return (now, now);
  }

  (double initialBalance, double finalBalance) _parseOpeningClosingBalances(
    Table rows,
  ) {
    final opening = _parseBalanceFromLabeledRow(rows, 'Входящий остаток');
    final closing = _parseBalanceFromLabeledRow(rows, 'Исходящий остаток');

    /// TODO: выбрасывать ошибку, если строки остатков не найдены
    return (opening ?? 0, closing ?? 0);
  }

  double? _parseBalanceFromLabeledRow(Table rows, String label) {
    for (final row in rows) {
      final labelIndex = row.indexWhere(
        (c) => _cellAsString(c).contains(label),
      );
      if (labelIndex < 0) continue;
      if (labelIndex + 1 >= row.length) continue;
      return _parseDouble(_cellAsString(row[labelIndex + 1]));
    }
    return null;
  }

  double? _parseDouble(String value) {
    if (value.isEmpty) return null;
    final normalized = value
        .replaceAll('\u00a0', ' ')
        .replaceAll('\u202f', ' ')
        .trim();
    if (normalized.isEmpty) return null;
    try {
      final format = NumberFormat.decimalPattern('ru_RU');
      return format.parse(normalized).toDouble();
    } on FormatException {
      // ВТБ в CSV: пробелы тысяч и точка как десятичный разделитель (198 893.09).
      final compact = normalized.replaceAll(RegExp(r'\s'), '');
      return double.tryParse(compact);
    }
  }

  String _cellAsString(dynamic cell) {
    if (cell == null) return '';
    return cell.toString();
  }
}
