import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

sealed class EditRenterDialogOutcome {
  const EditRenterDialogOutcome();
}

final class EditRenterDialogSaved extends EditRenterDialogOutcome {
  const EditRenterDialogSaved({
    required this.name,
    required this.accountNumbers,
  });

  final String name;
  final List<String> accountNumbers;
}

final class EditRenterDialogArchived extends EditRenterDialogOutcome {
  const EditRenterDialogArchived();
}

final class EditRenterDialogRestored extends EditRenterDialogOutcome {
  const EditRenterDialogRestored();
}

class EditRenterDialog extends StatefulWidget {
  const EditRenterDialog({required this.renter, super.key});

  final Renter renter;

  @override
  State<EditRenterDialog> createState() => _EditRenterDialogState();
}

class _EditRenterDialogState extends State<EditRenterDialog> {
  late final TextEditingController _nameController;
  late final List<TextEditingController> _accountControllers;

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
    _nameController = TextEditingController(text: widget.renter.name);
    _accountControllers = widget.renter.accountNumbers.isEmpty
        ? [TextEditingController()]
        : widget.renter.accountNumbers
            .map((accountNumber) => TextEditingController(text: accountNumber))
            .toList();
  }

  List<String> get _accountNumbers {
    return _accountControllers
        .map((controller) => controller.text.trim())
        .where((accountNumber) => accountNumber.isNotEmpty)
        .toList();
  }

  bool get _hasDuplicateAccounts {
    final accounts = _accountNumbers;
    return accounts.length != accounts.toSet().length;
  }

  bool get _hasInvalidAccountNumbers {
    return _accountControllers.any((controller) {
      final value = controller.text.trim();
      return value.isNotEmpty && !isValidAccountNumber(value);
    });
  }

  bool get _canSave {
    if (_nameController.text.trim().isEmpty) return false;
    if (_accountControllers.any((controller) => controller.text.trim().isEmpty)) {
      return false;
    }
    if (_hasInvalidAccountNumbers) return false;
    return !_hasDuplicateAccounts;
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _accountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAccountField() {
    setState(() {
      _accountControllers.add(TextEditingController());
    });
  }

  void _removeAccountField(int index) {
    if (_accountControllers.length <= 1) return;

    _accountControllers[index].dispose();
    setState(() {
      _accountControllers.removeAt(index);
    });
  }

  void _onSave() {
    if (!_canSave) return;

    Navigator.of(context).pop(
      EditRenterDialogSaved(
        name: _nameController.text.trim(),
        accountNumbers: _accountNumbers,
      ),
    );
  }

  Future<void> _onArchive() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return const ConfirmDialog(
          title: 'Архивировать арендатора?',
          message:
              'Арендатор будет скрыт из списка, '
              'но останется в базе данных.',
          confirmLabel: 'Архивировать',
        );
      },
    );
    if (confirmed != true || !mounted) return;

    Navigator.of(context).pop(const EditRenterDialogArchived());
  }

  Future<void> _onRestore() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return const ConfirmDialog(
          title: 'Восстановить арендатора?',
          message: 'Арендатор снова появится в списке активных.',
          confirmLabel: 'Восстановить',
        );
      },
    );
    if (confirmed != true || !mounted) return;

    Navigator.of(context).pop(const EditRenterDialogRestored());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Редактировать арендатора',
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
                      const Text(
                        'Номера р/с',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(8),
                      for (var index = 0; index < _accountControllers.length; index++) ...[
                        if (index > 0) const Gap(8),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: filterFieldHeight,
                                child: TextField(
                                  controller: _accountControllers[index],
                                  style: filterFieldTextStyle,
                                  maxLength: accountNumberLength,
                                  decoration: _fieldDecoration(context).copyWith(
                                    hintText: 'Введите номер счёта (20 символов)',
                                    hintStyle: filterFieldHintTextStyleOf(context),
                                    counterText: '',
                                  ),
                                  onChanged: (_) => setState(() {}),
                                  onSubmitted: _canSave ? (_) => _onSave() : null,
                                ),
                              ),
                            ),
                            if (_accountControllers.length > 1) ...[
                              const Gap(4),
                              IconButton(
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
                      if (_hasInvalidAccountNumbers) ...[
                        const Gap(8),
                        Text(
                          'Номер р/с должен содержать $accountNumberLength символов',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
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
                  if (widget.renter.isArchived)
                    TextButton.icon(
                      onPressed: _onRestore,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.purple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(LucideIcons.archiveRestore, size: 16),
                      label: const Text(
                        'Восстановить',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    TextButton.icon(
                      onPressed: _onArchive,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(LucideIcons.archive, size: 16),
                      label: const Text(
                        'В архив',
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
