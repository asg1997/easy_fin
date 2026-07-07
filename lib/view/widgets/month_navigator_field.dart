import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MonthNavigatorField extends StatelessWidget {
  const MonthNavigatorField({
    required this.selectedMonth,
    required this.canGoForward,
    required this.onPrevious,
    required this.onNext,
    this.expand = false,
    super.key,
  });

  final DateTime selectedMonth;
  final bool canGoForward;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool expand;

  static final _monthFormat = DateFormat('LLLL yyyy', 'ru');

  String get _monthLabel {
    final formatted = _monthFormat.format(selectedMonth);
    if (formatted.isEmpty) return formatted;
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: filterFieldHeight,
      width: expand ? double.infinity : 250,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            _NavigationButton(
              icon: LucideIcons.chevronLeft,
              onPressed: onPrevious,
            ),
            Expanded(
              child: Text(
                _monthLabel,
                textAlign: TextAlign.center,
                style: filterFieldTextStyle.copyWith(
                  color: colors.primaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _NavigationButton(
              icon: LucideIcons.chevronRight,
              onPressed: canGoForward ? onNext : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      width: 40,
      height: filterFieldHeight,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 18,
          color: onPressed == null
              ? colors.border
              : colors.secondaryText,
        ),
      ),
    );
  }
}
