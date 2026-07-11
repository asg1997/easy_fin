import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:intl/intl.dart';

typedef Table = List<List<dynamic>>;
typedef OperationRow = List<dynamic>;

class SberParser {
  static final _ruDateInText = RegExp(
    r'(\d{1,2})\s+'
    r'(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)\s+'
    r'(\d{4})\s*г\.?',
  );

  static final _ruDateOnly = RegExp(
    r'^(\d{1,2})\s+'
    r'(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)\s+'
    r'(\d{4})\s*г\.?\s*$',
  );

  static const _ruMonthToNum = {
    'января': 1,
    'февраля': 2,
    'марта': 3,
    'апреля': 4,
    'мая': 5,
    'июня': 6,
    'июля': 7,
    'августа': 8,
    'сентября': 9,
    'октября': 10,
    'ноября': 11,
    'декабря': 12,
  };

  Future<BankStatement> parse(File file) => parseSheets([file]);

  /// Объединяет операции со всех листов многостраничной выписки в одну.
  Future<BankStatement> parseSheets(List<File> files) async {
    if (files.isEmpty) {
      throw StateError('Список файлов выписки Сбера пуст');
    }

    final firstRows = await _parseTable(files.first);
    final lastRows = files.length == 1
        ? firstRows
        : await _parseTable(files.last);

    final operations = <BankStatementOperation>[];
    for (final file in files) {
      final rows = await _parseTable(file);
      operations.addAll(_parseOperations(rows));
    }

    final accountNumber = _parseAccountNumber(firstRows);
    final (startDate, endDate) = _parseStatementPeriod(firstRows);
    final initialBalance =
        _parseBalanceFromLabeledRow(firstRows, 'Входящий остаток') ?? 0;
    final finalBalance =
        _parseBalanceFromLabeledRow(lastRows, 'Исходящий остаток') ?? 0;

    return BankStatement(
      startDate: startDate,
      endDate: endDate,
      accountNumber: accountNumber,
      bankName: '',
      initialBalance: initialBalance,
      finalBalance: finalBalance,
      operations: operations,
    );
  }

  List<BankStatementOperation> _parseOperations(List<OperationRow> rows) {
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
    /// TODO: выбрасывать ошибку, если индекс не найден
    final debetIndex = table.indexWhere((row) => row.contains('Дебет'));
    return debetIndex + 1;
  }

  bool isOperationRow(OperationRow row) => row.any(
    (cell) => cell is String && DateFormat('dd.MM.yyyy').tryParse(cell) != null,
  );

  BankStatementOperation _parseOperation(OperationRow row) {
    final debit = _parseDouble(row[9] as String);
    final credit = _parseDouble(row[13] as String);
    final (debitInn, debitBankAccount, debitCounterpartyName) =
        _parseCounterpartyCell(row[4] as String);
    final (creditInn, creditBankAccount, creditCounterpartyName) =
        _parseCounterpartyCell(row[8] as String);
    return BankStatementOperation(
      date: DateFormat('dd.MM.yyyy').parse(row[1] as String),
      debitInn: debitInn,
      debitBankAccount: debitBankAccount,
      creditInn: creditInn,
      creditBankAccount: creditBankAccount,
      debit: debit,
      credit: credit,
      note: row[20] as String,
      debitCounterpartyName: debitCounterpartyName,
      creditCounterpartyName: creditCounterpartyName,
    );
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
      return null;
    }
  }

  /// Строка вида «28 апреля 2026 г.» или фраза, где эта дата встречается первой.
  DateTime? _parseRussianLongDate(String value) {
    final m = _ruDateInText.firstMatch(value.trim());
    if (m == null) return null;
    final day = int.tryParse(m.group(1)!);
    final month = _ruMonthToNum[m.group(2)!];
    final year = int.tryParse(m.group(3)!);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  String _parseAccountNumber(Table rows) {
    for (final row in rows.take(15)) {
      final hasStatementLabel = row.any(
        (cell) => cell is String && cell.contains('ВЫПИСКА ОПЕРАЦИЙ'),
      );
      if (hasStatementLabel && row.length > 12) {
        final account = _extractAccountNumber(row[12]);
        if (account != null) return account;
      }
    }

    for (final row in rows.take(15)) {
      for (final cell in row) {
        final account = _extractAccountNumber(cell);
        if (account != null) return account;
      }
    }

    /// TODO: выбрасывать ошибку, если номер счёта не найден
    return '';
  }

  String? _extractAccountNumber(dynamic cell) {
    if (cell is! String) return null;
    final digits = cell.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 20) return digits;
    return null;
  }

  (DateTime startDate, DateTime endDate) _parseStatementPeriod(Table rows) {
    for (final row in rows) {
      final startCol = row.indexWhere(
        (c) => c is String && c.contains('за период с'),
      );
      if (startCol < 0) continue;

      final startCell = row[startCol] as String;
      final start = _parseRussianLongDate(startCell);
      if (start == null) continue;

      DateTime? end;
      for (var i = startCol + 1; i < row.length; i++) {
        final raw = row[i];
        if (raw is! String) continue;
        final t = raw.trim();
        if (t.isEmpty || t.toLowerCase() == 'по') continue;
        if (_ruDateOnly.hasMatch(t)) {
          end = _parseRussianLongDate(t);
          break;
        }
      }
      return (start, end ?? start);
    }

    /// TODO: выбрасывать ошибку, если период не найден
    final now = DateTime.now();
    return (now, now);
  }

  double? _parseBalanceFromLabeledRow(Table rows, String label) {
    for (final row in rows) {
      final hasLabel = row.any(
        (c) => c is String && c.trim().contains(label),
      );
      if (!hasLabel) continue;

      final amounts = <double>[];
      for (final cell in row) {
        if (cell is! String) continue;
        final t = cell.trim();
        if (t.isEmpty) continue;
        final v = _parseDouble(t);
        if (v != null) amounts.add(v);
      }
      if (amounts.isEmpty) continue;
      if (amounts.length >= 2) {
        return amounts[1];
      }
      return amounts.single;
    }
    return null;
  }

  /// Сбер: многострочная ячейка «Счёт» — номер счёта (20 цифр), ИНН (10/12), наименование.
  (String inn, String bankAccount, String name) parseCounterpartyCell(
    String value,
  ) => _parseCounterpartyCell(value);

  (String inn, String bankAccount, String name) _parseCounterpartyCell(
    String value,
  ) {
    if (value.isEmpty) return ('', '', '');

    final lines = value
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    var inn = '';
    var bankAccount = '';
    final nameParts = <String>[];

    for (final line in lines) {
      final digits = line.replaceAll(RegExp(r'\D'), '');
      if (digits.length == 20 && bankAccount.isEmpty) {
        bankAccount = digits;
      } else if ((digits.length == 10 || digits.length == 12) && inn.isEmpty) {
        inn = digits;
      } else {
        nameParts.add(line);
      }
    }

    return (inn, bankAccount, nameParts.join(' ').trim());
  }
}
