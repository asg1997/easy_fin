import 'dart:async';

import 'package:easy_fin/data/income_categories_storage/income_categories_storage.dart';
import 'package:easy_fin/data/incomes_storage/incomes_storage.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/base_account.dart';
import 'package:easy_fin/models/income.dart';
import 'package:easy_fin/models/income_category.dart';
import 'package:easy_fin/models/income_document.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:easy_fin/utils/amount_input_formatter.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/providers/renters_list_provider.dart';
import 'package:easy_fin/view/widgets/add_renter_dialog.dart';
import 'package:easy_fin/view/widgets/date_picker_field.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class _RenterRow {
  const _RenterRow({
    required this.renterId,
    required this.name,
    required this.accountNumber,
  });

  final RenterId renterId;
  final String name;
  final String accountNumber;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _RenterRow &&
            renterId == other.renterId &&
            accountNumber == other.accountNumber;
  }

  @override
  int get hashCode => Object.hash(renterId, accountNumber);
}

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

sealed class _IncomeLineEntry {
  _IncomeLineEntry({
    String amountText = '',
    String noteText = '',
    FocusNode? amountFocusNode,
  })  : amountController = TextEditingController(text: amountText),
        noteController = TextEditingController(text: noteText),
        amountFocusNode = amountFocusNode ?? FocusNode();

  final TextEditingController amountController;
  final TextEditingController noteController;
  final FocusNode amountFocusNode;

  String get displayLabel;

  void dispose() {
    amountController.dispose();
    noteController.dispose();
    amountFocusNode.dispose();
  }
}

final class _MutualSettlementIncomeLineEntry extends _IncomeLineEntry {
  _MutualSettlementIncomeLineEntry({
    required this.renter,
    super.amountText,
    super.noteText,
    super.amountFocusNode,
  });

  final _RenterRow renter;

  @override
  String get displayLabel => renter.name;
}

final class _CategoryIncomeLineEntry extends _IncomeLineEntry {
  _CategoryIncomeLineEntry({
    required this.category,
    super.amountText,
    super.noteText,
    super.amountFocusNode,
  });

  final IncomeCategory category;

  @override
  String get displayLabel => category.name;
}

enum _AddIncomeSourceAction { category, renter }

class AddIncomePage extends ConsumerStatefulWidget {
  const AddIncomePage({super.key, this.initialDocumentId});

  final String? initialDocumentId;

