import 'dart:io';

import 'package:easy_fin/data/bank_statements_importing/bank_statemenets_importer.dart';
import 'package:easy_fin/models/bank_statement_import_request.dart';
import 'package:easy_fin/view/pages/main_nav_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  String _normalizeAssetNameForMatch(String value) {
    return value.toLowerCase().replaceAll('ё', 'е').replaceAll('\u0308', '');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // TODO: Убрать
      /// файлы excel из assets
      final assetNameParts = [
        ('СберБизнес. Выписка за 2026.04.28 счёт 40802810066000031876', '.csv'),
        ('VTB_BankStatement_40802810014450000445', '.xls'),
      ];

      final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final allAssetPaths = assetManifest.listAssets();
      final existingFileNames = <String>[];
      final filesBytes = <ByteData>[];
      for (final assetNamePart in assetNameParts) {
        final marker = assetNamePart.$1;
        final extension = assetNamePart.$2;
        final normalizedMarker = _normalizeAssetNameForMatch(marker);
        final assetPath = allAssetPaths.cast<String?>().firstWhere(
          (path) {
            if (path == null || !path.startsWith('assets/')) {
              return false;
            }
            final normalizedPath = _normalizeAssetNameForMatch(path);
            return normalizedPath.contains(normalizedMarker) &&
                normalizedPath.endsWith(extension.toLowerCase());
          },
          orElse: () => null,
        );
        if (assetPath == null) {
          debugPrint(
            'Asset not found in manifest for marker: $marker ($extension)',
          );
          continue;
        }
        final bytes = await rootBundle.load(assetPath);
        filesBytes.add(bytes);
        existingFileNames.add(assetPath.split('/').last);
      }
      if (existingFileNames.isEmpty) {
        debugPrint('No test bank statements found in assets/.');
        return;
      }
      final tempDir = await Directory.systemTemp.createTemp(
        'easy_fin_bank_statements_',
      );
      final files = await Future.wait(
        filesBytes.asMap().entries.map((entry) async {
          final index = entry.key;
          final byteData = entry.value;
          final originalFileName = existingFileNames[index];
          final file = File('${tempDir.path}/$originalFileName');
          await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
          return file;
        }),
      );
      final bankStatements = await ref
          .read(bankStatementsImporterProvider)
          .import(BankStatementImportRequest(files: files));
      print(bankStatements);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 253, 93, 93),
          primary: const Color.fromARGB(255, 253, 93, 93),
        ),
      ),
      home: const MainNavPage(),
    );
  }
}
