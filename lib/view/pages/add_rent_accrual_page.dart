import 'dart:async';

import 'package:easy_fin/data/renter_assignments_storage/renter_assignments_storage.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/models/renter_assignment.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:easy_fin/utils/amount_input_formatter.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_snack_bar.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/providers/renters_list_provider.dart';
import 'package:easy_fin/view/widgets/add_renter_dialog.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:easy_fin/view/widgets/date_picker_field.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/simple_table.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class _RenterRow {
  const _RenterRow({
    required this.renterId,
    required this.name,
    required this.accountNumbers,
  });

  final RenterId renterId;
  final String name;
  final List<String> accountNumbers;

  String get accountNumbersLabel {
    if (accountNumbers.isEmpty) return '—';
    return accountNumbers.join(', ');
  }
}

class _AccrualEntry {
  _AccrualEntry({
    required this.renter,
    required this.amountController,
    required this.amountFocusNode,
  });

  final _RenterRow renter;
  final TextEditingController amountController;
  final FocusNode amountFocusNode;
}

class AddRentAccrualPage extends ConsumerStatefulWidget {
  const AddRentAccrualPage({
    super.key,
    this.initialBaseId,
    this.initialMonth,
  });

  final String? initialBaseId;
  final DateTime? initialMonth;

  static Future<void> navigate(
    BuildContext context, {
    String? baseId,
    DateTime? month,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AddRentAccrualPage(
          initialBaseId: baseId,
          initialMonth: month,
        ),
      ),
    );
  }

  @override
  ConsumerState<AddRentAccrualPage> createState() => _AddRentAccrualPageState();
}

class _AddRentAccrualPageState extends ConsumerState<AddRentAccrualPage> {
  Base? _selectedBase;
  late DateTime _selectedDate;

  /// Месяц в БД, к которому привязано текущее содержимое формы.
  /// При смене даты начисления и сохранении этот месяц удаляется.
  DateTime? _boundMonth;
  final List<_AccrualEntry> _accrualEntries = [];

  bool get _isEditing =>
      widget.initialMonth != null && widget.initialBaseId != null;

  static final _monthLabelFormat = DateFormat('LLLL yyyy', 'ru');

