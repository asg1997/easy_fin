import 'dart:async';

import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/income_categories_storage/income_categories_storage.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/models/income_category.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

enum _IncomeClassification { renter, category, unclassified }

enum _ExpenseClassification { category, unclassified }

class EditBankOperationDialog extends ConsumerStatefulWidget {
  const EditBankOperationDialog({
    required this.operationId,
    super.key,
  });

  final int operationId;

  static Future<bool> show(BuildContext context, {required int operationId}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditBankOperationDialog(operationId: operationId),
    );
    return result == true;
  }

  @override
  ConsumerState<EditBankOperationDialog> createState() =>
      _EditBankOperationDialogState();
}

class _EditBankOperationDialogState
    extends ConsumerState<EditBankOperationDialog> {
  static final _dateFormat = DateFormat('dd.MM.yyyy', 'ru');
  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  BankStatementOperation? _operation;

  _IncomeClassification _incomeClassification =
      _IncomeClassification.unclassified;
  _ExpenseClassification _expenseClassification =
      _ExpenseClassification.unclassified;

  Renter? _selectedRenter;
  IncomeCategory? _selectedIncomeCategory;
  ExpenseCategory? _selectedExpenseCategory;

  List<Renter> _renters = [];
  List<IncomeCategory> _incomeCategories = [];
  List<ExpenseCategory> _expenseCategories = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_load());
    });
  }

  Future<void> _load() async {
    final details = await ref
        .read(bankStatementStorageProvider)
        .getOperationWithBase(widget.operationId);
    if (!mounted) return;

    if (details == null) {
      setState(() {
        _isLoading = false;
        _loadError = 'Операция не найдена';
      });
      return;
    }

    final operation = details.operation;
    final baseId = details.baseId;

    final renters = await ref.read(rentersStorageProvider).getByBase(baseId);
    final incomeCategories =
        await ref.read(incomeCategoriesStorageProvider).getActive();
    final expenseCategories =
        await ref.read(expenseCategoriesStorageProvider).getActive();
    if (!mounted) return;

    _IncomeClassification incomeClassification =
        _IncomeClassification.unclassified;
    Renter? selectedRenter;
    IncomeCategory? selectedIncomeCategory;

    if (operation.renterId != null) {
      incomeClassification = _IncomeClassification.renter;
      selectedRenter = renters
          .where((renter) => renter.id == operation.renterId)
          .firstOrNull;
    } else if (operation.incomeCategoryId != null) {
      incomeClassification = _IncomeClassification.category;
      selectedIncomeCategory = incomeCategories
          .where((category) => category.id == operation.incomeCategoryId)
          .firstOrNull;
      if (selectedIncomeCategory == null) {
        final all = await ref.read(incomeCategoriesStorageProvider).getAll();
        selectedIncomeCategory = all
            .where((category) => category.id == operation.incomeCategoryId)
            .firstOrNull;
        if (selectedIncomeCategory != null) {
          incomeCategories.add(selectedIncomeCategory);
        }
      }
    }

    _ExpenseClassification expenseClassification =
        _ExpenseClassification.unclassified;
    ExpenseCategory? selectedExpenseCategory;
    if (operation.expenseCategoryId != null) {
      expenseClassification = _ExpenseClassification.category;
      selectedExpenseCategory = expenseCategories
          .where((category) => category.id == operation.expenseCategoryId)
          .firstOrNull;
      if (selectedExpenseCategory == null) {
        final all = await ref.read(expenseCategoriesStorageProvider).getAll();
        selectedExpenseCategory = all
            .where((category) => category.id == operation.expenseCategoryId)
            .firstOrNull;
        if (selectedExpenseCategory != null) {
          expenseCategories.add(selectedExpenseCategory);
        }
      }
    }

    setState(() {
      _operation = operation;
      _renters = renters;
      _incomeCategories = incomeCategories;
      _expenseCategories = expenseCategories;
      _incomeClassification = incomeClassification;
      _expenseClassification = expenseClassification;
      _selectedRenter = selectedRenter;
      _selectedIncomeCategory = selectedIncomeCategory;
      _selectedExpenseCategory = selectedExpenseCategory;
      _isLoading = false;
    });
  }

  bool get _canSave {
    final operation = _operation;
    if (operation == null || _isSaving) return false;

    if (operation.isCredit) {
      return switch (_incomeClassification) {
        _IncomeClassification.renter => _selectedRenter != null,
        _IncomeClassification.category => _selectedIncomeCategory != null,
        _IncomeClassification.unclassified => true,
      };
    }

    return switch (_expenseClassification) {
      _ExpenseClassification.category => _selectedExpenseCategory != null,
      _ExpenseClassification.unclassified => true,
    };
  }

  Future<void> _onSave() async {
    final operation = _operation;
    if (operation == null || !_canSave) return;

    setState(() => _isSaving = true);

    try {
      String? renterId;
      int? incomeCategoryId;
      int? expenseCategoryId;

      if (operation.isCredit) {
        switch (_incomeClassification) {
          case _IncomeClassification.renter:
            renterId = _selectedRenter!.id;
          case _IncomeClassification.category:
            incomeCategoryId = _selectedIncomeCategory!.id;
          case _IncomeClassification.unclassified:
            break;
        }
      } else {
        switch (_expenseClassification) {
          case _ExpenseClassification.category:
            expenseCategoryId = _selectedExpenseCategory!.id;
          case _ExpenseClassification.unclassified:
            break;
        }
      }

      await ref.read(bankStatementStorageProvider).updateOperationClassification(
            operationId: widget.operationId,
            renterId: renterId,
            incomeCategoryId: incomeCategoryId,
            expenseCategoryId: expenseCategoryId,
          );

      ref.invalidate(documentsListProvider);
      ref.invalidate(accountBalancesProvider);
      ref.invalidate(renterDebtsProvider);
      ref.invalidate(githubSyncDirtyProvider);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось сохранить\n$error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final operation = _operation;

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: _isLoading
              ? const SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator()),
                )
              : _loadError != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _loadError!,
                      style: TextStyle(color: colors.primaryText),
                    ),
                    const Gap(16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Закрыть'),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      operation!.isCredit
                          ? 'Редактирование прихода'
                          : 'Редактирование расхода',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryText,
                      ),
                    ),
                    const Gap(12),
                    Divider(color: colors.border, thickness: 0.5, height: 1),
                    const Gap(16),
                    Text(
                      '${_dateFormat.format(operation.date)} · '
                      '${_amountFormat.format(operation.credit ?? operation.debit ?? 0)} ₽',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.primaryText,
                      ),
                    ),
                    if (operation.note.trim().isNotEmpty) ...[
                      const Gap(8),
                      Text(
                        operation.note,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                    const Gap(20),
                    if (operation.isCredit)
                      _IncomeClassificationSection(
                        classification: _incomeClassification,
                        renters: _renters,
                        categories: _incomeCategories,
                        selectedRenter: _selectedRenter,
                        selectedCategory: _selectedIncomeCategory,
                        onClassificationChanged: (value) {
                          setState(() => _incomeClassification = value);
                        },
                        onRenterChanged: (renter) {
                          setState(() => _selectedRenter = renter);
                        },
                        onCategoryChanged: (category) {
                          setState(() => _selectedIncomeCategory = category);
                        },
                      )
                    else
                      _ExpenseClassificationSection(
                        classification: _expenseClassification,
                        categories: _expenseCategories,
                        selectedCategory: _selectedExpenseCategory,
                        onClassificationChanged: (value) {
                          setState(() => _expenseClassification = value);
                        },
                        onCategoryChanged: (category) {
                          setState(() => _selectedExpenseCategory = category);
                        },
                      ),
                    const Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            foregroundColor: colors.secondaryText,
                          ),
                          child: const Text('Отмена'),
                        ),
                        const Gap(8),
                        FilledButton(
                          onPressed: _canSave ? _onSave : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: colors.accent,
                            foregroundColor: colors.onAccent,
                          ),
                          child: _isSaving
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.onAccent,
                                  ),
                                )
                              : const Text('Сохранить'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _IncomeClassificationSection extends StatelessWidget {
  const _IncomeClassificationSection({
    required this.classification,
    required this.renters,
    required this.categories,
    required this.selectedRenter,
    required this.selectedCategory,
    required this.onClassificationChanged,
    required this.onRenterChanged,
    required this.onCategoryChanged,
  });

  final _IncomeClassification classification;
  final List<Renter> renters;
  final List<IncomeCategory> categories;
  final Renter? selectedRenter;
  final IncomeCategory? selectedCategory;
  final ValueChanged<_IncomeClassification> onClassificationChanged;
  final ValueChanged<Renter> onRenterChanged;
  final ValueChanged<IncomeCategory> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Классификация',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const Gap(8),
        RadioGroup<_IncomeClassification>(
          groupValue: classification,
          onChanged: (value) {
            if (value != null) onClassificationChanged(value);
          },
          child: Column(
            children: [
              const _DialogRadioTile(
                value: _IncomeClassification.renter,
                title: 'Арендатор',
              ),
              if (classification == _IncomeClassification.renter)
                Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 8),
                  child: DropdownWidget<Renter>(
                    expand: true,
                    items: renters,
                    hint: 'Выберите арендатора',
                    selectedItem: selectedRenter,
                    labelBuilder: (item) => item.name,
                    onChanged: onRenterChanged,
                  ),
                ),
              const _DialogRadioTile(
                value: _IncomeClassification.category,
                title: 'Прочий приход',
              ),
              if (classification == _IncomeClassification.category)
                Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 8),
                  child: DropdownWidget<IncomeCategory>(
                    expand: true,
                    items: categories,
                    hint: 'Выберите категорию',
                    selectedItem: selectedCategory,
                    labelBuilder: (item) => item.name,
                    onChanged: onCategoryChanged,
                  ),
                ),
              const _DialogRadioTile(
                value: _IncomeClassification.unclassified,
                title: 'Без классификации',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpenseClassificationSection extends StatelessWidget {
  const _ExpenseClassificationSection({
    required this.classification,
    required this.categories,
    required this.selectedCategory,
    required this.onClassificationChanged,
    required this.onCategoryChanged,
  });

  final _ExpenseClassification classification;
  final List<ExpenseCategory> categories;
  final ExpenseCategory? selectedCategory;
  final ValueChanged<_ExpenseClassification> onClassificationChanged;
  final ValueChanged<ExpenseCategory> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Классификация',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const Gap(8),
        RadioGroup<_ExpenseClassification>(
          groupValue: classification,
          onChanged: (value) {
            if (value != null) onClassificationChanged(value);
          },
          child: Column(
            children: [
              const _DialogRadioTile(
                value: _ExpenseClassification.category,
                title: 'Категория расхода',
              ),
              if (classification == _ExpenseClassification.category)
                Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 8),
                  child: DropdownWidget<ExpenseCategory>(
                    expand: true,
                    items: categories,
                    hint: 'Выберите категорию',
                    selectedItem: selectedCategory,
                    labelBuilder: (item) => item.name,
                    onChanged: onCategoryChanged,
                  ),
                ),
              const _DialogRadioTile(
                value: _ExpenseClassification.unclassified,
                title: 'Без классификации',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DialogRadioTile<T> extends StatelessWidget {
  const _DialogRadioTile({
    required this.value,
    required this.title,
  });

  final T value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: filterFieldTextStyle),
    );
  }
}
