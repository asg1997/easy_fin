import 'dart:async';

import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/income_categories_storage/income_categories_storage.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/models/income_category.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/models/report_template.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/report_templates_provider.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/multi_dropdown_widget.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

class _AllBasesOption {
  const _AllBasesOption();
}

class _AllAccountsOption {
  const _AllAccountsOption();
}

const _allBasesOption = _AllBasesOption();
const _allAccountsOption = _AllAccountsOption();

class EditReportTemplatePage extends ConsumerStatefulWidget {
  const EditReportTemplatePage({
    this.template,
    super.key,
  });

  final ReportTemplate? template;

  static Future<void> navigate(
    BuildContext context, {
    ReportTemplate? template,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => EditReportTemplatePage(template: template),
      ),
    );
  }

  @override
  ConsumerState<EditReportTemplatePage> createState() =>
      _EditReportTemplatePageState();
}

class _EditReportTemplatePageState
    extends ConsumerState<EditReportTemplatePage> {
  late final TextEditingController _nameController;
  late ReportTemplateKind _kind;
  BaseId? _baseId;
  AccountFilterType? _accountType;
  late ReportIncomeSourceKind _incomeSourceKind;
  late bool _allRenters;
  late Set<RenterId> _selectedRenterIds;
  late Set<IncomeCategoryId> _selectedIncomeCategoryIds;
  late Set<ExpenseCategoryId> _selectedExpenseCategoryIds;

  List<Renter> _renters = [];
  List<IncomeCategory> _incomeCategories = [];
  List<ExpenseCategory> _expenseCategories = [];
  bool _isLoadingCatalogs = true;
  bool _isSaving = false;

  bool get _isEditing => widget.template != null;

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    _nameController = TextEditingController(text: template?.name ?? '');
    _kind = template?.kind ?? ReportTemplateKind.income;
    _baseId = template?.baseId;
    _accountType = template?.accountType;
    _incomeSourceKind =
        template?.income?.sourceKind ?? ReportIncomeSourceKind.renters;
    _allRenters = template?.income?.allRenters ?? false;
    _selectedRenterIds = {...?template?.income?.renterIds};
    _selectedIncomeCategoryIds = {...?template?.income?.incomeCategoryIds};
    _selectedExpenseCategoryIds = {
      ...?template?.expense?.expenseCategoryIds,
    };
    unawaited(_loadCatalogs());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogs() async {
    setState(() => _isLoadingCatalogs = true);

    final renters = await ref.read(rentersStorageProvider).getAll();
    final incomeCategories =
        await ref.read(incomeCategoriesStorageProvider).getActive();
    final expenseCategories =
        await ref.read(expenseCategoriesStorageProvider).getActive();

    if (!mounted) return;
    setState(() {
      _renters = renters.where((renter) => !renter.isArchived).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      _incomeCategories = incomeCategories
        ..sort((a, b) => a.name.compareTo(b.name));
      _expenseCategories = expenseCategories
        ..sort((a, b) => a.name.compareTo(b.name));
      _isLoadingCatalogs = false;
    });
  }

  List<Renter> get _availableRenters {
    final baseId = _baseId;
    if (baseId == null) return _renters;
    return _renters.where((renter) => renter.baseId == baseId).toList();
  }

  void _onBaseChanged(Object? value) {
    setState(() {
      if (value is Base) {
        _baseId = value.id;
      } else {
        _baseId = null;
        _accountType = null;
      }
      _selectedRenterIds.removeWhere(
        (id) => !_availableRenters.any((renter) => renter.id == id),
      );
    });
  }

  ReportTemplate _buildTemplate() {
    final id = widget.template?.id ?? const Uuid().v4();
    final name = _nameController.text.trim();

    return switch (_kind) {
      ReportTemplateKind.income => ReportTemplate(
          id: id,
          name: name,
          kind: _kind,
          baseId: _baseId,
          accountType: _baseId == null ? null : _accountType,
          income: ReportIncomeConfig(
            sourceKind: _incomeSourceKind,
            allRenters: _incomeSourceKind == ReportIncomeSourceKind.renters &&
                _allRenters,
            renterIds: _incomeSourceKind == ReportIncomeSourceKind.renters &&
                    !_allRenters
                ? _selectedRenterIds.toList()
                : const [],
            incomeCategoryIds:
                _incomeSourceKind == ReportIncomeSourceKind.other
                    ? _selectedIncomeCategoryIds.toList()
                    : const [],
          ),
        ),
      ReportTemplateKind.expense => ReportTemplate(
          id: id,
          name: name,
          kind: _kind,
          baseId: _baseId,
          accountType: _baseId == null ? null : _accountType,
          expense: ReportExpenseConfig(
            expenseCategoryIds: _selectedExpenseCategoryIds.toList(),
          ),
        ),
    };
  }

  Future<void> _onSave() async {
    final template = _buildTemplate();
    final error = template.validate();
    if (error != null) {
      await _showError(error);
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref.read(reportTemplatesProvider.notifier).save(template);
      if (!mounted) return;
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final basesAsync = ref.watch(basesListProvider);
    final colors = context.appColors;

    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: _isEditing ? 'Редактирование шаблона' : 'Новый шаблон',
        child: _isLoadingCatalogs
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Название',
                        style: filterFieldTextStyle.copyWith(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(8),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Название шаблона',
                          hintStyle: filterFieldHintTextStyleOf(context),
                          filled: true,
                          fillColor: colors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: filterFieldHorizontalPadding,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: colors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: colors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: colors.border),
                          ),
                        ),
                        style: filterFieldTextStyle.copyWith(
                          color: colors.primaryText,
                        ),
                      ),
                      const Gap(20),
                      Text(
                        'Тип',
                        style: filterFieldTextStyle.copyWith(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(8),
                      _KindToggle(
                        value: _kind,
                        onChanged: (kind) => setState(() => _kind = kind),
                      ),
                      const Gap(20),
                      Text(
                        'База',
                        style: filterFieldTextStyle.copyWith(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(8),
                      SizedBox(
                        height: filterFieldHeight,
                        child: basesAsync.when(
                          data: (bases) {
                            final items = <Object>[
                              _allBasesOption,
                              ...bases,
                            ];
                            Object selectedItem = _allBasesOption;
                            if (_baseId != null) {
                              for (final base in bases) {
                                if (base.id == _baseId) {
                                  selectedItem = base;
                                  break;
                                }
                              }
                            }

                            return DropdownWidget<Object>(
                              expand: true,
                              items: items,
                              selectedItem: selectedItem,
                              labelBuilder: (item) {
                                if (item is Base) return item.name;
                                return 'Все базы';
                              },
                              onChanged: _onBaseChanged,
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (_, _) => Text(
                            'Не удалось загрузить базы',
                            style: filterFieldHintTextStyleOf(context),
                          ),
                        ),
                      ),
                      if (_baseId != null) ...[
                        const Gap(20),
                        Text(
                          'Счёт',
                          style: filterFieldTextStyle.copyWith(
                            color: colors.primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(8),
                        SizedBox(
                          height: filterFieldHeight,
                          child: DropdownWidget<Object>(
                            expand: true,
                            items: const [
                              _allAccountsOption,
                              AccountFilterType.cash,
                              AccountFilterType.bank,
                            ],
                            selectedItem: _accountType ?? _allAccountsOption,
                            labelBuilder: (item) {
                              if (item is AccountFilterType) {
                                return item.label;
                              }
                              return 'Все счета';
                            },
                            onChanged: (value) {
                              setState(() {
                                _accountType = value is AccountFilterType
                                    ? value
                                    : null;
                              });
                            },
                          ),
                        ),
                      ],
                      const Gap(24),
                      if (_kind == ReportTemplateKind.income)
                        _buildIncomeSection(colors)
                      else
                        _buildExpenseSection(colors),
                      const Gap(28),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: MaterialButton(
                          onPressed: _isSaving ? null : _onSave,
                          height: filterFieldHeight,
                          minWidth: 180,
                          color: AppColors.purple,
                          disabledColor: AppColors.purple.withValues(
                            alpha: 0.5,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Сохранить',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                      const Gap(24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildIncomeSection(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Вид источника',
          style: filterFieldTextStyle.copyWith(
            color: colors.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        _IncomeSourceToggle(
          value: _incomeSourceKind,
          onChanged: (value) => setState(() => _incomeSourceKind = value),
        ),
        const Gap(20),
        if (_incomeSourceKind == ReportIncomeSourceKind.renters) ...[
          CheckboxListTile(
            value: _allRenters,
            onChanged: (value) {
              setState(() {
                _allRenters = value ?? false;
                if (_allRenters) {
                  _selectedRenterIds = {};
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Все арендаторы',
              style: filterFieldTextStyle.copyWith(color: colors.primaryText),
            ),
          ),
          if (!_allRenters) ...[
            const Gap(8),
            Text(
              'Арендаторы',
              style: filterFieldTextStyle.copyWith(
                color: colors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            MultiDropdownWidget<Renter>(
              expand: true,
              items: _availableRenters,
              selectedItems: _availableRenters
                  .where((renter) => _selectedRenterIds.contains(renter.id))
                  .toSet(),
              hint: 'Выберите арендаторов',
              labelBuilder: (renter) => renter.name,
              onChanged: (selected) {
                setState(() {
                  _selectedRenterIds = selected.map((r) => r.id).toSet();
                });
              },
            ),
          ],
        ] else ...[
          Text(
            'Категории прочих приходов',
            style: filterFieldTextStyle.copyWith(
              color: colors.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          MultiDropdownWidget<IncomeCategory>(
            expand: true,
            items: _incomeCategories,
            selectedItems: _incomeCategories
                .where(
                  (category) =>
                      _selectedIncomeCategoryIds.contains(category.id),
                )
                .toSet(),
            hint: 'Выберите категории',
            labelBuilder: (category) => category.name,
            onChanged: (selected) {
              setState(() {
                _selectedIncomeCategoryIds =
                    selected.map((category) => category.id).toSet();
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildExpenseSection(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Категории расходов',
          style: filterFieldTextStyle.copyWith(
            color: colors.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        MultiDropdownWidget<ExpenseCategory>(
          expand: true,
          items: _expenseCategories,
          selectedItems: _expenseCategories
              .where(
                (category) =>
                    _selectedExpenseCategoryIds.contains(category.id),
              )
              .toSet(),
          hint: 'Выберите категории',
          labelBuilder: (category) => category.name,
          onChanged: (selected) {
            setState(() {
              _selectedExpenseCategoryIds =
                  selected.map((category) => category.id).toSet();
            });
          },
        ),
      ],
    );
  }
}

class _KindToggle extends StatelessWidget {
  const _KindToggle({
    required this.value,
    required this.onChanged,
  });

  final ReportTemplateKind value;
  final ValueChanged<ReportTemplateKind> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final kind in ReportTemplateKind.values) ...[
          if (kind != ReportTemplateKind.values.first) const Gap(8),
          Expanded(
            child: _ToggleChip(
              label: kind.label,
              selected: value == kind,
              onTap: () => onChanged(kind),
            ),
          ),
        ],
      ],
    );
  }
}

class _IncomeSourceToggle extends StatelessWidget {
  const _IncomeSourceToggle({
    required this.value,
    required this.onChanged,
  });

  final ReportIncomeSourceKind value;
  final ValueChanged<ReportIncomeSourceKind> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final kind in ReportIncomeSourceKind.values) ...[
          if (kind != ReportIncomeSourceKind.values.first) const Gap(8),
          Expanded(
            child: _ToggleChip(
              label: kind.label,
              selected: value == kind,
              onTap: () => onChanged(kind),
            ),
          ),
        ],
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: selected ? AppColors.purple : colors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: filterFieldHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.purple : colors.border,
            ),
          ),
          child: Text(
            label,
            style: filterFieldTextStyle.copyWith(
              color: selected ? Colors.white : colors.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
