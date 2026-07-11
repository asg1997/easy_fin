import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path/path.dart' as p;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class Xlsx2CsvConverterError implements Exception {
  Xlsx2CsvConverterError({required this.message});

  final String message;

  @override
  String toString() => 'Xlsx2CsvConverterError: $message';
}

/// Конвертация .xlsx → .csv без LibreOffice (через spreadsheet_decoder).
///
/// Для многостраничных файлов возвращает CSV каждого листа.
/// Выбрасывает [Xlsx2CsvConverterError].
class Xlsx2CsvConverter {
  const Xlsx2CsvConverter._();

  static Xlsx2CsvConverter get instance => _instance;
  static const Xlsx2CsvConverter _instance = Xlsx2CsvConverter._();

  /// Excel serial dates roughly cover years 1955–2119.
  static const _excelDateMin = 20000;
  static const _excelDateMax = 80000;

  Future<List<File>> convert(File xlsxFile) async {
    try {
      final bytes = await xlsxFile.readAsBytes();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);
      if (decoder.tables.isEmpty) {
        throw Xlsx2CsvConverterError(
          message: 'В файле нет листов: ${xlsxFile.path}',
        );
      }

      final outDir = xlsxFile.parent;
      final baseName = p.basenameWithoutExtension(xlsxFile.path);
      final sheetEntries = decoder.tables.entries.toList();
      final csvFiles = <File>[];

      for (var index = 0; index < sheetEntries.length; index++) {
        final table = sheetEntries[index].value;
        final csvName = sheetEntries.length == 1
            ? '$baseName.csv'
            : '$baseName-Sheet${index + 1}.csv';
        final csvFile = File(p.join(outDir.path, csvName));
        await csvFile.writeAsString(_tableToCsv(table), flush: true);
        csvFiles.add(csvFile);
      }

      return csvFiles;
    } on Xlsx2CsvConverterError {
      rethrow;
    } catch (error) {
      throw Xlsx2CsvConverterError(
        message: 'Ошибка при чтении xlsx: $error',
      );
    }
  }

  String _tableToCsv(SpreadsheetTable table) {
    final rows = <List<dynamic>>[
      for (final row in table.rows)
        [for (final cell in row) _cellToCsvString(cell)],
    ];
    return csv.encoder.convert(rows);
  }

  String _cellToCsvString(Object? cell) {
    if (cell == null) return '';
    if (cell is num) {
      if (_looksLikeExcelDate(cell)) {
        return _formatExcelDate(cell);
      }
      if (cell == cell.roundToDouble()) {
        return cell.round().toString();
      }
      // Как LibreOffice для Сбера: запятая как десятичный разделитель.
      return cell.toString().replaceAll('.', ',');
    }
    return cell.toString();
  }

  /// Excel date-time serials usually have a fractional time part.
  bool _looksLikeExcelDate(num value) {
    if (value < _excelDateMin || value >= _excelDateMax) return false;
    final fraction = (value - value.truncateToDouble()).abs();
    return fraction > 1e-9;
  }

  String _formatExcelDate(num serial) {
    final wholeDays = serial.floor();
    final fraction = serial - wholeDays;
    // Excel epoch (with the 1900 leap-year bug): 1899-12-30.
    final date = DateTime(1899, 12, 30).add(Duration(days: wholeDays));
    final dayMillis = (fraction * Duration.millisecondsPerDay).round();
    final dateTime = date.add(Duration(milliseconds: dayMillis));
    final dd = dateTime.day.toString().padLeft(2, '0');
    final mm = dateTime.month.toString().padLeft(2, '0');
    final yyyy = dateTime.year.toString();
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final min = dateTime.minute.toString().padLeft(2, '0');
    final ss = dateTime.second.toString().padLeft(2, '0');
    return '$dd.$mm.$yyyy $hh:$min:$ss';
  }
}
