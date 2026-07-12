import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

sealed class ImportBaseDialogResult {
  const ImportBaseDialogResult();
}

final class ImportBaseDialogCreateNew extends ImportBaseDialogResult {
  const ImportBaseDialogCreateNew(this.baseName);

  final String baseName;
}

class ImportBaseCreationDialog extends StatefulWidget {
  const ImportBaseCreationDialog({
    required this.accountNumber,
    super.key,
  });

  final AccountNumber accountNumber;

  @override
  State<ImportBaseCreationDialog> createState() =>
      _ImportBaseCreationDialogState();
}

class _ImportBaseCreationDialogState extends State<ImportBaseCreationDialog> {
  final _nameController = TextEditingController();

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
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: colors.accent),
      ),
    );
  }

  bool get _canContinue => _nameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_canContinue) return;

    Navigator.of(context).pop(
      ImportBaseDialogCreateNew(_nameController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Счёт не найден',
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
              Text(
                'Для этого расчётного счёта нужно создать отдельную базу. '
                'Выписка будет сохранена только на указанный счёт.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: context.appColors.secondaryText,
                ),
              ),
              const Gap(20),
              const Text(
                'Номер счёта',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(8),
              Container(
                height: filterFieldHeight,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: filterFieldHorizontalPadding,
                ),
                decoration: BoxDecoration(
                  color: context.appColors.navActiveBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.appColors.border),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.accountNumber,
                  style: filterFieldTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(16),
              const Text(
                'Название базы',
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
                  onSubmitted: _canContinue ? (_) => _onContinue() : null,
                ),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                    onPressed: _canContinue ? _onContinue : null,
                    height: 40,
                    minWidth: 110,
                    color: context.appColors.accent,
                    disabledColor:
                        context.appColors.accent.withValues(alpha: 0.35),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Продолжить',
                      style: TextStyle(
                        color: context.appColors.onAccent,
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
