import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:easy_fin/view/widgets/simple_table.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ExpenseCategoriesPage extends ConsumerStatefulWidget {
  const ExpenseCategoriesPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const ExpenseCategoriesPage(),
      ),
    );
  }

  @override
  ConsumerState<ExpenseCategoriesPage> createState() =>
      _ExpenseCategoriesPageState();
}

class _ExpenseCategoriesPageState extends ConsumerState<ExpenseCategoriesPage> {
  List<ExpenseCategory> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final categories = await ref
        .read(expenseCategoriesStorageProvider)
        .getAll();
    if (!mounted) return;
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  Future<void> _showError(String message) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showNameDialog({
    required String title,
    String initialValue = '',
  }) async {
    final controller = TextEditingController(text: initialValue);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Название',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _onAddCategory() async {
    final name = await _showNameDialog(title: 'Новая категория');
    if (name == null) return;

    try {
      await ref.read(expenseCategoriesStorageProvider).save(name);
      await _loadCategories();
    } on ArgumentError {
      if (!mounted) return;
      await _showError('Название категории не может быть пустым');
    }
  }

  Future<void> _onRenameCategory(ExpenseCategory category) async {
    final name = await _showNameDialog(
      title: 'Переименовать категорию',
      initialValue: category.name,
    );
    if (name == null) return;

    try {
      await ref
          .read(expenseCategoriesStorageProvider)
          .rename(category.id, name);
      await _loadCategories();
    } on ArgumentError {
      if (!mounted) return;
      await _showError('Название категории не может быть пустым');
    } on ExpenseCategoryNotFoundError {
      if (!mounted) return;
      await _showError('Категория не найдена');
    }
  }

  Future<void> _onToggleArchive(ExpenseCategory category) async {
    try {
      if (category.isArchived) {
        await ref.read(expenseCategoriesStorageProvider).unarchive(category.id);
      } else {
        await ref.read(expenseCategoriesStorageProvider).archive(category.id);
      }
      await _loadCategories();
    } on ExpenseCategoryNotFoundError {
      if (!mounted) return;
      await _showError('Категория не найдена');
    }
  }

  Future<void> _onDeleteCategory(ExpenseCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmDialog(
        title: 'Удалить категорию?',
        message: 'Категория будет удалена безвозвратно.',
        confirmLabel: 'Удалить',
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(expenseCategoriesStorageProvider).delete(category.id);
      await _loadCategories();
    } on ExpenseCategoryInUseError {
      if (!mounted) return;
      await _showError(
        'Категория используется в расходах. Архивируйте её вместо удаления.',
      );
    } on ExpenseCategoryNotFoundError {
      if (!mounted) return;
      await _showError('Категория не найдена');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: 'Справочник расходов',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaterialButton(
              onPressed: _onAddCategory,
              height: filterFieldHeight,
              minWidth: 180,
              color: AppColors.purple,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.plus, size: 18, color: Colors.white),
                  Gap(8),
                  Text(
                    'Добавить категорию',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SimpleTable(
                      columns: const ['Категория', 'Статус'],
                      columnFlex: const [4, 2],
                      rows: _categories
                          .map(
                            (category) => [
                              category.name,
                              category.isArchived ? 'Архив' : 'Активна',
                            ],
                          )
                          .toList(),
                      emptyMessage: 'Нет категорий',
                      onRowDoubleTap: (index) =>
                          _onRenameCategory(_categories[index]),
                      rowLeadingBuilder: (index) {
                        final category = _categories[index];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: category.isArchived
                                  ? 'Разархивировать'
                                  : 'Архивировать',
                              onPressed: () => _onToggleArchive(category),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              icon: Icon(
                                category.isArchived
                                    ? LucideIcons.archiveRestore
                                    : LucideIcons.archive,
                                size: 16,
                                color: context.appColors.secondaryText,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Удалить',
                              onPressed: () => _onDeleteCategory(category),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              icon: Icon(
                                LucideIcons.trash2,
                                size: 16,
                                color: context.appColors.secondaryText,
                              ),
                            ),
                          ],
                        );
                      },
                      leadingWidth: 72,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