  static Future<void> navigate(
    BuildContext context, {
    String? documentId,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AddIncomePage(initialDocumentId: documentId),
      ),
    );
  }

  @override
  ConsumerState<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends ConsumerState<AddIncomePage> {
  Base? _selectedBase;
  late DateTime _selectedDate;
  _DocumentAccountOption? _selectedAccount;
  final List<_IncomeLineEntry> _lineEntries = [];
  bool _isLoadingDocument = false;
  String? _editingDocumentId;
  DateTime? _editingCreatedAt;
  List<IncomeCategory> _activeCategories = [];

  bool get _isEditing => _editingDocumentId != null;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    if (widget.initialDocumentId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_loadDocument(widget.initialDocumentId!));
      });
    }
  }

  Future<void> _loadDocument(String documentId) async {
    setState(() => _isLoadingDocument = true);

    final document = await ref.read(incomesStorageProvider).getById(documentId);
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
        IncomeDocumentCashAccount() => const _CashAccountOption(),
        IncomeDocumentBankAccount(:final accountNumber) =>
          _bankOptionForNumber(base, accountNumber),
      };
      _isLoadingDocument = false;
    });

    final renters = base == null
        ? <Renter>[]
        : await ref.read(rentersStorageProvider).getByBase(base.id);
    final renterById = {for (final renter in renters) renter.id: renter};
    final categories = await ref.read(incomeCategoriesStorageProvider).getAll();
    final categoryById = {
      for (final category in categories) category.id: category,
    };

    setState(() {
      for (final line in document.lines) {
        final source = line.incomeSource;
        switch (source) {
          case IncomeSourceFromRenter(:final renterId, :final accountNumber):
            final renter = renterById[renterId];
            if (renter == null) continue;

            _lineEntries.add(
              _MutualSettlementIncomeLineEntry(
                renter: _RenterRow(
                  renterId: renterId,
                  name: renter.name,
                  accountNumber: accountNumber,
                ),
                amountText: AmountInputFormatter.formatAmount(line.sum),
                noteText: line.note ?? '',
              ),
            );
          case IncomeSourceFromOther(:final categoryId):
            final category = categoryById[categoryId];
            if (category == null) continue;

            _lineEntries.add(
              _CategoryIncomeLineEntry(
                category: category,
                amountText: AmountInputFormatter.formatAmount(line.sum),
                noteText: line.note ?? '',
              ),
            );
        }
      }
    });

    unawaited(_loadActiveCategories());
  }

  Future<void> _loadActiveCategories() async {
    final categories =
        await ref.read(incomeCategoriesStorageProvider).getActive();
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

  void _addRenterLine(_RenterRow renter) {
    final alreadyAdded = _lineEntries.any(
      (entry) =>
          entry is _MutualSettlementIncomeLineEntry &&
          entry.renter.renterId == renter.renterId &&
          entry.renter.accountNumber == renter.accountNumber,
    );
    if (alreadyAdded) return;

    final focusNode = FocusNode();
    setState(() {
      _lineEntries.add(
        _MutualSettlementIncomeLineEntry(
          renter: renter,
          amountFocusNode: focusNode,
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _addCategoryLine(IncomeCategory category) {
    final focusNode = FocusNode();
    setState(() {
      _lineEntries.add(
        _CategoryIncomeLineEntry(
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

  IncomeDocumentAccount _toDocumentAccount(_DocumentAccountOption option) {
    return switch (option) {
      _CashAccountOption() => const IncomeDocumentCashAccount(),
      _BankAccountOption(:final account) =>
        IncomeDocumentBankAccount(accountNumber: account.accountNumber),
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

    final seenRenterKeys = <String>{};
    final lines = <Income>[];
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    for (var i = 0; i < _lineEntries.length; i++) {
      final entry = _lineEntries[i];
      final amount = AmountInputFormatter.parseAmount(entry.amountController.text);
      if (amount == null || amount <= 0) {
        await _showErrorDialog('Укажите сумму для «${entry.displayLabel}»');
        return;
      }

      final note = entry.noteController.text.trim();
      final IncomeSource incomeSource;
      switch (entry) {
        case _MutualSettlementIncomeLineEntry(:final renter):
          final key = '${renter.renterId}:${renter.accountNumber}';
          if (seenRenterKeys.contains(key)) {
            await _showErrorDialog(
              'Арендатор «${renter.name}» добавлен более одного раза',
            );
            return;
          }
          seenRenterKeys.add(key);
          incomeSource = IncomeSourceFromRenter(
            renterId: renter.renterId,
            accountNumber: renter.accountNumber,
          );
        case _CategoryIncomeLineEntry(:final category):
          incomeSource = IncomeSourceFromOther(categoryId: category.id);
      }

      lines.add(
        Income(
          id: '${timestamp}_$i',
          sum: amount,
          incomeSource: incomeSource,
          note: note.isEmpty ? null : note,
        ),
      );
    }

    final document = IncomeDocument(
      id: _editingDocumentId ?? timestamp.toString(),
      createdAt: _editingCreatedAt ?? DateTime.now(),
      baseId: baseId,
      date: _selectedDate,
      account: _toDocumentAccount(account),
      lines: lines,
    );

    try {
      final storage = ref.read(incomesStorageProvider);
      if (_isEditing) {
        await storage.updateDocument(document);
      } else {
        await storage.saveDocument(document);
      }

      if (!mounted) return;
      ref.invalidate(documentsListProvider);
      ref.invalidate(accountBalancesProvider);
      ref.invalidate(renterDebtsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Приход обновлён' : 'Приход сохранён'),
        ),
      );
      Navigator.of(context).pop();
    } on EmptyIncomeDocumentError {
      if (!mounted) return;
      await _showErrorDialog('Добавьте хотя бы одну строку');
    } on InvalidIncomeAmountError {
      if (!mounted) return;
      await _showErrorDialog('Сумма должна быть больше нуля');
    } on DuplicateIncomeRenterLineError {
      if (!mounted) return;
      await _showErrorDialog('Арендатор добавлен более одного раза');
    } on IncomeDocumentNotFoundError {
      if (!mounted) return;
      await _showErrorDialog('Документ не найден');
    } on Object catch (error) {
      if (!mounted) return;
      await _showErrorDialog('Не удалось сохранить приход\n$error');
    }
  }

  List<_RenterRow> _toRenterRows(List<Renter> renters) {
    return renters.expand((renter) {
      if (renter.accountNumbers.isEmpty) {
        return [
          _RenterRow(
            renterId: renter.id,
            name: renter.name,
            accountNumber: '',
          ),
        ];
      }

      return renter.accountNumbers.map(
        (accountNumber) => _RenterRow(
          renterId: renter.id,
          name: renter.name,
          accountNumber: accountNumber,
        ),
      );
    }).toList();
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
      await ref.read(incomeCategoriesStorageProvider).save(name);
      await _loadActiveCategories();
    } on ArgumentError {
      if (!mounted) return;
      await _showErrorDialog('Название категории не может быть пустым');
    }
  }

  Future<void> _onAddRenter() async {
    final result = await showDialog<AddRenterDialogResult>(
      context: context,
      builder: (context) => const AddRenterDialog(),
    );
    if (result == null) return;

    try {
      final baseId = _selectedBase?.id;
      if (baseId == null) return;

      await ref.read(rentersStorageProvider).save(
        Renter.create(
          baseId: baseId,
          name: result.name,
          accountNumbers: result.accountNumbers,
        ),
      );
      ref.invalidate(rentersListProvider);
    } on DuplicateRenterAccountNumbersError {
      if (!mounted) return;
      await _showErrorDialog('Счета не должны повторяться');
    } on InvalidRenterAccountNumberError {
      if (!mounted) return;
      await _showErrorDialog(
        'Номер р/с должен содержать $accountNumberLength символов',
      );
    } on AccountBelongsToAnotherRenterError catch (error) {
      if (!mounted) return;
      await _showErrorDialog(
        'Счёт ${error.accountNumber} уже привязан к другому арендатору',
      );
    }
  }

  Future<void> _showErrorDialog(String message) async {
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

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDocument) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final basesAsync = ref.watch(basesListProvider);
    final rentersAsync = ref.watch(
      rentersListProvider(RentersListFilter(baseId: _selectedBase?.id)),
    );
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
        title: _isEditing ? 'Редактирование прихода' : 'Приход',
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
                              child: _IncomeLinesTable(
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
                        child: rentersAsync.when(
                          data: (renters) => _IncomeSourcesPanel(
                            categories: _activeCategories,
                            renters: _toRenterRows(renters),
                            onCategoryDoubleTap: _addCategoryLine,
                            onRenterDoubleTap: _addRenterLine,
                            onAddCategory: _onAddCategory,
                            onAddRenter: _onAddRenter,
                          ),
                          loading: () => _IncomeSourcesPanel(
                            categories: _activeCategories,
                            renters: const [],
                            isLoadingRenters: true,
                            onCategoryDoubleTap: _addCategoryLine,
                            onRenterDoubleTap: _addRenterLine,
                            onAddCategory: _onAddCategory,
                            onAddRenter: _onAddRenter,
                          ),
                          error: (_, _) => _IncomeSourcesPanel(
                            categories: _activeCategories,
                            renters: const [],
                            onCategoryDoubleTap: _addCategoryLine,
                            onRenterDoubleTap: _addRenterLine,
                            onAddCategory: _onAddCategory,
                            onAddRenter: _onAddRenter,
                          ),
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

class _IncomeLinesTable extends StatelessWidget {
  const _IncomeLinesTable({
    required this.entries,
    required this.onRemoveLine,
  });

  final List<_IncomeLineEntry> entries;
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
                      'Тип',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Контрагент',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'р/с',
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
                        'Дважды нажмите на источник справа',
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
                        final typeLabel = switch (entry) {
                          _MutualSettlementIncomeLineEntry() => 'Взаиморасчёты',
                          _CategoryIncomeLineEntry(:final category) =>
                            category.name,
                        };
                        final counterpartyLabel = switch (entry) {
                          _MutualSettlementIncomeLineEntry(:final renter) =>
                            renter.name,
                          _CategoryIncomeLineEntry() => '—',
                        };
                        final accountNumberLabel = switch (entry) {
                          _MutualSettlementIncomeLineEntry(:final renter) =>
                            renter.accountNumber,
                          _CategoryIncomeLineEntry() => '—',
                        };

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
                                  typeLabel,
                                  style: filterFieldTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  counterpartyLabel,
                                  style: filterFieldTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  accountNumberLabel,
                                  style: filterFieldTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
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
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: '0,00',
                                    hintStyle: filterFieldHintTextStyleOf(context),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(right: 8),
                                  ),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: entry.noteController,
                                  style: filterFieldTextStyle,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Комментарий',
                                    hintStyle: filterFieldHintTextStyleOf(context),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 4),
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

class _IncomeSourcesPanel extends StatefulWidget {
  const _IncomeSourcesPanel({
    required this.categories,
    required this.renters,
    required this.onCategoryDoubleTap,
    required this.onRenterDoubleTap,
    required this.onAddCategory,
    required this.onAddRenter,
    this.isLoadingRenters = false,
  });

  final List<IncomeCategory> categories;
  final List<_RenterRow> renters;
  final void Function(IncomeCategory category) onCategoryDoubleTap;
  final void Function(_RenterRow renter) onRenterDoubleTap;
  final VoidCallback onAddCategory;
  final VoidCallback onAddRenter;
  final bool isLoadingRenters;

  @override
  State<_IncomeSourcesPanel> createState() => _IncomeSourcesPanelState();
}

class _IncomeSourcesPanelState extends State<_IncomeSourcesPanel> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IncomeCategory> get _filteredCategories {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return widget.categories;

    return widget.categories
        .where((category) => category.name.toLowerCase().contains(query))
        .toList();
  }

  List<_RenterRow> get _filteredRenters {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return widget.renters;

    return widget.renters.where((renter) {
      return renter.name.toLowerCase().contains(query) ||
          renter.accountNumber.contains(query);
    }).toList();
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      color: context.appColors.navActiveBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 12,
          fontWeight: FontWeight.w500,
          color: context.appColors.secondaryText,
        ),
      ),
    );
  }

  Widget _buildSourceRow({
    required String name,
    required String accountNumber,
    required VoidCallback onDoubleTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: onDoubleTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                name,
                style: filterFieldTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                accountNumber,
                style: filterFieldTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _filteredCategories;
    final filteredRenters = _filteredRenters;
    final hasSearch = _searchQuery.trim().isNotEmpty;
    final isEmpty = filteredCategories.isEmpty && filteredRenters.isEmpty;

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
                      'Источник',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'р/с',
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
                        hintText: 'Поиск источника',
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
                  PopupMenuButton<_AddIncomeSourceAction>(
                    tooltip: 'Добавить источник',
                    onSelected: (action) {
                      switch (action) {
                        case _AddIncomeSourceAction.category:
                          widget.onAddCategory();
                        case _AddIncomeSourceAction.renter:
                          widget.onAddRenter();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: _AddIncomeSourceAction.category,
                        child: Text('Категорию'),
                      ),
                      PopupMenuItem(
                        value: _AddIncomeSourceAction.renter,
                        child: Text('Арендатора'),
                      ),
                    ],
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
              child: widget.isLoadingRenters
                  ? const Center(child: CircularProgressIndicator())
                  : isEmpty
                  ? Center(
                      child: Text(
                        hasSearch
                            ? 'Ничего не найдено'
                            : 'Нет источников прихода',
                        style: filterFieldHintTextStyleOf(context),
                      ),
                    )
                  : ListView(
                      children: [
                        if (filteredCategories.isNotEmpty) ...[
                          _buildSectionHeader('Прочее'),
                          for (var i = 0; i < filteredCategories.length; i++) ...[
                            if (i > 0)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: context.appColors.border,
                              ),
                            _buildSourceRow(
                              name: filteredCategories[i].name,
                              accountNumber: '—',
                              onDoubleTap: () => widget.onCategoryDoubleTap(
                                filteredCategories[i],
                              ),
                            ),
                          ],
                        ],
                        if (filteredCategories.isNotEmpty &&
                            filteredRenters.isNotEmpty)
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: context.appColors.border,
                          ),
                        if (filteredRenters.isNotEmpty) ...[
                          _buildSectionHeader('Взаиморасчёты'),
                          for (var i = 0; i < filteredRenters.length; i++) ...[
                            if (i > 0)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: context.appColors.border,
                              ),
                            _buildSourceRow(
                              name: filteredRenters[i].name,
                              accountNumber: filteredRenters[i].accountNumber,
                              onDoubleTap: () => widget.onRenterDoubleTap(
                                filteredRenters[i],
                              ),
                            ),
                          ],
                        ],
                      ],
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
