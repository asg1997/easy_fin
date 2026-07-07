import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/documents_filters_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/providers/renters_list_provider.dart';
import 'package:easy_fin/view/widgets/edit_base_dialog.dart';
import 'package:easy_fin/view/widgets/simple_table.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';

class BasesPage extends ConsumerWidget {
  const BasesPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const BasesPage()),
    );
  }

  Future<void> _onEditBase(
    BuildContext context,
    WidgetRef ref,
    Base base,
  ) async {
    final outcome = await showDialog<EditBaseDialogOutcome>(
      context: context,
      builder: (context) => EditBaseDialog(base: base),
    );
    if (outcome == null) return;

    switch (outcome) {
      case EditBaseDialogDeleted():
        await _deleteBase(ref, base);
      case EditBaseDialogSaved(:final name, :final accounts):
        try {
          await ref.read(basesStorageProvider).save(
            Base(
              id: base.id,
              name: name,
              accounts: accounts,
            ),
          );
          ref.invalidate(basesListProvider);
          ref.invalidate(accountBalancesProvider);
        } on DuplicateAccountNumbersError {
          if (!context.mounted) return;
          await _showSaveError(context, 'Счета не должны повторяться');
        } on AccountBelongsToAnotherBaseError catch (error) {
          if (!context.mounted) return;
          await _showSaveError(
            context,
            'Счёт ${error.accountNumber} уже привязан к другой базе',
          );
        } on AccountHasStatementsError catch (error) {
          if (!context.mounted) return;
          await _showSaveError(
            context,
            'Нельзя удалить счёт ${error.accountNumber}: по нему есть выписки',
          );
        }
    }
  }

  Future<void> _deleteBase(WidgetRef ref, Base base) async {
    await ref.read(basesStorageProvider).delete(base.id);

    final filters = ref.read(documentsFiltersProvider);
    if (filters.selectedBases.any((item) => item.id == base.id)) {
      ref.read(documentsFiltersProvider.notifier).setSelectedBases(
        filters.selectedBases.where((item) => item.id != base.id).toSet(),
      );
    }

    ref.invalidate(basesListProvider);
    ref.invalidate(accountBalancesProvider);
    ref.invalidate(documentsListProvider);
    ref.invalidate(rentersListProvider);
  }

  Future<void> _showSaveError(BuildContext context, String message) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Не удалось сохранить'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basesAsync = ref.watch(basesListProvider);

    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: 'Базы',
        child: basesAsync.when(
          data: (bases) => SimpleTable(
            columns: const ['Название', 'Счета'],
            columnFlex: const [2, 3],
            rows: bases
                .map(
                  (base) => [
                    base.name,
                    base.accounts
                        .map(
                          (account) =>
                              '${account.displayName} (${account.accountNumber})',
                        )
                        .join(', '),
                  ],
                )
                .toList(),
            rowLeadingBuilder: (index) => IconButton(
              tooltip: 'Редактировать',
              onPressed: () => _onEditBase(context, ref, bases[index]),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              icon: Icon(
                LucideIcons.pencil,
                size: 16,
                color: context.appColors.secondaryText,
              ),
            ),
            emptyMessage: 'Нет баз',
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(
            child: Text('Не удалось загрузить базы'),
          ),
        ),
      ),
    );
  }
}
