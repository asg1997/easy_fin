import 'dart:async';

import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/income_categories_storage/income_categories_storage.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/view/controllers/import_controller.dart';
import 'package:easy_fin/view/controllers/import_state.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/widgets/import_balance_gap_dialog.dart';
import 'package:easy_fin/view/widgets/import_base_creation_dialog.dart';
import 'package:easy_fin/view/widgets/import_error_dialog.dart';
import 'package:easy_fin/view/widgets/import_expense_review_dialog.dart';
import 'package:easy_fin/view/widgets/import_income_review_dialog.dart';
import 'package:easy_fin/view/widgets/import_out_of_order_dialog.dart';
import 'package:easy_fin/view/widgets/import_period_overlap_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImportStateListener extends ConsumerStatefulWidget {
  const ImportStateListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ImportStateListener> createState() =>
      _ImportStateListenerState();
}

class _ImportStateListenerState extends ConsumerState<ImportStateListener> {
  var _isHandlingBase = false;
  var _isHandlingBalance = false;
  var _isHandlingPeriodOverlap = false;
  var _isHandlingOutOfOrder = false;
  var _isHandlingIncomeReview = false;
  var _isHandlingExpenseReview = false;
  var _isHandlingError = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<ImportState>(importControllerProvider, (previous, next) {
      if (next is ImportAwaitingBase && previous is! ImportAwaitingBase) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted || _isHandlingBase) return;
          _isHandlingBase = true;
          unawaited(
            _handleAwaitingBase().whenComplete(() => _isHandlingBase = false),
          );
        });
      }

      if (next is ImportAwaitingBalanceConfirmation &&
          previous is! ImportAwaitingBalanceConfirmation) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted || _isHandlingBalance) return;
          _isHandlingBalance = true;
          unawaited(
            _handleAwaitingBalanceConfirmation().whenComplete(
              () => _isHandlingBalance = false,
            ),
          );
        });
      }

      if (next is ImportAwaitingOutOfOrderConfirmation &&
          previous is! ImportAwaitingOutOfOrderConfirmation) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted || _isHandlingOutOfOrder) return;
          _isHandlingOutOfOrder = true;
          unawaited(
            _handleOutOfOrderConfirmation().whenComplete(
              () => _isHandlingOutOfOrder = false,
            ),
          );
        });
      }

      if (next is ImportPeriodOverlapBlocked &&
          previous is! ImportPeriodOverlapBlocked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted || _isHandlingPeriodOverlap) return;
          _isHandlingPeriodOverlap = true;
          unawaited(
            _handlePeriodOverlapBlocked().whenComplete(
              () => _isHandlingPeriodOverlap = false,
            ),
          );
        });
      }

      if (next is ImportAwaitingIncomeReview &&
          previous is! ImportAwaitingIncomeReview) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted || _isHandlingIncomeReview) return;
          _isHandlingIncomeReview = true;
          unawaited(
            _handleIncomeReview().whenComplete(
              () => _isHandlingIncomeReview = false,
            ),
          );
        });
      }

      if (next is ImportAwaitingExpenseReview &&
          previous is! ImportAwaitingExpenseReview) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted || _isHandlingExpenseReview) return;
          _isHandlingExpenseReview = true;
          unawaited(
            _handleExpenseReview().whenComplete(
              () => _isHandlingExpenseReview = false,
            ),
          );
        });
      }

      if (next is ImportError && previous is! ImportError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted || _isHandlingError) return;
          _isHandlingError = true;
          unawaited(
            _handleImportError(next).whenComplete(
              () => _isHandlingError = false,
            ),
          );
        });
      }
    });

    return widget.child;
  }

  Future<void> _handleImportError(ImportError state) async {
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return ImportErrorDialog(message: state.message);
      },
    );

    if (!context.mounted) return;
    ref.read(importControllerProvider.notifier).dismissError();
  }

  Future<void> _handleAwaitingBase() async {
    if (!context.mounted) return;

    final currentState = ref.read(importControllerProvider);
    if (currentState is! ImportAwaitingBase) return;

    final existingBases = await ref.read(basesListProvider.future);

    if (!context.mounted) return;

    final result = await showDialog<ImportBaseDialogResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ImportBaseCreationDialog(
          accountNumber: currentState.accountNumber,
          existingBases: existingBases,
        );
      },
    );

    if (!context.mounted) return;

    final notifier = ref.read(importControllerProvider.notifier);
    if (ref.read(importControllerProvider) is! ImportAwaitingBase) return;

    switch (result) {
      case ImportBaseDialogSelectExisting(:final baseId):
        await notifier.linkAccountToExistingBaseAndContinue(baseId);
      case ImportBaseDialogCreateNew(:final baseName):
        await notifier.createBaseAndContinue(baseName);
      case null:
        await notifier.skipBaseCreation();
    }

    if (!context.mounted) return;
    await _handleAwaitingBase();
  }

  Future<void> _handleOutOfOrderConfirmation() async {
    if (!context.mounted) return;

    final currentState = ref.read(importControllerProvider);
    if (currentState is! ImportAwaitingOutOfOrderConfirmation) return;

    final result = await showDialog<ImportOutOfOrderDialogResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ImportOutOfOrderDialog(
          newStartDate: currentState.newStartDate,
          newEndDate: currentState.newEndDate,
          newFinalBalance: currentState.newFinalBalance,
          nextStartDate: currentState.nextStartDate,
          nextEndDate: currentState.nextEndDate,
          nextInitialBalance: currentState.nextInitialBalance,
          hasBalanceGap: currentState.hasBalanceGap,
        );
      },
    );

    if (!context.mounted) return;

    final notifier = ref.read(importControllerProvider.notifier);
    if (ref.read(importControllerProvider)
        is! ImportAwaitingOutOfOrderConfirmation) {
      return;
    }

    switch (result) {
      case ImportOutOfOrderDialogResult.import:
        await notifier.confirmOutOfOrderImport();
      case ImportOutOfOrderDialogResult.cancel:
      case null:
        await notifier.cancelOutOfOrderImport();
    }
  }

  Future<void> _handlePeriodOverlapBlocked() async {
    if (!context.mounted) return;

    final currentState = ref.read(importControllerProvider);
    if (currentState is! ImportPeriodOverlapBlocked) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ImportPeriodOverlapDialog(
          existingStartDate: currentState.existingStartDate,
          existingEndDate: currentState.existingEndDate,
          newStartDate: currentState.newStartDate,
          newEndDate: currentState.newEndDate,
        );
      },
    );

    if (!context.mounted) return;

    final notifier = ref.read(importControllerProvider.notifier);
    if (ref.read(importControllerProvider) is! ImportPeriodOverlapBlocked) {
      return;
    }

    await notifier.dismissPeriodOverlapAndContinue();
  }

  Future<void> _handleAwaitingBalanceConfirmation() async {
    if (!context.mounted) return;

    final currentState = ref.read(importControllerProvider);
    if (currentState is! ImportAwaitingBalanceConfirmation) return;

    final result = await showDialog<ImportBalanceGapDialogResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ImportBalanceGapDialog(
          previousEndDate: currentState.previousEndDate,
          previousFinalBalance: currentState.previousFinalBalance,
          newInitialBalance: currentState.newInitialBalance,
          newStartDate: currentState.newStartDate,
          newEndDate: currentState.newEndDate,
        );
      },
    );

    if (!context.mounted) return;

    final notifier = ref.read(importControllerProvider.notifier);
    if (ref.read(importControllerProvider)
        is! ImportAwaitingBalanceConfirmation) {
      return;
    }

    switch (result) {
      case ImportBalanceGapDialogResult.import:
        await notifier.confirmBalanceImport();
      case ImportBalanceGapDialogResult.cancel:
      case null:
        await notifier.cancelBalanceImport();
    }
  }

  Future<void> _handleIncomeReview() async {
    if (!context.mounted) return;

    final currentState = ref.read(importControllerProvider);
    if (currentState is! ImportAwaitingIncomeReview) return;

    final renters = await ref
        .read(rentersStorageProvider)
        .getByBase(currentState.baseId);
    final allRenters = await ref.read(rentersStorageProvider).getAll();
    final accountOwnerNames = <String, String>{
      for (final renter in allRenters)
        for (final account in renter.accountNumbers) account: renter.name,
    };
    final categories = await ref.read(incomeCategoriesStorageProvider).getActive();

    if (!context.mounted) return;

    final result = await showDialog<ImportIncomeReviewDialogResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ImportIncomeReviewDialog(
          statement: currentState.statement,
          reviewItems: currentState.reviewItems,
          renters: renters,
          categories: categories,
          accountOwnerNames: accountOwnerNames,
        );
      },
    );

    if (!context.mounted) return;

    final notifier = ref.read(importControllerProvider.notifier);
    if (ref.read(importControllerProvider) is! ImportAwaitingIncomeReview) {
      return;
    }

    switch (result) {
      case ImportIncomeReviewConfirmed(:final resolutions):
        await notifier.confirmIncomeReview(resolutions);
      case ImportIncomeReviewCancelled():
      case null:
        await notifier.cancelIncomeReview();
    }
  }

  Future<void> _handleExpenseReview() async {
    if (!context.mounted) return;

    final currentState = ref.read(importControllerProvider);
    if (currentState is! ImportAwaitingExpenseReview) return;

    final categories = await ref.read(expenseCategoriesStorageProvider).getActive();

    if (!context.mounted) return;

    final result = await showDialog<ImportExpenseReviewDialogResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ImportExpenseReviewDialog(
          statement: currentState.statement,
          reviewItems: currentState.reviewItems,
          categories: categories,
        );
      },
    );

    if (!context.mounted) return;

    final notifier = ref.read(importControllerProvider.notifier);
    if (ref.read(importControllerProvider) is! ImportAwaitingExpenseReview) {
      return;
    }

    switch (result) {
      case ImportExpenseReviewConfirmed(:final resolutions):
        await notifier.confirmExpenseReview(resolutions);
      case ImportExpenseReviewCancelled():
      case null:
        await notifier.cancelExpenseReview();
    }
  }
}
