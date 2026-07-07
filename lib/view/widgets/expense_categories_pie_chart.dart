import 'dart:math' as math;

import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/expense_category_report_item.dart';
import 'package:easy_fin/view/widgets/expense_chart_common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCategoriesPieChart extends StatelessWidget {
  const ExpenseCategoriesPieChart({
    required this.items,
    super.key,
  });

  final List<ExpenseCategoryReportItem> items;

  static const chartSize = 180.0;
  static const legendMaxWidth = 220.0;

  static final _percentFormat = NumberFormat('#,##0.0', 'ru');

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const ExpenseChartEmpty();
    }

    final holeColor = context.appColors.surface;

    return SizedBox(
      width: double.infinity,
      height: chartSize,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: chartSize,
            height: chartSize,
            child: CustomPaint(
              painter: _PieChartPainter(
                items: items,
                colors: _resolveColors(items.length),
                holeColor: holeColor,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SizedBox(
              height: chartSize,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var index = 0; index < items.length; index++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: _LegendItem(
                          color: _resolveColors(items.length)[index],
                          label: items[index].categoryName,
                          percentage:
                              _percentFormat.format(items[index].percentage),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _resolveColors(int count) {
    return List.generate(count, ExpenseChartColors.at);
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.percentage,
  });

  final Color color;
  final String label;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: colors.primaryText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 12,
            color: colors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    required this.items,
    required this.colors,
    required this.holeColor,
  });

  final List<ExpenseCategoryReportItem> items;
  final List<Color> colors;
  final Color holeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    var startAngle = -math.pi / 2;

    for (var index = 0; index < items.length; index++) {
      final sweepAngle = items[index].percentage / 100 * 2 * math.pi;
      final paint = Paint()
        ..color = colors[index]
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    final holePaint = Paint()..color = holeColor;
    canvas.drawCircle(center, radius * 0.55, holePaint);
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.items != items ||
        oldDelegate.colors != colors ||
        oldDelegate.holeColor != holeColor;
  }
}
