import 'dart:async';

import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/expenses_storage/expenses_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/base_account.dart';
import 'package:easy_fin/models/expense.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/models/expense_document.dart';
import 'package:easy_fin/utils/amount_input_formatter.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_snack_bar.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/widgets/date_picker_field.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

sealed class _DocumentAccountOption {
  const _DocumentAccountOption(this.label);

  final String label;
}

class _CashAccountOption extends _DocumentAccountOption {
  const _CashAccountOption() : super('Касса');

  @override
  bool operator ==(Object other) => other is _CashAccountOption;

  @override
  int get hashCode => runtimeType.hashCode;
}

class _BankAccountOption extends _DocumentAccountOption {
  _BankAccountOption({
    required this.account,
  }) : super(account.displayName);

  final BaseAccount account;

  @override
  bool operator ==(Object other) {
    return other is _BankAccountOption &&
        other.account.accountNumber == account.accountNumber;
  }

  @override
  int get hashCode => account.accountNumber.hashCode;
}

class _ExpenseLineEntry {
  _ExpenseLineEntry({
    required this.category,
    String amountText = '',
    String noteText = '',
    FocusNode? amountFocusNode,
  })  : amountController = TextEditingController(text: amountText),
        noteController = TextEditingController(text: noteText),
        amountFocusNode = amountFocusNode ?? FocusNode();

  final ExpenseCategory category;
  final TextEditingController amountController;
  final TextEditingController noteController;
  final FocusNode amountFocusNode;

  String get displayLabel => category.name;

  void dispose() {
    amountController.dispose();
    noteController.dispose();
    amountFocusNode.dispose();
  }
}

class AddExpensePage extends ConsumerStatefulWidget {
  const AddExpensePage({super.key, this.initialDocumentId});

  final String? initialDocumentId;

