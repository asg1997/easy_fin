import 'dart:io';

import 'package:path/path.dart' as p;

/// Конвертация .xls/.xlsx → .csv через LibreOffice.
///
/// На macOS в [DebugProfile.entitlements] и [Release.entitlements] должен
/// быть отключён App Sandbox (`com.apple.security.app-sandbox` = false),
/// иначе внешний `soffice` не сможет записать CSV.
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
      throw Exception(
        'Convert error (exit ${result.exitCode}): ${result.stderr}',
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
      throw Exception('CSV not found after conversion in ${workDir.path}');
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

    throw Exception(
      'Ambiguous CSV after conversion in ${workDir.path}: '
      '${csvFiles.map((f) => p.basename(f.path)).join(', ')}',
    );
  }
}
