import 'package:easy_fin/data/income_categories_storage/income_categories_storage.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/models/import_income_review.dart';
import 'package:easy_fin/models/income_category.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

sealed class ImportIncomeReviewDialogResult {
  const ImportIncomeReviewDialogResult();
}

final class ImportIncomeReviewConfirmed extends ImportIncomeReviewDialogResult {
  const ImportIncomeReviewConfirmed(this.resolutions);

  final List<ImportIncomeResolution> resolutions;
}

final class ImportIncomeReviewCancelled extends ImportIncomeReviewDialogResult {
  const ImportIncomeReviewCancelled();
}

class ImportIncomeReviewDialog extends ConsumerStatefulWidget {
  const ImportIncomeReviewDialog({
    required this.statement,
    required this.reviewItems,
    required this.renters,
    required this.categories,
    this.accountOwnerNames = const {},
    super.key,
  });

  final BankStatement statement;
  final List<ImportIncomeReviewItem> reviewItems;
  final List<Renter> renters;
  final List<IncomeCategory> categories;
  final Map<String, String> accountOwnerNames;

  @override
  ConsumerState<ImportIncomeReviewDialog> createState() =>
      _ImportIncomeReviewDialogState();
}

class _ImportIncomeReviewDialogState
    extends ConsumerState<ImportIncomeReviewDialog> {
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
  late List<IncomeCategory> _categories;
  String? _validationError;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _categories = List<IncomeCategory>.from(widget.categories);
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
      if (form.classification != ImportIncomeClassification.other ||
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

      final category = await ref.read(incomeCategoriesStorageProvider).save(
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
      ImportIncomeReviewConfirmed(
        _forms.map((form) => form.toResolution()).toList(),
      ),
    );
  }

  String? _validate() {
    final createAccounts = <String, int>{};

    for (final form in _forms) {
      final error = form.validate(
        renters: widget.renters,
        accountOwnerNames: widget.accountOwnerNames,
      );
      if (error != null) return error;

      if (form.classification == ImportIncomeClassification.renter &&
          form.renterAction == ImportRenterAction.create) {
        final account = form.accountController.text.trim();
        createAccounts[account] = (createAccounts[account] ?? 0) + 1;
        if (createAccounts[account]! > 1) {
          return 'Счёт $account указан более одного раза';
        }

        final ownerName = widget.accountOwnerNames[account];
        if (ownerName != null) {
          return 'Счёт уже привязан к $ownerName';
        }
      }
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
                'Проверка приходов',
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
                '${_dateFormat.format(widget.statement.startDate)} — '
                '${_dateFormat.format(widget.statement.endDate)} · '
                '${widget.statement.accountNumber} · '
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
                      ImportIncomeCounterpartyItem() => _CounterpartyCard(
                        form: form,
                        item: item,
                        renters: widget.renters,
                        categories: _categories,
                        dateFormat: _dateFormat,
                        amountFormat: _amountFormat,
                        fieldDecoration: _fieldDecoration(context),
                        onChanged: () => setState(() => _validationError = null),
                      ),
                      ImportIncomeStandaloneItem() => _StandaloneCard(
                        form: form,
                        item: item,
                        renters: widget.renters,
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
                            const ImportIncomeReviewCancelled(),
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
    required this.nameController,
    required this.accountController,
    required this.categoryNameController,
    required this.classification,
    required this.renterAction,
    required this.categoryAction,
    required this.selectedRenterId,
    required this.selectedCategoryId,
    required this.operationsExpanded,
    required this.isCounterparty,
  });

  factory _ReviewItemForm.fromItem(ImportIncomeReviewItem item) {
    return switch (item) {
      ImportIncomeCounterpartyItem(
        :final suggestedName,
        :final originalAccountNumber,
      ) =>
        _ReviewItemForm(
          operationIndices: item.operationIndices,
          nameController: TextEditingController(text: suggestedName),
          accountController: TextEditingController(
            text: originalAccountNumber,
          ),
          categoryNameController: TextEditingController(),
          classification: ImportIncomeClassification.unclassified,
          renterAction: ImportRenterAction.create,
          categoryAction: ImportCategoryAction.select,
          selectedRenterId: null,
          selectedCategoryId: null,
          operationsExpanded: false,
          isCounterparty: true,
        ),
      ImportIncomeStandaloneItem() => _ReviewItemForm(
        operationIndices: item.operationIndices,
        nameController: TextEditingController(),
        accountController: TextEditingController(),
        categoryNameController: TextEditingController(),
        classification: ImportIncomeClassification.unclassified,
        renterAction: ImportRenterAction.create,
        categoryAction: ImportCategoryAction.select,
        selectedRenterId: null,
        selectedCategoryId: null,
        operationsExpanded: true,
        isCounterparty: false,
      ),
    };
  }

  final List<int> operationIndices;
  final TextEditingController nameController;
  final TextEditingController accountController;
  final TextEditingController categoryNameController;
  ImportIncomeClassification classification;
  ImportRenterAction renterAction;
  ImportCategoryAction categoryAction;
  RenterId? selectedRenterId;
  int? selectedCategoryId;
  bool operationsExpanded;
  final bool isCounterparty;

  void dispose() {
    nameController.dispose();
    accountController.dispose();
    categoryNameController.dispose();
  }

  String? validate({
    required List<Renter> renters,
    required Map<String, String> accountOwnerNames,
  }) {
    switch (classification) {
      case ImportIncomeClassification.renter:
        if (renterAction == ImportRenterAction.create &&
            nameController.text.trim().isEmpty) {
          return 'Укажите имя арендатора';
        }
        if (!isValidAccountNumber(accountController.text.trim())) {
          return 'Номер р/с должен содержать 20 символов';
        }
        if (renterAction == ImportRenterAction.link && selectedRenterId == null) {
          return 'Выберите арендатора';
        }
      case ImportIncomeClassification.other:
        if (categoryAction == ImportCategoryAction.select &&
            selectedCategoryId == null) {
          return 'Выберите категорию';
        }
        if (categoryAction == ImportCategoryAction.create &&
            categoryNameController.text.trim().isEmpty) {
          return 'Укажите название категории';
        }
      case ImportIncomeClassification.unclassified:
        break;
    }
    return null;
  }

  ImportIncomeResolution toResolution() {
    return ImportIncomeResolution(
      operationIndices: operationIndices,
      classification: classification,
      name: classification == ImportIncomeClassification.renter
          ? nameController.text.trim()
          : null,
      accountNumber: classification == ImportIncomeClassification.renter
          ? accountController.text.trim()
          : null,
      renterAction: classification == ImportIncomeClassification.renter
          ? renterAction
          : null,
      linkedRenterId:
          classification == ImportIncomeClassification.renter &&
              renterAction == ImportRenterAction.link
          ? selectedRenterId
          : null,
      incomeCategoryId: classification == ImportIncomeClassification.other
          ? selectedCategoryId
          : null,
    );
  }
}

class _CounterpartyCard extends StatelessWidget {
  const _CounterpartyCard({
    required this.form,
    required this.item,
    required this.renters,
    required this.categories,
    required this.dateFormat,
    required this.amountFormat,
    required this.fieldDecoration,
    required this.onChanged,
  });

  final _ReviewItemForm form;
  final ImportIncomeCounterpartyItem item;
  final List<Renter> renters;
  final List<IncomeCategory> categories;
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
                          : 'Контрагент',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      item.originalAccountNumber,
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
          if (item.otherBaseRenterName != null) ...[
            const Gap(8),
            Text(
              'Счёт привязан к «${item.otherBaseRenterName}» (другая база)',
              style: TextStyle(fontSize: 13, color: Colors.orange.shade800),
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
            renters: renters,
            categories: categories,
            fieldDecoration: fieldDecoration,
            onChanged: onChanged,
          ),
          if (form.classification == ImportIncomeClassification.renter) ...[
            const Gap(12),
            _RenterFieldsRow(
              form: form,
              fieldDecoration: fieldDecoration,
              onChanged: onChanged,
            ),
          ],
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
                    'Приходы (${item.operations.length})',
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
    required this.renters,
    required this.categories,
    required this.dateFormat,
    required this.amountFormat,
    required this.fieldDecoration,
    required this.onChanged,
  });

  final _ReviewItemForm form;
  final ImportIncomeStandaloneItem item;
  final List<Renter> renters;
  final List<IncomeCategory> categories;
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
            renters: renters,
            categories: categories,
            fieldDecoration: fieldDecoration,
            onChanged: onChanged,
          ),
          if (form.classification == ImportIncomeClassification.renter) ...[
            const Gap(12),
            _RenterFieldsRow(
              form: form,
              fieldDecoration: fieldDecoration,
              onChanged: onChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _RenterFieldsRow extends StatelessWidget {
  const _RenterFieldsRow({
    required this.form,
    required this.fieldDecoration,
    required this.onChanged,
  });

  final _ReviewItemForm form;
  final InputDecoration fieldDecoration;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _LabeledField(
            label: 'Имя',
            child: SizedBox(
              height: filterFieldHeight,
              child: TextField(
                controller: form.nameController,
                style: filterFieldTextStyle,
                decoration: fieldDecoration.copyWith(
                  hintText: 'Имя арендатора',
                  hintStyle: filterFieldHintTextStyleOf(context),
                ),
                onChanged: (_) => onChanged(),
              ),
            ),
          ),
        ),
        const Gap(12),
        Expanded(
          flex: 4,
          child: _LabeledField(
            label: 'Р/с',
            child: SizedBox(
              height: filterFieldHeight,
              child: TextField(
                controller: form.accountController,
                style: filterFieldTextStyle,
                decoration: fieldDecoration.copyWith(
                  hintText: '20 цифр',
                  hintStyle: filterFieldHintTextStyleOf(context),
                ),
                onChanged: (_) => onChanged(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClassificationSection extends StatelessWidget {
  const _ClassificationSection({
    required this.form,
    required this.renters,
    required this.categories,
    required this.fieldDecoration,
    required this.onChanged,
  });

  final _ReviewItemForm form;
  final List<Renter> renters;
  final List<IncomeCategory> categories;
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
        RadioGroup<ImportIncomeClassification>(
          groupValue: form.classification,
          onChanged: (value) {
            if (value == null) return;
            form.classification = value;
            onChanged();
          },
          child: Column(
            children: [
              _DialogRadioTile<ImportIncomeClassification>(
                value: ImportIncomeClassification.renter,
                title: 'Арендатор',
              ),
              if (form.classification == ImportIncomeClassification.renter)
                Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 2),
                  child: Column(
                    children: [
                      RadioGroup<ImportRenterAction>(
                        groupValue: form.renterAction,
                        onChanged: (value) {
                          if (value == null) return;
                          form.renterAction = value;
                          onChanged();
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: _DialogRadioTile<ImportRenterAction>(
                                value: ImportRenterAction.create,
                                title: 'Создать',
                              ),
                            ),
                            Expanded(
                              child: _DialogRadioTile<ImportRenterAction>(
                                value: ImportRenterAction.link,
                                title: 'Привязать',
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (form.renterAction == ImportRenterAction.link) ...[
                        const Gap(6),
                        DropdownWidget<Renter>(
                          items: renters,
                          selectedItem: renters
                              .where((r) => r.id == form.selectedRenterId)
                              .cast<Renter?>()
                              .firstOrNull,
                          hint: 'Выберите арендатора',
                          labelBuilder: (renter) => renter.name,
                          expand: true,
                          onChanged: (renter) {
                            form.selectedRenterId = renter.id;
                            onChanged();
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              _DialogRadioTile<ImportIncomeClassification>(
                value: ImportIncomeClassification.other,
                title: 'Прочий приход',
              ),
              if (form.classification == ImportIncomeClassification.other)
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
                        DropdownWidget<IncomeCategory>(
                          items: categories,
                          selectedItem: categories
                              .where((c) => c.id == form.selectedCategoryId)
                              .cast<IncomeCategory?>()
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
              _DialogRadioTile<ImportIncomeClassification>(
                value: ImportIncomeClassification.unclassified,
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

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