  static Future<void> navigate(
    BuildContext context, {
    String? documentId,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AddExpensePage(initialDocumentId: documentId),
      ),
    );
  }

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  Base? _selectedBase;
  late DateTime _selectedDate;
  _DocumentAccountOption? _selectedAccount;
  final List<_ExpenseLineEntry> _lineEntries = [];
  bool _isLoadingDocument = false;
  String? _editingDocumentId;
  DateTime? _editingCreatedAt;
  List<ExpenseCategory> _activeCategories = [];

  bool get _isEditing => _editingDocumentId != null;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    if (widget.initialDocumentId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_loadDocument(widget.initialDocumentId!));
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_loadActiveCategories());
      });
    }
  }

  Future<void> _loadDocument(String documentId) async {
    setState(() => _isLoadingDocument = true);

    final document =
        await ref.read(expensesStorageProvider).getById(documentId);
    if (!mounted) return;

    if (document == null) {
      setState(() => _isLoadingDocument = false);
      await _showErrorDialog('Документ не найден');
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final bases = await ref.read(basesListProvider.future);
    final base = bases.where((item) => item.id == document.baseId).firstOrNull;

    _clearLines();
    _editingDocumentId = document.id;
    _editingCreatedAt = document.createdAt;

    setState(() {
      _selectedBase = base;
      _selectedDate = document.date;
      _selectedAccount = switch (document.account) {
        ExpenseDocumentCashAccount() => const _CashAccountOption(),
        ExpenseDocumentBankAccount(:final accountNumber) =>
          _bankOptionForNumber(base, accountNumber),
      };
      _isLoadingDocument = false;
    });

    final categories =
        await ref.read(expenseCategoriesStorageProvider).getAll();
    final categoryById = {
      for (final category in categories) category.id: category,
    };

    setState(() {
      for (final line in document.lines) {
        final category = categoryById[line.categoryId];
        if (category == null) continue;

        _lineEntries.add(
          _ExpenseLineEntry(
            category: category,
            amountText: AmountInputFormatter.formatAmount(line.sum),
            noteText: line.note ?? '',
          ),
        );
      }
    });

    unawaited(_loadActiveCategories());
  }

  Future<void> _loadActiveCategories() async {
    final categories =
        await ref.read(expenseCategoriesStorageProvider).getActive();
    if (!mounted) return;
    setState(() => _activeCategories = categories);
  }

  _BankAccountOption? _bankOptionForNumber(Base? base, String accountNumber) {
    if (base == null) return null;
    final account = base.accounts
        .where((item) => item.accountNumber == accountNumber)
        .firstOrNull;
    if (account == null) return null;
    return _BankAccountOption(account: account);
  }

  List<_DocumentAccountOption> _accountOptionsForBase(Base base) {
    return [
      const _CashAccountOption(),
      ...base.accounts.map((account) => _BankAccountOption(account: account)),
    ];
  }

  _DocumentAccountOption? _resolveSelectedAccount(
    List<_DocumentAccountOption> options,
    _DocumentAccountOption? selected,
  ) {
    if (options.isEmpty) return null;
    if (selected == null) return options.first;
    for (final option in options) {
      if (option == selected) return option;
    }
    return options.first;
  }

  @override
  void dispose() {
    _clearLines();
    super.dispose();
  }

  void _clearLines() {
    for (final entry in _lineEntries) {
      entry.dispose();
    }
    _lineEntries.clear();
  }

  void _onBaseChanged(Base base) {
    _clearLines();
    setState(() {
      _selectedBase = base;
      _selectedAccount = const _CashAccountOption();
    });
    unawaited(_loadActiveCategories());
  }

  void _addCategoryLine(ExpenseCategory category) {
    final focusNode = FocusNode();
    setState(() {
      _lineEntries.add(
        _ExpenseLineEntry(
          category: category,
          amountFocusNode: focusNode,
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _removeLine(int index) {
    final entry = _lineEntries[index];
    entry.dispose();
    setState(() => _lineEntries.removeAt(index));
  }

  ExpenseDocumentAccount _toDocumentAccount(_DocumentAccountOption option) {
    return switch (option) {
      _CashAccountOption() => const ExpenseDocumentCashAccount(),
      _BankAccountOption(:final account) =>
        ExpenseDocumentBankAccount(accountNumber: account.accountNumber),
    };
  }

  Future<void> _onSave() async {
    final baseId = _selectedBase?.id;
    if (baseId == null) {
      await _showErrorDialog('Выберите базу');
      return;
    }

    final account = _selectedAccount;
    if (account == null) {
      await _showErrorDialog('Выберите счёт');
      return;
    }

    if (_lineEntries.isEmpty) {
      await _showErrorDialog('Добавьте хотя бы одну строку');
      return;
    }

    final lines = <Expense>[];
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    for (var i = 0; i < _lineEntries.length; i++) {
      final entry = _lineEntries[i];
      final amount =
          AmountInputFormatter.parseAmount(entry.amountController.text);
      if (amount == null || amount <= 0) {
        await _showErrorDialog('Укажите сумму для «${entry.displayLabel}»');
        return;
      }

      final note = entry.noteController.text.trim();
      lines.add(
        Expense(
          id: '${timestamp}_$i',
          sum: amount,
          categoryId: entry.category.id,
          note: note.isEmpty ? null : note,
        ),
      );
    }

    final document = ExpenseDocument(
      id: _editingDocumentId ?? timestamp.toString(),
      createdAt: _editingCreatedAt ?? DateTime.now(),
      baseId: baseId,
      date: _selectedDate,
      account: _toDocumentAccount(account),
      lines: lines,
    );

    try {
      final storage = ref.read(expensesStorageProvider);
      if (_isEditing) {
        await storage.updateDocument(document);
      } else {
        await storage.saveDocument(document);
      }

      if (!mounted) return;
      ref.invalidate(documentsListProvider);
      ref.invalidate(accountBalancesProvider);
      ref.invalidate(githubSyncDirtyProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Расход обновлён' : 'Расход сохранён'),
        ),
      );
      Navigator.of(context).pop();
    } on EmptyExpenseDocumentError {
      if (!mounted) return;
      await _showErrorDialog('Добавьте хотя бы одну строку');
    } on InvalidExpenseAmountError {
      if (!mounted) return;
      await _showErrorDialog('Сумма должна быть больше нуля');
    } on ExpenseDocumentNotFoundError {
      if (!mounted) return;
      await _showErrorDialog('Документ не найден');
    } on Object catch (error) {
      if (!mounted) return;
      await _showErrorDialog('Не удалось сохранить расход\n$error');
    }
  }

  Future<String?> _showCategoryNameDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая категория'),
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
    final name = await _showCategoryNameDialog();
    if (name == null) return;

    try {
      await ref.read(expenseCategoriesStorageProvider).save(name);
      await _loadActiveCategories();
    } on ArgumentError {
      if (!mounted) return;
      await _showErrorDialog('Название категории не может быть пустым');
    }
  }

  Future<void> _showErrorDialog(String message) {
    return AppSnackBar.showErrorDialog(context, message);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDocument) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final basesAsync = ref.watch(basesListProvider);
    final accountOptions = _selectedBase == null
        ? const <_DocumentAccountOption>[]
        : _accountOptionsForBase(_selectedBase!);
    final selectedAccount = _resolveSelectedAccount(
      accountOptions,
      _selectedAccount,
    );

    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: _isEditing ? 'Редактирование расхода' : 'Расход',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterRow(
              children: [
                _FilterField(
                  child: basesAsync.when(
                    data: (bases) => DropdownWidget<Base>(
                      expand: true,
                      items: bases,
                      hint: 'Выбор базы',
                      selectedItem: _selectedBase,
                      labelBuilder: (item) => item.name,
                      onChanged: _onBaseChanged,
                    ),
                    loading: () =>
                        const _FilterPlaceholder(label: 'Выбор базы'),
                    error: (_, _) =>
                        const _FilterPlaceholder(label: 'Выбор базы'),
                  ),
                ),
                const Gap(12),
                _FilterField(
                  child: DatePickerField(
                    expand: true,
                    hint: 'Дата',
                    selectedDate: _selectedDate,
                    onChanged: (date) {
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                  ),
                ),
                const Gap(12),
                _FilterField(
                  child: accountOptions.isEmpty
                      ? const _FilterPlaceholder(label: 'Счёт')
                      : DropdownWidget<_DocumentAccountOption>(
                          expand: true,
                          items: accountOptions,
                          hint: 'Счёт',
                          selectedItem: selectedAccount,
                          labelBuilder: (item) => item.label,
                          onChanged: (item) {
                            setState(() => _selectedAccount = item);
                          },
                        ),
                ),
              ],
            ),
            if (_selectedBase != null) ...[
              const Gap(12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _ExpenseLinesTable(
                                entries: _lineEntries,
                                onRemoveLine: _removeLine,
                              ),
                            ),
                            const Gap(12),
                            MaterialButton(
                              onPressed: _onSave,
                              height: filterFieldHeight,
                              minWidth: 140,
                              color: AppColors.purple,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Text(
                                'Сохранить',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _ExpenseCategoriesPanel(
                          categories: _activeCategories,
                          onCategoryDoubleTap: _addCategoryLine,
                          onAddCategory: _onAddCategory,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExpenseLinesTable extends StatelessWidget {
  const _ExpenseLinesTable({
    required this.entries,
    required this.onRemoveLine,
  });

  final List<_ExpenseLineEntry> entries;
  final void Function(int index) onRemoveLine;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Container(
              color: context.appColors.navActiveBackground,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Категория',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Сумма',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Gap(12),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Комментарий',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 32),
                ],
              ),
            ),
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Text(
                        'Дважды нажмите на категорию справа',
                        style: filterFieldHintTextStyleOf(context),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: entries.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 1,
                        color: context.appColors.border,
                      ),
                      itemBuilder: (context, index) {
                        final entry = entries[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 8,
                            bottom: 8,
                            right: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  entry.displayLabel,
                                  style: filterFieldTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: documentLineFieldHeight,
                                  child: TextField(
                                    controller: entry.amountController,
                                    focusNode: entry.amountFocusNode,
                                    textAlign: TextAlign.right,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    inputFormatters: const [
                                      AmountInputFormatter(),
                                    ],
                                    style: filterFieldTextStyle,
                                    decoration: documentLineFieldDecorationOf(
                                      context,
                                      hintText: '0,00',
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: documentLineFieldHeight,
                                  child: TextField(
                                    controller: entry.noteController,
                                    style: filterFieldTextStyle,
                                    decoration: documentLineFieldDecorationOf(
                                      context,
                                      hintText: 'Комментарий',
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Удалить',
                                onPressed: () => onRemoveLine(index),
                                icon: Icon(
                                  LucideIcons.x,
                                  size: 16,
                                  color: context.appColors.secondaryText,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseCategoriesPanel extends StatefulWidget {
  const _ExpenseCategoriesPanel({
    required this.categories,
    required this.onCategoryDoubleTap,
    required this.onAddCategory,
  });

  final List<ExpenseCategory> categories;
  final void Function(ExpenseCategory category) onCategoryDoubleTap;
  final VoidCallback onAddCategory;

  @override
  State<_ExpenseCategoriesPanel> createState() =>
      _ExpenseCategoriesPanelState();
}

class _ExpenseCategoriesPanelState extends State<_ExpenseCategoriesPanel> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ExpenseCategory> get _filteredCategories {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return widget.categories;

    return widget.categories
        .where((category) => category.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _filteredCategories;
    final hasSearch = _searchQuery.trim().isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Container(
              color: context.appColors.navActiveBackground,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Категория',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: context.appColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: filterFieldTextStyle,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Поиск категории',
                        hintStyle: filterFieldHintTextStyleOf(context),
                        filled: true,
                        fillColor: context.appColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          size: 16,
                          color: context.appColors.secondaryText,
                        ),
                        suffixIcon: _searchQuery.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Очистить',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                                icon: Icon(
                                  LucideIcons.x,
                                  size: 16,
                                  color: context.appColors.secondaryText,
                                ),
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: context.appColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: context.appColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: AppColors.primary),
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                    ),
                  ),
                  const Gap(8),
                  InkWell(
                    onTap: widget.onAddCategory,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: context.appColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.appColors.border),
                      ),
                      child: const Icon(
                        LucideIcons.plus,
                        size: 18,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: context.appColors.border),
            Expanded(
              child: filteredCategories.isEmpty
                  ? Center(
                      child: Text(
                        hasSearch
                            ? 'Ничего не найдено'
                            : 'Нет категорий расхода',
                        style: filterFieldHintTextStyleOf(context),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredCategories.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 1,
                        color: context.appColors.border,
                      ),
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onDoubleTap: () =>
                              widget.onCategoryDoubleTap(category),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              category.name,
                              style: filterFieldTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({required this.child});

  static const _fieldWidth = 250.0;

  static const _constraints = BoxConstraints(
    minWidth: _fieldWidth,
    maxWidth: _fieldWidth,
    minHeight: filterFieldHeight,
    maxHeight: filterFieldHeight,
  );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: _constraints,
      child: child,
    );
  }
}

class _FilterPlaceholder extends StatelessWidget {
  const _FilterPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: filterFieldHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: filterFieldHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appColors.border),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: filterFieldHintTextStyleOf(context),
      ),
    );
  }
}
