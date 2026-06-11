import 'dart:io';

import 'package:path/path.dart' as p;

class Xls2CvsConverterError extends Error {
  Xls2CvsConverterError({required this.message});

  final String message;
}

/// Конвертация .xls/.xlsx → .csv через LibreOffice.
/// Выбрасывает ошибку [Xls2CvsConverterError].
class Xls2CvsConverter {
  const Xls2CvsConverter._();
  static Xls2CvsConverter get instance => _instance;
  static const Xls2CvsConverter _instance = Xls2CvsConverter._();

  static const _libreofficePath =
      '/Applications/LibreOffice.app/Contents/MacOS/soffice';

  /// Конвертирует XLS в CSV. Для многостраничных файлов возвращает CSV каждого листа.
  Future<List<File>> convert(File xlsFile) async {
    if (!File(_libreofficePath).existsSync()) {
      throw Exception(
        'LibreOffice not found at $_libreofficePath. Install from libreoffice.org',
      );
    }

    final outDir = xlsFile.parent;
    final inputName = p.basename(xlsFile.path);
    final expectedBaseName = p.basenameWithoutExtension(inputName);

    final result = await Process.run(
      _libreofficePath,
      [
        '--headless',
        '--convert-to',
        'csv',
        '--outdir',
        outDir.path,
        xlsFile.path,
      ],
    );
    if (result.exitCode != 0) {
      throw Xls2CvsConverterError(
        message: 'Ошибка при конвертации: ${result.stderr}',
      );
    }

    return _findConvertedCsvs(outDir, expectedBaseName);
  }

  List<File> _findConvertedCsvs(Directory workDir, String expectedBaseName) {
    final csvFiles = workDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.csv'))
        .where((file) => _belongsToXls(expectedBaseName, file))
        .toList();
    if (csvFiles.isEmpty) {
      throw Xls2CvsConverterError(
        message: 'CSV не найден после конвертации в ${workDir.path}',
      );
    }

    csvFiles.sort(
      (a, b) => _sheetOrder(expectedBaseName, a).compareTo(
        _sheetOrder(expectedBaseName, b),
      ),
    );
    return csvFiles;
  }

  bool _belongsToXls(String baseName, File csvFile) {
    final csvBaseName = p.basenameWithoutExtension(csvFile.path);
    return csvBaseName == baseName || csvBaseName.startsWith('$baseName-');
  }

  /// Порядок листов: `name.csv`, затем `name-Sheet2.csv`, `name-Sheet3.csv` и т.д.
  int _sheetOrder(String baseName, File csvFile) {
    final csvBaseName = p.basenameWithoutExtension(csvFile.path);
    if (csvBaseName == baseName) return 1;

    final suffix = csvBaseName.substring(baseName.length + 1);
    final sheetMatch = RegExp(
      r'Sheet(\d+)$',
      caseSensitive: false,
    ).firstMatch(suffix);
    if (sheetMatch != null) {
      return int.parse(sheetMatch.group(1)!);
    }

    final numericMatch = RegExp(r'^(\d+)$').firstMatch(suffix);
    if (numericMatch != null) {
      return int.parse(numericMatch.group(1)!);
    }

    return 1000 + suffix.hashCode;
  }
}
