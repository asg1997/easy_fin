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

  Future<File> convert(File xlsFile) async {
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

    return _findConvertedCsv(outDir, expectedBaseName);
  }

  File _findConvertedCsv(Directory workDir, String expectedBaseName) {
    final csvFiles = workDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.csv'))
        .toList();
    if (csvFiles.isEmpty) {
      throw Xls2CvsConverterError(
        message: 'CSV не найден после конвертации в ${workDir.path}',
      );
    }

    final exactMatch = csvFiles.where(
      (file) => p.basenameWithoutExtension(file.path) == expectedBaseName,
    );
    if (exactMatch.isNotEmpty) {
      return exactMatch.first;
    }

    if (csvFiles.length == 1) {
      return csvFiles.first;
    }

    throw Xls2CvsConverterError(
      message:
          'Неоднозначный CSV после конвертации в ${workDir.path}: '
          '${csvFiles.map((f) => p.basename(f.path)).join(', ')}',
    );
  }
}
