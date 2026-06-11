import 'package:easy_fin/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

enum ImportBalanceGapDialogResult { cancel, import }

class ImportBalanceGapDialog extends StatelessWidget {
  const ImportBalanceGapDialog({
    required this.previousEndDate,
    required this.previousFinalBalance,
    required this.newInitialBalance,
    required this.newStartDate,
    required this.newEndDate,
    super.key,
  });

  final DateTime previousEndDate;
  final double previousFinalBalance;
  final double newInitialBalance;
  final DateTime newStartDate;
  final DateTime newEndDate;

  static final _dateFormat = DateFormat('dd.MM.yyyy', 'ru');
  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
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
                'Разрыв в остатках',
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
              Text(
                'Входящий остаток новой выписки не совпадает с исходящим '
                'остатком предыдущей. Возможно, пропущена одна или несколько '
                'выписок.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),
              const Gap(20),
              _InfoRow(
                label: 'Предыдущая выписка до',
                value: _dateFormat.format(previousEndDate),
              ),
              const Gap(8),
              _InfoRow(
                label: 'Исходящий остаток',
                value: '${_amountFormat.format(previousFinalBalance)} ₽',
              ),
              const Gap(16),
              _InfoRow(
                label: 'Новая выписка',
                value:
                    '${_dateFormat.format(newStartDate)} — '
                    '${_dateFormat.format(newEndDate)}',
              ),
              const Gap(8),
              _InfoRow(
                label: 'Входящий остаток',
                value: '${_amountFormat.format(newInitialBalance)} ₽',
                highlight: true,
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(
                      ImportBalanceGapDialogResult.cancel,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
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
                      ImportBalanceGapDialogResult.import,
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
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: highlight ? Colors.orange.shade800 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
