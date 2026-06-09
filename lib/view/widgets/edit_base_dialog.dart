import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EditBaseDialogResult {
  const EditBaseDialogResult({
    required this.name,
    required this.accountNumbers,
  });

  final String name;
  final List<String> accountNumbers;
}

class EditBaseDialog extends StatefulWidget {
  const EditBaseDialog({required this.base, super.key});

  final Base base;

  @override
  State<EditBaseDialog> createState() => _EditBaseDialogState();
}

class _EditBaseDialogState extends State<EditBaseDialog> {
  late final TextEditingController _nameController;
  late final List<TextEditingController> _accountControllers;

  static const _fieldDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: filterFieldHorizontalPadding,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.primary),
    ),
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.base.name);
    _accountControllers = widget.base.accountNumbers.isEmpty
        ? [TextEditingController()]
        : widget.base.accountNumbers
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

  bool get _canSave {
    if (_nameController.text.trim().isEmpty) return false;
    if (_accountControllers.any((controller) => controller.text.trim().isEmpty)) {
      return false;
    }
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
      EditBaseDialogResult(
        name: _nameController.text.trim(),
        accountNumbers: _accountNumbers,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
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
                'Редактировать базу',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(12),
              Divider(
                color: Colors.grey.withValues(alpha: 0.5),
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
                          decoration: _fieldDecoration.copyWith(
                            hintText: 'Введите название',
                            hintStyle: filterFieldHintTextStyle,
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
                                  decoration: _fieldDecoration.copyWith(
                                    hintText: 'Введите номер счёта',
                                    hintStyle: filterFieldHintTextStyle,
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
                                icon: const Icon(
                                  LucideIcons.x,
                                  size: 16,
                                  color: Colors.grey,
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
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
