import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/widgets/edit_base_dialog.dart';
import 'package:easy_fin/view/widgets/simple_table.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    final result = await showDialog<EditBaseDialogResult>(
      context: context,
      builder: (context) => EditBaseDialog(base: base),
    );
    if (result == null) return;

    try {
      await ref.read(basesStorageProvider).save(
        Base(
          id: base.id,
          name: result.name,
          accountNumbers: result.accountNumbers,
        ),
      );
      ref.invalidate(basesListProvider);
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
            columns: const ['Название', 'Расчётные счета'],
            columnFlex: const [2, 3],
            rows: bases
                .map(
                  (base) => [
                    base.name,
                    base.accountNumbers.join(', '),
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
              icon: const Icon(
                LucideIcons.pencil,
                size: 16,
                color: Colors.grey,
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