  String _formatMonthLabel(DateTime month) {
    final formatted = _monthLabelFormat.format(
      normalizeRenterAssignmentMonth(month),
    );
    if (formatted.isEmpty) return formatted;
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  bool _isSameMonth(DateTime a, DateTime b) {
    final left = normalizeRenterAssignmentMonth(a);
    final right = normalizeRenterAssignmentMonth(b);
    return left.year == right.year && left.month == right.month;
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final initialMonth = widget.initialMonth;
    _selectedDate = initialMonth != null
        ? normalizeRenterAssignmentDate(initialMonth)
        : DateTime(now.year, now.month, now.day);
    if (_isEditing) {
      _boundMonth = normalizeRenterAssignmentMonth(initialMonth!);
    }
    if (widget.initialBaseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_loadInitialBase());
      });
    }
  }

  Future<void> _loadInitialBase() async {
    final bases = await ref.read(basesListProvider.future);
    if (!mounted) return;

    final base = bases
        .where((item) => item.id == widget.initialBaseId)
        .firstOrNull;
    if (base == null) return;

    setState(() {
      _selectedBase = base;
    });
    await _loadAccruals();
  }

  @override
  void dispose() {
    _clearAccruals();
    super.dispose();
  }

  void _clearAccruals() {
    for (final entry in _accrualEntries) {
      entry.amountController.dispose();
      entry.amountFocusNode.dispose();
    }
    _accrualEntries.clear();
  }

  void _onBaseChanged(Base base) {
    _clearAccruals();
    setState(() {
      _selectedBase = base;
      _boundMonth = null;
    });
    unawaited(_loadAccruals());
  }

  void _onDateChanged(DateTime? date) {
    if (date == null) return;

    final keepCurrentLines = _boundMonth != null || _accrualEntries.isNotEmpty;
    setState(() {
      _selectedDate = date;
    });

    // Если форма уже привязана к документу или заполнена — меняем только
    // дату начисления, не подгружая другой месяц.
    if (!keepCurrentLines) {
      unawaited(_loadAccruals());
    }
  }

  void _addRenterToAccruals(_RenterRow renter) {
    final alreadyAdded = _accrualEntries.any(
      (entry) => entry.renter.renterId == renter.renterId,
    );
    if (alreadyAdded) return;

    final focusNode = FocusNode();

    setState(() {
      _accrualEntries.add(
        _AccrualEntry(
          renter: renter,
          amountController: TextEditingController(),
          amountFocusNode: focusNode,
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _removeAccrualEntry(int index) {
    final entry = _accrualEntries[index];
    entry.amountController.dispose();
    entry.amountFocusNode.dispose();
    setState(() {
      _accrualEntries.removeAt(index);
    });
  }

  Future<void> _onCopyFromPreviousMonth() async {
    final baseId = _selectedBase?.id;
    if (baseId == null) return;

    final previousMonth = DateTime(
      _selectedDate.month == 1
          ? _selectedDate.year - 1
          : _selectedDate.year,
      _selectedDate.month == 1 ? 12 : _selectedDate.month - 1,
    );

    final assignments = await ref
        .read(renterAssignmentsStorageProvider)
        .getByBaseAndMonth(baseId, previousMonth);
    if (!mounted) return;

    if (assignments.isEmpty) {
      await _showErrorDialog('Нет начислений за предыдущий месяц');
      return;
    }

    final renters = await ref.read(rentersStorageProvider).getByBase(baseId);
    final archivedRenters =
        await ref.read(rentersStorageProvider).getArchivedByBase(baseId);
    final renterById = {
      for (final renter in [...renters, ...archivedRenters]) renter.id: renter,
    };

    _clearAccruals();
    setState(() {
      _accrualEntries.addAll(
        _buildAccrualEntriesFromAssignments(assignments, renterById),
      );
      // Копия предназначена для текущего выбранного месяца.
      _boundMonth = normalizeRenterAssignmentMonth(_selectedDate);
    });
  }

  Future<void> _loadAccruals() async {
    final baseId = _selectedBase?.id;
    if (baseId == null) return;

    final assignments = await ref
        .read(renterAssignmentsStorageProvider)
        .getByBaseAndMonth(baseId, _selectedDate);
    if (!mounted) return;

    final renters = await ref.read(rentersStorageProvider).getByBase(baseId);
    final archivedRenters =
        await ref.read(rentersStorageProvider).getArchivedByBase(baseId);
    final renterById = {
      for (final renter in [...renters, ...archivedRenters]) renter.id: renter,
    };

    _clearAccruals();
    setState(() {
      _accrualEntries.addAll(
        _buildAccrualEntriesFromAssignments(assignments, renterById),
      );
      if (assignments.isEmpty) {
        _boundMonth = null;
      } else {
        _boundMonth = normalizeRenterAssignmentMonth(_selectedDate);
        // Показываем фактическую сохранённую дату (не 1-е число месяца).
        _selectedDate = normalizeRenterAssignmentDate(assignments.first.date);
      }
    });
  }

  List<_AccrualEntry> _buildAccrualEntriesFromAssignments(
    List<RenterAssignment> assignments,
    Map<RenterId, Renter> renterById,
  ) {
    final sumByRenterId = <RenterId, double>{};
    final order = <RenterId>[];

    for (final assignment in assignments) {
      if (!renterById.containsKey(assignment.renterId)) continue;

      if (!sumByRenterId.containsKey(assignment.renterId)) {
        order.add(assignment.renterId);
        sumByRenterId[assignment.renterId] = 0;
      }
      sumByRenterId[assignment.renterId] =
          sumByRenterId[assignment.renterId]! + assignment.sum;
    }

    return [
      for (final renterId in order)
        _AccrualEntry(
          renter: _RenterRow(
            renterId: renterId,
            name: renterById[renterId]!.name,
            accountNumbers: renterById[renterId]!.accountNumbers,
          ),
          amountController: TextEditingController(
            text: AmountInputFormatter.formatAmount(sumByRenterId[renterId]!),
          ),
          amountFocusNode: FocusNode(),
        ),
    ];
  }

  Future<void> _onSave() async {
    final baseId = _selectedBase?.id;
    if (baseId == null) return;

    if (_accrualEntries.isEmpty) {
      await _showErrorDialog('Добавьте хотя бы одно начисление');
      return;
    }

    final seen = <RenterId>{};
    for (final entry in _accrualEntries) {
      if (seen.contains(entry.renter.renterId)) {
        await _showErrorDialog(
          'Арендатор «${entry.renter.name}» добавлен более одного раза',
        );
        return;
      }
      seen.add(entry.renter.renterId);
    }

    final storage = ref.read(renterAssignmentsStorageProvider);
    final postingDate = normalizeRenterAssignmentDate(_selectedDate);
    final boundMonth = _boundMonth;
    final isMovingMonth =
        boundMonth != null && !_isSameMonth(boundMonth, postingDate);

    if (isMovingMonth) {
      final existingInTarget =
          await storage.getByBaseAndMonth(baseId, postingDate);
      if (!mounted) return;

      if (existingInTarget.isNotEmpty) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmDialog(
            title: 'Заменить начисления?',
            message:
                'За ${_formatMonthLabel(postingDate)} уже есть начисления. '
                'Они будут заменены, а начисления за '
                '${_formatMonthLabel(boundMonth)} будут удалены.',
            confirmLabel: 'Заменить',
          ),
        );
        if (confirmed != true || !mounted) return;
      }
    }

    try {
      final timestamp = DateTime.now().microsecondsSinceEpoch;
      final assignments = <RenterAssignment>[];

      for (var i = 0; i < _accrualEntries.length; i++) {
        final entry = _accrualEntries[i];
        final amount = AmountInputFormatter.parseAmount(
          entry.amountController.text,
        );
        if (amount == null || amount <= 0) {
          await _showErrorDialog('Укажите сумму для «${entry.renter.name}»');
          return;
        }

        assignments.add(
          RenterAssignment(
            id: '${timestamp}_$i',
            createdAt: DateTime.now(),
            baseId: baseId,
            renterId: entry.renter.renterId,
            // Общее начисление на арендатора, без привязки к конкретному р/с.
            accountNumber: '',
            date: postingDate,
            sum: amount,
          ),
        );
      }

      if (isMovingMonth) {
        await storage.deleteByBaseAndMonth(baseId, boundMonth);
      }

      await storage.saveAll(
        baseId: baseId,
        month: postingDate,
        assignments: assignments,
      );

      if (!mounted) return;
      setState(() {
        _boundMonth = normalizeRenterAssignmentMonth(postingDate);
        _selectedDate = postingDate;
      });
      ref.invalidate(documentsListProvider);
      ref.invalidate(renterDebtsProvider);
      ref.invalidate(githubSyncDirtyProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isMovingMonth
                ? 'Начисления перенесены на ${_formatMonthLabel(postingDate)}'
                : 'Начисления сохранены',
          ),
        ),
      );
    } on EmptyRenterAssignmentsError {
      if (!mounted) return;
      await _showErrorDialog('Добавьте хотя бы одно начисление');
    } on InvalidRenterAssignmentAmountError {
      if (!mounted) return;
      await _showErrorDialog('Сумма должна быть больше нуля');
    } on Object catch (error) {
      if (!mounted) return;
      await _showErrorDialog('Не удалось сохранить начисления\n$error');
    }
  }

  List<_RenterRow> _toRenterRows(List<Renter> renters) {
    return [
      for (final renter in renters)
        _RenterRow(
          renterId: renter.id,
          name: renter.name,
          accountNumbers: renter.accountNumbers,
        ),
    ];
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

  Future<void> _showErrorDialog(String message) {
    return AppSnackBar.showErrorDialog(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final basesAsync = ref.watch(basesListProvider);
    final rentersAsync = ref.watch(
      rentersListProvider(RentersListFilter(baseId: _selectedBase?.id)),
    );

    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: _isEditing
            ? 'Редактирование начисления'
            : 'Начисление по аренде',
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
                    hint: 'Дата начисления',
                    selectedDate: _selectedDate,
                    onChanged: _onDateChanged,
                  ),
                ),
                const Gap(12),
                SizedBox(
                  height: filterFieldHeight,
                  child: MaterialButton(
                    onPressed: _onCopyFromPreviousMonth,
                    elevation: 0,
                    color: context.appColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(color: AppColors.purple),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: const Text(
                      'Скопировать с пред. месяца',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                              child: _RentAccrualsTable(
                                entries: _accrualEntries,
                                onRemoveEntry: _removeAccrualEntry,
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
                          data: (renters) => _RentersTable(
                            renters: _toRenterRows(renters),
                            onRenterDoubleTap: _addRenterToAccruals,
                            onAddRenter: _onAddRenter,
                          ),
                          loading: () => const _RentersTablePlaceholder(),
                          error: (_, _) => const _RentersTablePlaceholder(),
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

class _RentersTable extends StatefulWidget {
  const _RentersTable({
    required this.renters,
    required this.onRenterDoubleTap,
    required this.onAddRenter,
  });

  final List<_RenterRow> renters;
  final void Function(_RenterRow renter) onRenterDoubleTap;
  final VoidCallback onAddRenter;

  @override
  State<_RentersTable> createState() => _RentersTableState();
}

class _RentersTableState extends State<_RentersTable> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_RenterRow> get _filteredRenters {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return widget.renters;

    return widget.renters.where((renter) {
      return renter.name.toLowerCase().contains(query) ||
          renter.accountNumbers.any((account) => account.contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRenters = _filteredRenters;

    return SimpleTable(
      columns: const ['Арендатор', 'номер р/с'],
      columnFlex: const [2, 3],
      rows: filteredRenters
          .map(
            (renter) => [
              renter.name,
              renter.accountNumbersLabel,
            ],
          )
          .toList(),
      emptyMessage: _searchQuery.trim().isEmpty
          ? 'Нет данных'
          : 'Ничего не найдено',
      belowHeader: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    borderSide: BorderSide(color: context.appColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: context.appColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            const Gap(8),
            IconButton(
              tooltip: 'Добавить арендатора',
              onPressed: widget.onAddRenter,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              style: IconButton.styleFrom(
                backgroundColor: context.appColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: context.appColors.border),
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
      onRowDoubleTap: (index) {
        widget.onRenterDoubleTap(filteredRenters[index]);
      },
    );
  }
}

class _RentersTablePlaceholder extends StatelessWidget {
  const _RentersTablePlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _RentAccrualsTable extends StatelessWidget {
  const _RentAccrualsTable({
    required this.entries,
    required this.onRemoveEntry,
  });

  final List<_AccrualEntry> entries;
  final void Function(int index) onRemoveEntry;

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
                    flex: 3,
                    child: Text(
                      'Арендатор',
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
                ],
              ),
            ),
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Text(
                        'Дважды нажмите на арендатора справа',
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
                                flex: 3,
                                child: Text(
                                  entry.renter.name,
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
                              IconButton(
                                tooltip: 'Удалить',
                                onPressed: () => onRemoveEntry(index),
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
