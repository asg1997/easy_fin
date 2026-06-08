import 'dart:io';

import 'package:easy_fin/data/bank_statements_importing/bank_statemenets_importer.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/models/bank_statement_import_request.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImportState {
  const ImportState({this.isLoading = false});

  final bool isLoading;

  ImportState copyWith({bool? isLoading}) {
    return ImportState(isLoading: isLoading ?? this.isLoading);
  }
}

final importControllerProvider =
    NotifierProvider<ImportController, ImportState>(ImportController.new);

class ImportController extends Notifier<ImportState> {
  static const _allowedExtension = 'xls';

  @override
  ImportState build() => const ImportState();

  Future<void> pickAndImport() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    try {
      final files = await _pickFiles();

      if (files.isEmpty) return;

      final bankStatements = await _parseFiles(files);
      // TODO: добавить в базу данных
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  bool _isXlsFile(String path) {
    return path.toLowerCase().endsWith('.$_allowedExtension');
  }

  Future<List<BankStatement>> _parseFiles(List<File> files) async {
    final bankStatements = await ref
        .read(bankStatementsImporterProvider)
        .import(BankStatementImportRequest(xlsFiles: files));
    return bankStatements;
  }

  Future<List<File>> _pickFiles() async {
    final pickResult = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [_allowedExtension],
      allowMultiple: true,
    );

    if (pickResult == null) return [];

    final files = pickResult.paths
        .whereType<String>()
        .where(_isXlsFile)
        .map(File.new)
        .toList();
    return files;
  }
}
