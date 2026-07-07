import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/providers/renters_list_provider.dart';
import 'package:easy_fin/view/widgets/add_renter_dialog.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/edit_renter_dialog.dart';
import 'package:easy_fin/view/widgets/simple_table.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RentersPage extends ConsumerStatefulWidget {
  const RentersPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const RentersPage()),
    );
  }

  @override
  ConsumerState<RentersPage> createState() => _RentersPageState();
}

class _RentersPageState extends ConsumerState<RentersPage> {
  Base? _selectedBase;
  bool _showArchived = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Renter> _filteredRenters(List<Renter> renters) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return renters;

    return renters.where((renter) {
      return renter.name.toLowerCase().contains(query) ||
          renter.accountNumbers.any((account) => account.contains(query));
    }).toList();
  }

  Future<void> _onAddRenter() async {
    final baseId = _selectedBase?.id;
    if (baseId == null) return;

    final result = await showDialog<AddRenterDialogResult>(
      context: context,
      builder: (context) => const AddRenterDialog(),
    );
    if (result == null) return;

    try {
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
      await _showError('Счета не должны повторяться');
    } on InvalidRenterAccountNumberError {
      if (!mounted) return;
      await _showError(
        'Номер р/с должен содержать $accountNumberLength символов',
      );
    } on AccountBelongsToAnotherRenterError catch (error) {
      if (!mounted) return;
      await _showError(
        'Счёт ${error.accountNumber} уже привязан к другому арендатору',
      );
    }
  }

  Future<void> _onEditRenter(Renter renter) async {
    final outcome = await showDialog<EditRenterDialogOutcome>(
      context: context,
      builder: (context) => EditRenterDialog(renter: renter),
    );
    if (outcome == null) return;

    switch (outcome) {
      case EditRenterDialogArchived():
        await ref.read(rentersStorageProvider).archive(renter.id);
        ref.invalidate(rentersListProvider);
        ref.invalidate(renterDebtsProvider);
      case EditRenterDialogRestored():
        await ref.read(rentersStorageProvider).unarchive(renter.id);
        ref.invalidate(rentersListProvider);
        ref.invalidate(renterDebtsProvider);
      case EditRenterDialogSaved(:final name, :final accountNumbers):
        try {
          await ref.read(rentersStorageProvider).save(
            Renter(
              id: renter.id,
              baseId: renter.baseId,
              name: name,
              accountNumbers: accountNumbers,
              isArchived: renter.isArchived,
            ),
          );
          ref.invalidate(rentersListProvider);
        } on DuplicateRenterAccountNumbersError {
          if (!mounted) return;
          await _showError('Счета не должны повторяться');
        } on InvalidRenterAccountNumberError {
          if (!mounted) return;
          await _showError(
            'Номер р/с должен содержать $accountNumberLength символов',
          );
        } on AccountBelongsToAnotherRenterError catch (error) {
          if (!mounted) return;
          await _showError(
            'Счёт ${error.accountNumber} уже привязан к другому арендатору',
          );
        }
    }
  }

  Future<void> _onDeleteRenter(Renter renter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmDialog(
        title: 'Удалить арендатора?',
        message: 'Арендатор будет удалён безвозвратно.',
        confirmLabel: 'Удалить',
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(rentersStorageProvider).delete(renter.id);
      ref.invalidate(rentersListProvider);
      ref.invalidate(renterDebtsProvider);
    } on RenterInUseError {
      if (!mounted) return;
      await _showError(
        'Арендатор используется в документах. Архивируйте его вместо удаления.',
      );
    } on RenterNotFoundError {
      if (!mounted) return;
      await _showError('Арендатор не найден');
    }
  }

  Future<void> _showError(String message) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
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
  Widget build(BuildContext context) {
    final basesAsync = ref.watch(basesListProvider);
    final rentersAsync = ref.watch(
      rentersListProvider(
        RentersListFilter(
          baseId: _selectedBase?.id,
          includeArchived: _showArchived,
        ),
      ),
    );

    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: 'Арендаторы',
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
                      onChanged: (base) {
                        setState(() {
                          _selectedBase = base;
                          _showArchived = false;
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    ),
                    loading: () =>
                        const _FilterPlaceholder(label: 'Выбор базы'),
                    error: (_, _) =>
                        const _FilterPlaceholder(label: 'Выбор базы'),
                  ),
                ),
                if (_selectedBase != null) ...[
                  const Gap(12),
                  _ShowArchivedCheckbox(
                    value: _showArchived,
                    onChanged: (value) {
                      setState(() => _showArchived = value);
                    },
                  ),
                ],
              ],
            ),
            if (_selectedBase != null) ...[
              const Gap(12),
              Expanded(
                child: rentersAsync.when(
                  data: (renters) {
                    final filteredRenters = _filteredRenters(renters);
                    final showArchiveIcon = filteredRenters.any(
                      (renter) => renter.isArchived,
                    );
                    final leadingWidth = showArchiveIcon ? 76.0 : 60.0;

                    return SimpleTable(
                      columns: const ['Название', 'Расчётные счета'],
                      columnFlex: const [2, 3],
                      leadingWidth: leadingWidth,
                      rows: filteredRenters
                          .map(
                            (renter) => [
                              renter.name,
                              renter.accountNumbers.join(', '),
                            ],
                          )
                          .toList(),
                      rowLeadingBuilder: (index) {
                        final renter = filteredRenters[index];

                        return SizedBox(
                          width: leadingWidth,
                          child: Row(
                            children: [
                              IconButton(
                                tooltip: 'Редактировать',
                                onPressed: () => _onEditRenter(renter),
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
                              IconButton(
                                tooltip: 'Удалить',
                                onPressed: () => _onDeleteRenter(renter),
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
                              if (showArchiveIcon)
                                renter.isArchived
                                    ? const Icon(
                                        LucideIcons.archive,
                                        size: 16,
                                        color: AppColors.purple,
                                      )
                                    : const SizedBox(width: 16),
                            ],
                          ),
                        );
                      },
                      belowHeader: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: filterFieldTextStyle,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Поиск арендатора',
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
                                    borderSide: BorderSide(
                                      color: context.appColors.border,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: context.appColors.border,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() => _searchQuery = value);
                                },
                              ),
                            ),
                            const Gap(8),
                            IconButton(
                              tooltip: 'Добавить арендатора',
                              onPressed: _onAddRenter,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: context.appColors.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: context.appColors.border,
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                LucideIcons.plus,
                                size: 18,
                                color: AppColors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      emptyMessage: _searchQuery.trim().isEmpty
                          ? 'Нет арендаторов'
                          : 'Ничего не найдено',
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => const Center(
                    child: Text('Не удалось загрузить арендаторов'),
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

class _ShowArchivedCheckbox extends StatelessWidget {
  const _ShowArchivedCheckbox({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: filterFieldHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.appColors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: value,
                    onChanged: (checked) {
                      if (checked != null) onChanged(checked);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const Gap(4),
                Text(
                  'Показать архив',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
