import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

enum ImportOutOfOrderDialogResult { cancel, import }

class ImportOutOfOrderDialog extends StatelessWidget {
  const ImportOutOfOrderDialog({
    required this.newStartDate,
    required this.newEndDate,
    required this.newFinalBalance,
    required this.nextStartDate,
    required this.nextEndDate,
    required this.nextInitialBalance,
    required this.hasBalanceGap,
    super.key,
  });

  final DateTime newStartDate;
  final DateTime newEndDate;
  final double newFinalBalance;
  final DateTime nextStartDate;
  final DateTime nextEndDate;
  final double nextInitialBalance;
  final bool hasBalanceGap;

  static final _dateFormat = DateFormat('dd.MM.yyyy', 'ru');
  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  String _formatPeriod(DateTime start, DateTime end) =>
      '${_dateFormat.format(start)} — ${_dateFormat.format(end)}';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Импорт не по хронологии',
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
                hasBalanceGap
                    ? 'Загружаемая выписка относится к более раннему периоду, '
                        'чем уже сохранённая. Исходящий остаток новой выписки '
                        'не совпадает с входящим остатком следующей.'
                    : 'Загружаемая выписка относится к более раннему периоду, '
                        'чем уже сохранённая. Стык остатков между выписками '
                        'не проверялся автоматически.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: context.appColors.secondaryText,
                ),
              ),
              const Gap(20),
              _InfoRow(
                label: 'Новая выписка',
                value: _formatPeriod(newStartDate, newEndDate),
              ),
              if (hasBalanceGap) ...[
                const Gap(8),
                _InfoRow(
                  label: 'Исходящий остаток',
                  value: '${_amountFormat.format(newFinalBalance)} ₽',
                ),
              ],
              const Gap(16),
              _InfoRow(
                label: 'Следующая выписка',
                value: _formatPeriod(nextStartDate, nextEndDate),
              ),
              if (hasBalanceGap) ...[
                const Gap(8),
                _InfoRow(
                  label: 'Входящий остаток',
                  value: '${_amountFormat.format(nextInitialBalance)} ₽',
                  highlight: true,
                ),
              ],
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(
                      ImportOutOfOrderDialogResult.cancel,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: context.appColors.secondaryText,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Отменить',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Gap(8),
                  MaterialButton(
                    onPressed: () => Navigator.of(context).pop(
                      ImportOutOfOrderDialogResult.import,
                    ),
                    height: 40,
                    minWidth: 110,
                    color: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Импортировать',
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.secondaryText,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: highlight ? Colors.orange.shade800 : context.appColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }
}
