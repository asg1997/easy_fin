import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/models/import_expense_review.dart';
import 'package:easy_fin/models/import_income_review.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

sealed class ImportExpenseReviewDialogResult {
  const ImportExpenseReviewDialogResult();
}

final class ImportExpenseReviewConfirmed extends ImportExpenseReviewDialogResult {
  const ImportExpenseReviewConfirmed(this.resolutions);

  final List<ImportExpenseResolution> resolutions;
}

final class ImportExpenseReviewCancelled extends ImportExpenseReviewDialogResult {
  const ImportExpenseReviewCancelled();
}

class ImportExpenseReviewDialog extends ConsumerStatefulWidget {
  const ImportExpenseReviewDialog({
    required this.statement,
    required this.baseName,
    required this.reviewItems,
    required this.categories,
    super.key,
  });

  final BankStatement statement;
  final String baseName;
  final List<ImportExpenseReviewItem> reviewItems;
  final List<ExpenseCategory> categories;

  @override
  ConsumerState<ImportExpenseReviewDialog> createState() =>
      _ImportExpenseReviewDialogState();
}

class _ImportExpenseReviewDialogState
    extends ConsumerState<ImportExpenseReviewDialog> {
  static final _dateFormat = DateFormat('dd.MM.yyyy', 'ru');
  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  InputDecoration _fieldDecoration(BuildContext context) {
    final colors = context.appColors;
    return InputDecoration(
    filled: true,
    fillColor: colors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: filterFieldHorizontalPadding,
    ),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: colors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: colors.border),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.primary),
    ),
  );
  }

  late final List<_ReviewItemForm> _forms;
  late List<ExpenseCategory> _categories;
  String? _validationError;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _categories = List<ExpenseCategory>.from(widget.categories);
    _forms = widget.reviewItems.map(_ReviewItemForm.fromItem).toList();
  }

  @override
  void dispose() {
    for (final form in _forms) {
      form.dispose();
    }
    super.dispose();
  }

  int get _totalOperations => widget.reviewItems.fold(
    0,
    (sum, item) => sum + item.operationIndices.length,
  );

  Future<void> _onContinue() async {
    setState(() {
      _validationError = null;
      _isSaving = true;
    });

    for (final form in _forms) {
      if (form.classification != ImportExpenseClassification.other ||
          form.categoryAction != ImportCategoryAction.create) {
        continue;
      }

      final name = form.categoryNameController.text.trim();
      if (name.isEmpty) {
        setState(() {
          _validationError = 'Укажите название категории';
          _isSaving = false;
        });
        return;
      }

      final category = await ref.read(expenseCategoriesStorageProvider).save(
        name,
      );
      form.selectedCategoryId = category.id;
      form.categoryAction = ImportCategoryAction.select;
      if (!_categories.any((item) => item.id == category.id)) {
        _categories = [..._categories, category];
      }
    }

    final error = _validate();
    if (error != null) {
      setState(() {
        _validationError = error;
        _isSaving = false;
      });
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop(
      ImportExpenseReviewConfirmed(
        _forms.map((form) => form.toResolution()).toList(),
      ),
    );
  }

  String? _validate() {
    for (final form in _forms) {
      final error = form.validate();
      if (error != null) return error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: screenHeight * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Проверка расходов',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Gap(12),
              Divider(
                color: context.appColors.border,
                thickness: 0.5,
                height: 1,
              ),
              const Gap(12),
              Text(
                'Выписка по счёту ${widget.statement.accountNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(4),
              Text(
                'База: ${widget.baseName}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(4),
              Text(
                '${_dateFormat.format(widget.statement.startDate)} — '
                '${_dateFormat.format(widget.statement.endDate)} · '
                '$_totalOperations ${_pluralPositions(_totalOperations)}',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: context.appColors.secondaryText,
                ),
              ),
              if (_validationError != null) ...[
                const Gap(12),
                Text(
                  _validationError!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
              const Gap(12),
              Expanded(
                child: ListView.separated(
                  itemCount: _forms.length,
                  separatorBuilder: (_, _) => const Gap(12),
                  itemBuilder: (context, index) {
                    final form = _forms[index];
                    final item = widget.reviewItems[index];
                    return switch (item) {
                      ImportExpenseCounterpartyItem() => _CounterpartyCard(
                        form: form,
                        item: item,
                        categories: _categories,
                        dateFormat: _dateFormat,
                        amountFormat: _amountFormat,
                        fieldDecoration: _fieldDecoration(context),
                        onChanged: () => setState(() => _validationError = null),
                      ),
                      ImportExpenseStandaloneItem() => _StandaloneCard(
                        form: form,
                        item: item,
                        categories: _categories,
                        dateFormat: _dateFormat,
                        amountFormat: _amountFormat,
                        fieldDecoration: _fieldDecoration(context),
                        onChanged: () => setState(() => _validationError = null),
                      ),
                    };
                  },
                ),
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(
                            const ImportExpenseReviewCancelled(),
                          ),
                    style: TextButton.styleFrom(
                      foregroundColor: context.appColors.secondaryText,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Gap(8),
                  MaterialButton(
                    onPressed: _isSaving ? null : _onContinue,
                    height: 40,
                    minWidth: 150,
                    color: AppColors.primary,
                    disabledColor: AppColors.primary.withValues(alpha: 0.35),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Продолжить импорт',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _pluralPositions(int count) {
    final mod10 = count % 10;
    final mod100 = count % 100;
    if (mod100 >= 11 && mod100 <= 14) return 'позиций';
    if (mod10 == 1) return 'позиция';
    if (mod10 >= 2 && mod10 <= 4) return 'позиции';
    return 'позиций';
  }
}

class _ReviewItemForm {
  _ReviewItemForm({
    required this.operationIndices,
    required this.categoryNameController,
    required this.classification,
    required this.categoryAction,
    required this.selectedCategoryId,
    required this.operationsExpanded,
    required this.accountNumber,
  });

  factory _ReviewItemForm.fromItem(ImportExpenseReviewItem item) {
    return switch (item) {
      ImportExpenseCounterpartyItem(:final originalAccountNumber) =>
        _ReviewItemForm(
          operationIndices: item.operationIndices,
          categoryNameController: TextEditingController(),
          classification: ImportExpenseClassification.unclassified,
          categoryAction: ImportCategoryAction.select,
          selectedCategoryId: null,
          operationsExpanded: false,
          accountNumber: originalAccountNumber,
        ),
      ImportExpenseStandaloneItem() => _ReviewItemForm(
        operationIndices: item.operationIndices,
        categoryNameController: TextEditingController(),
        classification: ImportExpenseClassification.unclassified,
        categoryAction: ImportCategoryAction.select,
        selectedCategoryId: null,
        operationsExpanded: true,
        accountNumber: null,
      ),
    };
  }

  final List<int> operationIndices;
  final TextEditingController categoryNameController;
  ImportExpenseClassification classification;
  ImportCategoryAction categoryAction;
  int? selectedCategoryId;
  bool operationsExpanded;
  final String? accountNumber;

  void dispose() {
    categoryNameController.dispose();
  }

  String? validate() {
    switch (classification) {
      case ImportExpenseClassification.other:
        if (categoryAction == ImportCategoryAction.select &&
            selectedCategoryId == null) {
          return 'Выберите категорию';
        }
        if (categoryAction == ImportCategoryAction.create &&
            categoryNameController.text.trim().isEmpty) {
          return 'Укажите название категории';
        }
      case ImportExpenseClassification.unclassified:
        break;
    }
    return null;
  }

  ImportExpenseResolution toResolution() {
    return ImportExpenseResolution(
      operationIndices: operationIndices,
      classification: classification,
      expenseCategoryId: classification == ImportExpenseClassification.other
          ? selectedCategoryId
          : null,
      accountNumber: classification == ImportExpenseClassification.other
          ? accountNumber
          : null,
    );
  }
}

class _CounterpartyCard extends StatelessWidget {
  const _CounterpartyCard({
    required this.form,
    required this.item,
    required this.categories,
    required this.dateFormat,
    required this.amountFormat,
    required this.fieldDecoration,
    required this.onChanged,
  });

  final _ReviewItemForm form;
  final ImportExpenseCounterpartyItem item;
  final List<ExpenseCategory> categories;
  final DateFormat dateFormat;
  final NumberFormat amountFormat;
  final InputDecoration fieldDecoration;
  final VoidCallback onChanged;

  double get _totalAmount =>
      item.operations.fold(0, (sum, operation) => sum + operation.amount);

  @override
  Widget build(BuildContext context) {
    final preview = item.operations.first;

    return _ReviewCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.suggestedName.isNotEmpty
                          ? item.suggestedName
                          : 'Получатель',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'Р/с получателя: ${item.originalAccountNumber}',
                      style: TextStyle(
                        fontSize: 13,
                        color: context.appColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${amountFormat.format(_totalAmount)} ₽',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (item.operations.length == 1 &&
              preview.note.trim().isNotEmpty) ...[
            const Gap(6),
            Text(
              '${dateFormat.format(preview.date)} · ${preview.note}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: context.appColors.secondaryText,
              ),
            ),
          ],
          if (!form.operationsExpanded && item.operations.length > 1) ...[
            const Gap(6),
            Text(
              '${dateFormat.format(preview.date)} · '
              '${amountFormat.format(preview.amount)} · ${preview.note}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: context.appColors.secondaryText),
            ),
          ],
          const Gap(12),
          _ClassificationSection(
            form: form,
            categories: categories,
            fieldDecoration: fieldDecoration,
            onChanged: onChanged,
          ),
          if (item.operations.length > 1) ...[
            const Gap(8),
            InkWell(
              onTap: () {
                form.operationsExpanded = !form.operationsExpanded;
                onChanged();
              },
              child: Row(
                children: [
                  Icon(
                    form.operationsExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 18,
                    color: context.appColors.secondaryText,
                  ),
                  const Gap(4),
                  Text(
                    'Расходы (${item.operations.length})',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.appColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (form.operationsExpanded && item.operations.length > 1) ...[
            const Gap(6),
            ...item.operations.map(
              (operation) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${dateFormat.format(operation.date)} · '
                  '${amountFormat.format(operation.amount)} · '
                  '${operation.note}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: context.appColors.secondaryText),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StandaloneCard extends StatelessWidget {
  const _StandaloneCard({
    required this.form,
    required this.item,
    required this.categories,
    required this.dateFormat,
    required this.amountFormat,
    required this.fieldDecoration,
    required this.onChanged,
  });

  final _ReviewItemForm form;
  final ImportExpenseStandaloneItem item;
  final List<ExpenseCategory> categories;
  final DateFormat dateFormat;
  final NumberFormat amountFormat;
  final InputDecoration fieldDecoration;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final operation = item.operation;

    return _ReviewCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  operation.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(12),
              Text(
                '${dateFormat.format(operation.date)} · '
                '${amountFormat.format(operation.amount)} ₽',
                style: TextStyle(fontSize: 13, color: context.appColors.secondaryText),
              ),
            ],
          ),
          const Gap(12),
          _ClassificationSection(
            form: form,
            categories: categories,
            fieldDecoration: fieldDecoration,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ClassificationSection extends StatelessWidget {
  const _ClassificationSection({
    required this.form,
    required this.categories,
    required this.fieldDecoration,
    required this.onChanged,
  });

  final _ReviewItemForm form;
  final List<ExpenseCategory> categories;
  final InputDecoration fieldDecoration;
  final VoidCallback onChanged;

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
        RadioGroup<ImportExpenseClassification>(
          groupValue: form.classification,
          onChanged: (value) {
            if (value == null) return;
            form.classification = value;
            onChanged();
          },
          child: Column(
            children: [
              _DialogRadioTile<ImportExpenseClassification>(
                value: ImportExpenseClassification.other,
                title: 'Прочий расход',
              ),
              if (form.classification == ImportExpenseClassification.other)
                Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 2),
                  child: Column(
                    children: [
                      RadioGroup<ImportCategoryAction>(
                        groupValue: form.categoryAction,
                        onChanged: (value) {
                          if (value == null) return;
                          form.categoryAction = value;
                          onChanged();
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: _DialogRadioTile<ImportCategoryAction>(
                                value: ImportCategoryAction.select,
                                title: 'Выбрать',
                              ),
                            ),
                            Expanded(
                              child: _DialogRadioTile<ImportCategoryAction>(
                                value: ImportCategoryAction.create,
                                title: 'Создать',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(6),
                      if (form.categoryAction == ImportCategoryAction.select)
                        DropdownWidget<ExpenseCategory>(
                          items: categories,
                          selectedItem: categories
                              .where((c) => c.id == form.selectedCategoryId)
                              .cast<ExpenseCategory?>()
                              .firstOrNull,
                          hint: 'Выберите категорию',
                          labelBuilder: (category) => category.name,
                          expand: true,
                          onChanged: (category) {
                            form.selectedCategoryId = category.id;
                            onChanged();
                          },
                        )
                      else
                        SizedBox(
                          height: filterFieldHeight,
                          child: TextField(
                            controller: form.categoryNameController,
                            style: filterFieldTextStyle,
                            decoration: fieldDecoration.copyWith(
                              hintText: 'Название категории',
                              hintStyle: filterFieldHintTextStyleOf(context),
                            ),
                            onChanged: (_) => onChanged(),
                          ),
                        ),
                    ],
                  ),
                ),
              _DialogRadioTile<ImportExpenseClassification>(
                value: ImportExpenseClassification.unclassified,
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
  const _DialogRadioTile({required this.value, required this.title});

  final T value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      title: Text(title, style: const TextStyle(fontSize: 13)),
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _ReviewCardShell extends StatelessWidget {
  const _ReviewCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
