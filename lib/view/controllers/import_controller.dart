import 'dart:io';

import 'package:easy_fin/data/bank_statements_importing/bank_statement_import_validator.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/xls2_cvs_converter.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/xlsx2_csv_converter.dart';
import 'package:easy_fin/data/bank_statements_importing/bank_statemenets_importer.dart';
import 'package:easy_fin/data/bank_statements_importing/errors/bank_statement_import_error.dart';
import 'package:easy_fin/data/bank_statements_importing/statement_expense_review_analyzer.dart';
import 'package:easy_fin/data/bank_statements_importing/statement_income_review_analyzer.dart';
import 'package:easy_fin/data/expense_category_accounts_storage/expense_category_accounts_storage.dart';
import 'package:easy_fin/data/bank_statements_storage/bank_statement_saver/bank_statement_saver.dart';
import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/bank_statement_import_request.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/base_account.dart';
import 'package:easy_fin/models/import_expense_review.dart';
import 'package:easy_fin/models/import_income_review.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:easy_fin/utils/money.dart';
import 'package:easy_fin/view/controllers/import_state.dart';
import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final importControllerProvider =
    NotifierProvider<ImportController, ImportState>(ImportController.new);

class ImportController extends Notifier<ImportState> {
  static const _allowedExtensions = ['xls', 'xlsx'];

  static const _importValidator = BankStatementImportValidator();

  final List<BankStatement> _pendingStatements = [];
  var _savedCount = 0;
  var _totalStatements = 0;
  var _completedStatements = 0;
  var _skipBalanceCheckForCurrent = false;
  var _skipOutOfOrderCheckForCurrent = false;

  @override
  ImportState build() => const ImportIdle();

  Future<void> pickAndImport() async {
    if (state.isImportInProgress) return;

    _resetProgress();
    _setLoading(phase: ImportLoadingPhase.readingFiles);
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
      _totalStatements = bankStatements.length;
      _completedStatements = 0;

      _setLoading(phase: ImportLoadingPhase.processing);
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
      [
        BaseAccount(
          accountNumber: normalizeAccountNumber(currentState.accountNumber),
          bankName: currentState.bankName,
        ),
      ],
    );

    await ref.read(basesStorageProvider).save(base);
    ref.invalidate(basesListProvider);
    ref.invalidate(githubSyncDirtyProvider);

