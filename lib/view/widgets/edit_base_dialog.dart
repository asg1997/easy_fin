import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/base_account.dart';
import 'package:easy_fin/models/bank_name.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

sealed class EditBaseDialogOutcome {
  const EditBaseDialogOutcome();
}

final class EditBaseDialogSaved extends EditBaseDialogOutcome {
  const EditBaseDialogSaved({
    required this.name,
    required this.accounts,
  });

  final String name;
  final List<BaseAccount> accounts;
}

final class EditBaseDialogDeleted extends EditBaseDialogOutcome {
  const EditBaseDialogDeleted();
}

class _AccountField {
  _AccountField({
    required this.accountController,
    required this.bankName,
  });

  final TextEditingController accountController;
  String bankName;
}

class EditBaseDialog extends StatefulWidget {
  const EditBaseDialog({required this.base, super.key});

  final Base base;

  @override
  State<EditBaseDialog> createState() => _EditBaseDialogState();
}

class _EditBaseDialogState extends State<EditBaseDialog> {
  late final TextEditingController _nameController;
  late final List<_AccountField> _accountFields;

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.base.name);
    _accountFields = widget.base.accounts.isEmpty
        ? [
            _AccountField(
              accountController: TextEditingController(),
              bankName: BankName.sber,
            ),
          ]
        : widget.base.accounts
            .map(
              (account) => _AccountField(
                accountController: TextEditingController(
                  text: account.accountNumber,
                ),
                bankName: account.bankName.isEmpty
                    ? BankName.sber
                    : account.bankName,
              ),
            )
            .toList();
  }

  List<BaseAccount> get _accounts {
    return _accountFields
        .map(
          (field) => BaseAccount(
            accountNumber: field.accountController.text.trim(),
            bankName: field.bankName,
          ),
        )
        .where((account) => account.accountNumber.isNotEmpty)
        .toList();
  }

  bool get _hasDuplicateAccounts {
    final accounts = _accounts;
    return accounts.length !=
        accounts.map((account) => account.accountNumber).toSet().length;
  }

  bool get _canSave {
    if (_nameController.text.trim().isEmpty) return false;
    if (_accountFields.any(
      (field) => field.accountController.text.trim().isEmpty,
    )) {
      return false;
    }
    if (_accountFields.any((field) => field.bankName.isEmpty)) {
      return false;
    }
    return !_hasDuplicateAccounts;
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final field in _accountFields) {
      field.accountController.dispose();
    }
    super.dispose();
  }

  void _addAccountField() {
    setState(() {
      _accountFields.add(
        _AccountField(
          accountController: TextEditingController(),
          bankName: BankName.sber,
        ),
      );
    });
  }

  void _removeAccountField(int index) {
    if (_accountFields.length <= 1) return;

    _accountFields[index].accountController.dispose();
    setState(() {
      _accountFields.removeAt(index);
    });
  }

  void _onSave() {
    if (!_canSave) return;

    Navigator.of(context).pop(
      EditBaseDialogSaved(
        name: _nameController.text.trim(),
        accounts: _accounts,
      ),
    );
  }

  Future<void> _onDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Удалить базу?',
        message:
            'База «${widget.base.name}» и все связанные данные '
            '(выписки, арендаторы, счета) будут удалены безвозвратно.',
        confirmLabel: 'Удалить',
      ),
    );
    if (confirmed != true || !mounted) return;

    Navigator.of(context).pop(const EditBaseDialogDeleted());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Редактировать базу',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(12),
              Divider(
                color: context.appColors.border,
                thickness: 0.5,
                height: 1,
              ),
              const Gap(20),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Название',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(8),
                      SizedBox(
                        height: filterFieldHeight,
                        child: TextField(
                          controller: _nameController,
                          autofocus: true,
                          style: filterFieldTextStyle,
                          decoration: _fieldDecoration(context).copyWith(
                            hintText: 'Введите название',
                            hintStyle: filterFieldHintTextStyleOf(context),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const Gap(16),
                      Text(
                        'Счета',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(8),
                      for (var index = 0; index < _accountFields.length; index++) ...[
                        if (index > 0) const Gap(12),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0)
                                    Text(
                                      'Банк',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: context.appColors.secondaryText,
                                      ),
                                    ),
                                  if (index == 0) const Gap(6),
                                  SizedBox(
                                    height: filterFieldHeight,
                                    child: DropdownWidget<String>(
                                      expand: true,
                                      items: BankName.values,
                                      selectedItem: _accountFields[index].bankName,
                                      hint: 'Банк',
                                      labelBuilder: (item) => item,
                                      onChanged: (bankName) {
                                        setState(() {
                                          _accountFields[index].bankName = bankName;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0)
                                    Text(
                                      'Номер р/с',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: context.appColors.secondaryText,
                                      ),
                                    ),
                                  if (index == 0) const Gap(6),
                                  SizedBox(
                                    height: filterFieldHeight,
                                    child: TextField(
                                      controller:
                                          _accountFields[index].accountController,
                                      style: filterFieldTextStyle,
                                      decoration: _fieldDecoration(context).copyWith(
                                        hintText: 'Введите номер счёта',
                                        hintStyle: filterFieldHintTextStyleOf(context),
                                      ),
                                      onChanged: (_) => setState(() {}),
                                      onSubmitted:
                                          _canSave ? (_) => _onSave() : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_accountFields.length > 1) ...[
                              const Gap(4),
                              Padding(
                                padding: EdgeInsets.only(top: index == 0 ? 22 : 0),
                                child: IconButton(
                                  tooltip: 'Удалить счёт',
                                  onPressed: () => _removeAccountField(index),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  icon: Icon(
                                    LucideIcons.x,
                                    size: 16,
                                    color: context.appColors.secondaryText,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      const Gap(8),
                      TextButton.icon(
                        onPressed: _addAccountField,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.purple,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                        icon: const Icon(LucideIcons.plus, size: 16),
                        label: const Text(
                          'Добавить счёт',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (_hasDuplicateAccounts) ...[
                        const Gap(8),
                        Text(
                          'Счета не должны повторяться',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Gap(24),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _onDelete,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(LucideIcons.trash2, size: 16),
                    label: const Text(
                      'Удалить',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
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
                    onPressed: _canSave ? _onSave : null,
                    height: 40,
                    minWidth: 110,
                    color: AppColors.primary,
                    disabledColor: AppColors.primary.withValues(alpha: 0.35),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
            ],
          ),
        ),
      ),
    );
  }
}
