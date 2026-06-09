import 'dart:async';

import 'package:easy_fin/view/controllers/import_controller.dart';
import 'package:easy_fin/view/controllers/import_state.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/widgets/import_base_creation_dialog.dart';
import 'package:easy_fin/view/widgets/import_error_dialog.dart';
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
}
