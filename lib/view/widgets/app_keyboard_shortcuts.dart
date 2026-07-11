import 'package:easy_fin/utils/app_shortcuts.dart';
import 'package:easy_fin/view/actions/quick_add_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppKeyboardShortcuts extends ConsumerWidget {
  const AppKeyboardShortcuts({
    required this.child,
    super.key,
  });

  final Widget child;

  void _runIfAllowed(VoidCallback action) {
    if (isTextInputFocused) return;
    action();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallbackShortcuts(
      bindings: {
        appPrimaryShortcut(LogicalKeyboardKey.keyG): () {
          _runIfAllowed(() => openAddIncome(context));
        },
        appPrimaryShortcut(LogicalKeyboardKey.keyH): () {
          _runIfAllowed(() => openAddExpense(context));
        },
        appPrimaryShortcut(LogicalKeyboardKey.keyY): () {
          _runIfAllowed(() => openAddRentAccrual(context));
        },
        appPrimaryShortcut(LogicalKeyboardKey.keyB): () {
          _runIfAllowed(() => openImport(context, ref));
        },
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}
