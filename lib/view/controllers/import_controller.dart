import 'dart:io';

import 'package:easy_fin/data/bank_statements_importing/bank_statemenets_importer.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/xls2_cvs_converter.dart';
import 'package:easy_fin/data/bank_statements_importing/errors/bank_statement_import_error.dart';
import 'package:easy_fin/data/bank_statements_storage/bank_statement_saver/bank_statement_saver.dart';
import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/models/bank_statement_import_request.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/view/controllers/import_state.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final importControllerProvider =
    NotifierProvider<ImportController, ImportState>(ImportController.new);

class ImportController extends Notifier<ImportState> {
  static const _allowedExtension = 'xls';

  final List<BankStatement> _pendingStatements = [];
  var _savedCount = 0;

  @override
  ImportState build() => const ImportIdle();

  Future<void> pickAndImport() async {
    if (state.isImportInProgress) return;

    state = const ImportLoading();
    try {
      final files = await _pickFiles();
      if (files.isEmpty) {
        _reset();
        return;
      }

      final bankStatements = await _parseFiles(files);
      _pendingStatements
        ..clear()
        ..addAll(bankStatements);
      _savedCount = 0;

      await _processQueue();
    } on Object catch (error) {
      _failImport(error);
    }
  }

  void dismissError() {
    if (state is ImportError) {
      _reset();
    }
  }

  Future<void> createBaseAndContinue(String baseName) async {
    final currentState = state;
    if (currentState is! ImportAwaitingBase) return;

    final trimmedName = baseName.trim();
    if (trimmedName.isEmpty) return;

    final base = Base.create(
      trimmedName,
      [currentState.accountNumber],
    );

    await ref.read(basesStorageProvider).save(base);
    ref.invalidate(basesListProvider);

    await _saveCurrentStatementAndContinue();
  }

  Future<void> linkAccountToExistingBaseAndContinue(BaseId baseId) async {
    final currentState = state;
    if (currentState is! ImportAwaitingBase) return;

    final storage = ref.read(basesStorageProvider);
    final existingBase = await storage.findById(baseId);
    if (existingBase == null) return;

    final accountNumber = currentState.accountNumber;
    if (!existingBase.accountNumbers.contains(accountNumber)) {
      final updatedBase = Base(
        id: existingBase.id,
        name: existingBase.name,
        accountNumbers: [...existingBase.accountNumbers, accountNumber],
      );
      await storage.save(updatedBase);
      ref.invalidate(basesListProvider);
    }

    await _saveCurrentStatementAndContinue();
  }

  Future<void> _saveCurrentStatementAndContinue() async {
    if (_pendingStatements.isEmpty) return;

    final statement = _pendingStatements.first;
    await ref.read(bankStatementStorageProvider).save(statement);
    _pendingStatements.removeAt(0);
    _savedCount++;

    state = const ImportLoading();
    await _processQueue();
  }

  Future<void> skipBaseCreation() async {
    if (state is! ImportAwaitingBase) return;

    _pendingStatements.removeAt(0);
    state = const ImportLoading();
    await _processQueue();
  }

  Future<void> _processQueue() async {
    final storage = ref.read(bankStatementStorageProvider);

    while (_pendingStatements.isNotEmpty) {
      final statement = _pendingStatements.first;

      try {
        await storage.save(statement);
        _pendingStatements.removeAt(0);
        _savedCount++;
      } on BankAccountNotFoundError {
        state = ImportAwaitingBase(
          accountNumber: statement.accountNumber,
        );
        return;
      }
    }

    _finishImport();
  }

  void _finishImport() {
    if (_savedCount > 0) {
      ref.invalidate(documentsListProvider);
    }
    _reset();
  }

  void _reset() {
    _pendingStatements.clear();
    _savedCount = 0;
    state = const ImportIdle();
  }

  void _failImport(Object error) {
    _pendingStatements.clear();
    _savedCount = 0;
    state = ImportError(message: _mapErrorMessage(error));
  }

  String _mapErrorMessage(Object error) {
    if (error is Xls2CvsConverterError) {
      return error.message;
    }
    if (error is BankStatementImportError) {
      return error.message ?? 'Не удалось импортировать выписку';
    }
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Произошла ошибка при импорте';
  }

  bool _isXlsFile(String path) =>
      path.toLowerCase().endsWith('.$_allowedExtension');

  Future<List<BankStatement>> _parseFiles(List<File> files) async => ref
      .read(bankStatementsImporterProvider)
      .import(BankStatementImportRequest(xlsFiles: files));

  Future<List<File>> _pickFiles() async {
    final pickResult = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [_allowedExtension],
      allowMultiple: true,
    );

    if (pickResult == null) return [];

    return pickResult.paths
        .whereType<String>()
        .where(_isXlsFile)
        .map(File.new)
        .toList();
  }
}