    await _saveCurrentStatementAndContinue();
  }

  Future<void> linkAccountToExistingBaseAndContinue(BaseId baseId) async {
    final currentState = state;
    if (currentState is! ImportAwaitingBase) return;

    final storage = ref.read(basesStorageProvider);
    final existingBase = await storage.findById(baseId);
    if (existingBase == null) return;

    final accountNumber = normalizeAccountNumber(currentState.accountNumber);
    if (!existingBase.accountNumbers.contains(accountNumber)) {
      final updatedBase = Base(
        id: existingBase.id,
        name: existingBase.name,
        accounts: [
          ...existingBase.accounts,
          BaseAccount(
            accountNumber: accountNumber,
            bankName: currentState.bankName,
          ),
        ],
      );
      await storage.save(updatedBase);
      ref.invalidate(basesListProvider);
      ref.invalidate(githubSyncDirtyProvider);
    }

    await _saveCurrentStatementAndContinue();
  }

  Future<void> confirmBalanceImport() async {
    if (state is! ImportAwaitingBalanceConfirmation) return;
    if (_pendingStatements.isEmpty) return;

    _skipBalanceCheckForCurrent = true;

    _setLoading(phase: ImportLoadingPhase.processing);
    await _processQueue();
  }

  Future<void> cancelBalanceImport() async {
    if (state is! ImportAwaitingBalanceConfirmation) return;

    _pendingStatements.removeAt(0);
    _markStatementCompleted();
    await _processQueue();
  }

  Future<void> confirmOutOfOrderImport() async {
    if (state is! ImportAwaitingOutOfOrderConfirmation) return;
    if (_pendingStatements.isEmpty) return;

    _skipOutOfOrderCheckForCurrent = true;

    _setLoading(phase: ImportLoadingPhase.processing);
    await _processQueue();
  }

  Future<void> cancelOutOfOrderImport() async {
    if (state is! ImportAwaitingOutOfOrderConfirmation) return;

    _pendingStatements.removeAt(0);
    _markStatementCompleted();
    await _processQueue();
  }

  Future<void> dismissPeriodOverlapAndContinue() async {
    if (state is! ImportPeriodOverlapBlocked) return;

    _pendingStatements.removeAt(0);
    _markStatementCompleted();
    await _processQueue();
  }

  Future<void> confirmIncomeReview(
    List<ImportIncomeResolution> resolutions,
  ) async {
    final currentState = state;
    if (currentState is! ImportAwaitingIncomeReview) return;
    if (_pendingStatements.isEmpty) return;

    final reviewResult = await _applyIncomeReviewResolutions(
      statement: currentState.statement,
      baseId: currentState.baseId,
      autoMatchedRenterIds: currentState.autoMatchedRenterIds,
      resolutions: resolutions,
    );

    final expenseResult = currentState.pendingExpenseResult;
    if (expenseResult.reviewItems.isNotEmpty) {
      state = ImportAwaitingExpenseReview(
        statement: reviewResult.statement,
        baseId: currentState.baseId,
        baseName: currentState.baseName,
        autoMatchedCategoryIds: expenseResult.autoMatchedCategoryIds,
        reviewItems: expenseResult.reviewItems,
        pendingRentersToSave: reviewResult.rentersToSave,
      );
      return;
    }

    await _commitReviewedStatement(
      statement: reviewResult.statement,
      rentersToSave: reviewResult.rentersToSave,
      autoMatchedCategoryIds: expenseResult.autoMatchedCategoryIds,
      expenseResolutions: const [],
    );
  }

  Future<void> cancelIncomeReview() async {
    if (state is! ImportAwaitingIncomeReview) return;

    _pendingStatements.removeAt(0);
    _markStatementCompleted();
    await _processQueue();
  }

  Future<void> confirmExpenseReview(
    List<ImportExpenseResolution> resolutions,
  ) async {
    final currentState = state;
    if (currentState is! ImportAwaitingExpenseReview) return;
    if (_pendingStatements.isEmpty) return;

    await _commitReviewedStatement(
      statement: currentState.statement,
      rentersToSave: currentState.pendingRentersToSave,
      autoMatchedCategoryIds: currentState.autoMatchedCategoryIds,
      expenseResolutions: resolutions,
    );
  }

  Future<void> cancelExpenseReview() async {
    if (state is! ImportAwaitingExpenseReview) return;

    _pendingStatements.removeAt(0);
    _markStatementCompleted();
    await _processQueue();
  }

  Future<void> _commitReviewedStatement({
    required BankStatement statement,
    required List<Renter> rentersToSave,
    required Map<int, int> autoMatchedCategoryIds,
    required List<ImportExpenseResolution> expenseResolutions,
  }) async {
    final accountNumber = normalizeAccountNumber(statement.accountNumber);
    final normalizedStatement = statement.accountNumber == accountNumber
        ? statement
        : statement.copyWith(accountNumber: accountNumber);

    final resolvedBase = await ref
        .read(basesStorageProvider)
        .findByAccount(accountNumber);
    if (resolvedBase == null) {
      if (_pendingStatements.isNotEmpty) {
        _pendingStatements[0] = normalizedStatement;
      }
      state = ImportAwaitingBase(
        accountNumber: accountNumber,
        bankName: normalizedStatement.bankName,
      );
      return;
    }

    final rentersStorage = ref.read(rentersStorageProvider);
    for (final renter in rentersToSave) {
      await rentersStorage.save(renter);
    }

    final categoryAccountsStorage = ref.read(
      expenseCategoryAccountsStorageProvider,
    );
    for (final resolution in expenseResolutions) {
      if (resolution.classification != ImportExpenseClassification.other) {
        continue;
      }

      final categoryId = resolution.expenseCategoryId;
      final counterpartyAccount = resolution.accountNumber?.trim();
      if (categoryId == null ||
          counterpartyAccount == null ||
          counterpartyAccount.isEmpty) {
        continue;
      }

      await categoryAccountsStorage.saveLink(
        baseId: resolvedBase.id,
        categoryId: categoryId,
        accountNumber: counterpartyAccount,
      );
    }

    final statementToSave = applyExpenseClassification(
      normalizedStatement,
      autoMatchedCategoryIds: autoMatchedCategoryIds,
      resolutions: expenseResolutions,
    );

    try {
      await ref.read(bankStatementStorageProvider).save(statementToSave);
    } on BankAccountNotFoundError {
      if (_pendingStatements.isNotEmpty) {
        _pendingStatements[0] = statementToSave;
      }
      state = ImportAwaitingBase(
        accountNumber: accountNumber,
        bankName: normalizedStatement.bankName,
      );
      return;
    }

    _pendingStatements.removeAt(0);
    _savedCount++;
    _markStatementCompleted();
    await _processQueue();
  }

  Future<({
    BankStatement statement,
    List<Renter> rentersToSave,
  })> _applyIncomeReviewResolutions({
    required BankStatement statement,
    required BaseId baseId,
    required Map<int, String> autoMatchedRenterIds,
    required List<ImportIncomeResolution> resolutions,
  }) async {
    final rentersStorage = ref.read(rentersStorageProvider);
    final rentersToSave = <Renter>[];
    var operations = List<BankStatementOperation>.from(statement.operations);

    for (final entry in autoMatchedRenterIds.entries) {
      operations[entry.key] = operations[entry.key].copyWith(
        renterId: entry.value,
        clearIncomeCategoryId: true,
      );
    }

    for (final resolution in resolutions) {
      switch (resolution.classification) {
        case ImportIncomeClassification.renter:
          final prepared = await _prepareRenterForIncomeReview(
            rentersStorage: rentersStorage,
            baseId: baseId,
            resolution: resolution,
          );
          if (prepared.renterToSave != null) {
            rentersToSave.add(prepared.renterToSave!);
          }
          for (final index in resolution.operationIndices) {
            operations[index] = operations[index].copyWith(
              renterId: prepared.renterId,
              clearIncomeCategoryId: true,
            );
          }
        case ImportIncomeClassification.other:
          for (final index in resolution.operationIndices) {
            operations[index] = operations[index].copyWith(
              incomeCategoryId: resolution.incomeCategoryId,
              clearRenterId: true,
            );
          }
        case ImportIncomeClassification.unclassified:
          for (final index in resolution.operationIndices) {
            operations[index] = operations[index].copyWith(
              clearRenterId: true,
              clearIncomeCategoryId: true,
            );
          }
      }
    }

    return (
      statement: statement.copyWith(operations: operations),
      rentersToSave: rentersToSave,
    );
  }

  Future<({String renterId, Renter? renterToSave})> _prepareRenterForIncomeReview({
    required RentersStorage rentersStorage,
    required BaseId baseId,
    required ImportIncomeResolution resolution,
  }) async {
    final accountNumber = resolution.accountNumber!.trim();

    if (resolution.renterAction == ImportRenterAction.create) {
      final renter = Renter.create(
        baseId: baseId,
        name: resolution.name!.trim(),
        accountNumbers: [accountNumber],
      );
      return (renterId: renter.id, renterToSave: renter);
    }

    final linkedRenterId = resolution.linkedRenterId!;
    final existingRenter = await rentersStorage.findById(linkedRenterId);
    if (existingRenter == null) {
      return (renterId: linkedRenterId, renterToSave: null);
    }

    if (!existingRenter.accountNumbers.contains(accountNumber)) {
      return (
        renterId: linkedRenterId,
        renterToSave: Renter(
          id: existingRenter.id,
          baseId: existingRenter.baseId,
          name: existingRenter.name,
          accountNumbers: [
            ...existingRenter.accountNumbers,
            accountNumber,
          ],
          isArchived: existingRenter.isArchived,
        ),
      );
    }

    return (renterId: linkedRenterId, renterToSave: null);
  }

  Future<void> _saveCurrentStatementAndContinue() async {
    if (_pendingStatements.isEmpty) return;

    final statement = _pendingStatements.first;
    final saved = await _trySaveStatement(statement);
    if (!saved) return;

    _pendingStatements.removeAt(0);
    _savedCount++;
    _markStatementCompleted();
    await _processQueue();
  }

  Future<void> skipBaseCreation() async {
    if (state is! ImportAwaitingBase) return;

    _pendingStatements.removeAt(0);
    _markStatementCompleted();
    await _processQueue();
  }

  Future<void> _processQueue() async {
    _setLoading(phase: ImportLoadingPhase.processing);

    while (_pendingStatements.isNotEmpty) {
      final statement = _pendingStatements.first;
      final saved = await _trySaveStatement(statement);
      if (!saved) return;

      _pendingStatements.removeAt(0);
      _savedCount++;
      _markStatementCompleted();
    }

    _finishImport();
  }

  Future<bool> _trySaveStatement(BankStatement statement) async {
    final accountNumber = normalizeAccountNumber(statement.accountNumber);
    final normalizedStatement = statement.accountNumber == accountNumber
        ? statement
        : statement.copyWith(accountNumber: accountNumber);

    final base = await ref
        .read(basesStorageProvider)
        .findByAccount(accountNumber);
    if (base == null) {
      if (_pendingStatements.isNotEmpty) {
        _pendingStatements[0] = normalizedStatement;
      }
      state = ImportAwaitingBase(
        accountNumber: accountNumber,
        bankName: normalizedStatement.bankName,
      );
      return false;
    }

    final overlapIssue = await _findPeriodOverlapIssue(normalizedStatement);
    if (overlapIssue != null) {
      final existing = overlapIssue.overlappingStatement!;
      state = ImportPeriodOverlapBlocked(
        existingStartDate: existing.startDate,
        existingEndDate: existing.endDate,
        newStartDate: normalizedStatement.startDate,
        newEndDate: normalizedStatement.endDate,
      );
      return false;
    }

    if (!_skipOutOfOrderCheckForCurrent) {
      final outOfOrderIssue = await _findOutOfOrderIssue(normalizedStatement);
      if (outOfOrderIssue != null) {
        final next = outOfOrderIssue.nextStatement!;
        state = ImportAwaitingOutOfOrderConfirmation(
          newStartDate: normalizedStatement.startDate,
          newEndDate: normalizedStatement.endDate,
          newFinalBalance: normalizedStatement.finalBalance,
          nextStartDate: next.startDate,
          nextEndDate: next.endDate,
          nextInitialBalance: next.initialBalance,
          hasBalanceGap:
              outOfOrderIssue.expectedBalance != null &&
              outOfOrderIssue.actualBalance != null &&
              moneyToMinor(outOfOrderIssue.expectedBalance!) !=
                  moneyToMinor(outOfOrderIssue.actualBalance!),
        );
        return false;
      }
    }

    if (!_skipBalanceCheckForCurrent) {
      final balanceIssue = await _findBalanceContinuityIssue(normalizedStatement);
      if (balanceIssue != null) {
        final previous = balanceIssue.previousStatement!;
        state = ImportAwaitingBalanceConfirmation(
          previousEndDate: previous.endDate,
          previousFinalBalance: balanceIssue.expectedBalance!,
          newInitialBalance: balanceIssue.actualBalance!,
          newStartDate: normalizedStatement.startDate,
          newEndDate: normalizedStatement.endDate,
        );
        return false;
      }
    }

    _skipBalanceCheckForCurrent = false;
    _skipOutOfOrderCheckForCurrent = false;

    final incomeResult = await ref
        .read(statementIncomeReviewAnalyzerProvider)
        .analyze(normalizedStatement, baseId: base.id);
    final expenseResult = await ref
        .read(statementExpenseReviewAnalyzerProvider)
        .analyze(normalizedStatement, baseId: base.id);

    if (incomeResult.reviewItems.isNotEmpty) {
      state = ImportAwaitingIncomeReview(
        statement: normalizedStatement,
        baseId: base.id,
        baseName: base.name,
        autoMatchedRenterIds: incomeResult.autoMatchedRenterIds,
        reviewItems: incomeResult.reviewItems,
        pendingExpenseResult: expenseResult,
      );
      return false;
    }

    final statementAfterIncome = applyIncomeClassification(
      normalizedStatement,
      autoMatchedRenterIds: incomeResult.autoMatchedRenterIds,
    );

    if (expenseResult.reviewItems.isNotEmpty) {
      state = ImportAwaitingExpenseReview(
        statement: statementAfterIncome,
        baseId: base.id,
        baseName: base.name,
        autoMatchedCategoryIds: expenseResult.autoMatchedCategoryIds,
        reviewItems: expenseResult.reviewItems,
      );
      return false;
    }

    final statementToSave = applyExpenseClassification(
      statementAfterIncome,
      autoMatchedCategoryIds: expenseResult.autoMatchedCategoryIds,
    );

    try {
      await ref.read(bankStatementStorageProvider).save(statementToSave);
      return true;
    } on BankAccountNotFoundError {
      if (_pendingStatements.isNotEmpty) {
        _pendingStatements[0] = statementToSave;
      }
      state = ImportAwaitingBase(
        accountNumber: accountNumber,
        bankName: normalizedStatement.bankName,
      );
      return false;
    }
  }

  Future<BankStatementImportIssue?> _findPeriodOverlapIssue(
    BankStatement statement,
  ) async {
    final overlapping = await ref
        .read(bankStatementStorageProvider)
        .findOverlappingStatement(
          statement.accountNumber,
          statement.startDate,
          statement.endDate,
        );
    if (overlapping == null) return null;

    final issues = _importValidator.validate(
      statement,
      overlappingStatement: overlapping,
    );

    return issues
        .where(
          (issue) =>
              issue.type == BankStatementImportIssueType.periodOverlap &&
              issue.level == BankStatementImportIssueLevel.error,
        )
        .firstOrNull;
  }

  Future<BankStatementImportIssue?> _findOutOfOrderIssue(
    BankStatement statement,
  ) async {
    final next = await ref
        .read(bankStatementStorageProvider)
        .findNextStatement(statement.accountNumber, statement.endDate);
    if (next == null) return null;

    final issues = _importValidator.validate(
      statement,
      nextStatement: next,
    );

    return issues
        .where(
          (issue) =>
              issue.type == BankStatementImportIssueType.outOfOrder &&
              issue.level == BankStatementImportIssueLevel.warning,
        )
        .firstOrNull;
  }

  Future<BankStatementImportIssue?> _findBalanceContinuityIssue(
    BankStatement statement,
  ) async {
    final previous = await ref
        .read(bankStatementStorageProvider)
        .findPreviousStatement(statement.accountNumber, statement.startDate);
    if (previous == null) return null;

    final issues = _importValidator.validate(
      statement,
      previousStatement: previous,
    );

    return issues
        .where(
          (issue) =>
              issue.type == BankStatementImportIssueType.balanceContinuity &&
              issue.level == BankStatementImportIssueLevel.warning,
        )
        .firstOrNull;
  }

  void _resetProgress() {
    _totalStatements = 0;
    _completedStatements = 0;
  }

  void _markStatementCompleted() {
    _completedStatements++;
    if (_totalStatements == 0) {
      _totalStatements = _completedStatements + _pendingStatements.length;
    }
    _setLoading(phase: ImportLoadingPhase.processing);
  }

  void _setLoading({required ImportLoadingPhase phase}) {
    state = ImportLoading(
      completed: _completedStatements,
      total: _totalStatements,
      phase: phase,
    );
  }

  void _finishImport() {
    if (_savedCount > 0) {
      ref.invalidate(documentsListProvider);
      ref.invalidate(accountBalancesProvider);
      ref.invalidate(renterDebtsProvider);
      ref.invalidate(githubSyncDirtyProvider);
    }
    _reset();
  }

  void _reset() {
    _pendingStatements.clear();
    _savedCount = 0;
    _resetProgress();
    _skipBalanceCheckForCurrent = false;
    _skipOutOfOrderCheckForCurrent = false;
    state = const ImportIdle();
  }

  void _failImport(Object error) {
    _pendingStatements.clear();
    _savedCount = 0;
    _resetProgress();
    _skipBalanceCheckForCurrent = false;
    _skipOutOfOrderCheckForCurrent = false;
    state = ImportError(message: _mapErrorMessage(error));
  }

  String _mapErrorMessage(Object error) {
    if (error is Xls2CvsConverterError) {
      return error.message;
    }
    if (error is Xlsx2CsvConverterError) {
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

  bool _isSpreadsheetFile(String path) {
    final lower = path.toLowerCase();
    return _allowedExtensions.any((ext) => lower.endsWith('.$ext'));
  }

  Future<List<BankStatement>> _parseFiles(List<File> files) async {
    final importer = ref.read(bankStatementsImporterProvider);
    final bankStatements = <BankStatement>[];

    for (var index = 0; index < files.length; index++) {
      state = ImportLoading(
        completed: index,
        total: files.length,
        phase: ImportLoadingPhase.readingFiles,
      );

      final parsed = await importer.import(
        BankStatementImportRequest(files: [files[index]]),
      );
      bankStatements.addAll(parsed);
    }

    state = ImportLoading(
      completed: files.length,
      total: files.length,
      phase: ImportLoadingPhase.readingFiles,
    );

    return bankStatements;
  }

  Future<List<File>> _pickFiles() async {
    final pickResult = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      allowMultiple: true,
    );

    if (pickResult == null) return [];

    return pickResult.paths
        .whereType<String>()
        .where(_isSpreadsheetFile)
        .map(File.new)
        .toList();
  }
}
