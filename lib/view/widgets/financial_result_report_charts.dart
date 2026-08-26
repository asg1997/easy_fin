import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/financial_result_base_report_item.dart';
import 'package:easy_fin/view/models/financial_result_monthly_report_item.dart';
import 'package:easy_fin/view/widgets/expense_chart_common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _financialResultMonthNames = [
  'Янв',
  'Фев',
  'Мар',
  'Апр',
  'Май',
  'Июн',
  'Июл',
  'Авг',
  'Сен',
  'Окт',
  'Ноя',
  'Дек',
];

class FinancialResultMonthlyLineChart extends StatelessWidget {
  const FinancialResultMonthlyLineChart({
    required this.items,
    super.key,
  });

  final List<FinancialResultMonthlyReportItem> items;

  static const chartHeight = 320.0;

  bool get _isEmpty {
    if (items.isEmpty) return true;
    return items.every(
      (item) =>
          !item.isFutureMonth &&
          item.revenue == 0 &&
          item.expenses == 0 &&
          item.profit == 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return const ExpenseChartEmpty(height: chartHeight);
    }

    final colors = context.appColors;
    final pastItems = items.where((item) => !item.isFutureMonth);
    var maxValue = 0.0;
    var minValue = 0.0;
    for (final item in pastItems) {
      maxValue = math.max(
        maxValue,
        math.max(item.revenue, math.max(item.expenses, item.profit)),
      );
      minValue = math.min(
        minValue,
        math.min(item.revenue, math.min(item.expenses, item.profit)),
      );
    }

    final axisMax = ExpenseChartAxis.resolveMax(maxValue);
    final axisMin = minValue >= 0
        ? 0.0
        : -ExpenseChartAxis.resolveMax(minValue.abs());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: chartHeight,
          child: CustomPaint(
            painter: _FinancialResultLinePainter(
              items: items,
              axisMax: axisMax,
              axisMin: axisMin,
              monthNames: _financialResultMonthNames,
              primaryTextColor: colors.primaryText,
              secondaryTextColor: colors.secondaryText,
              borderColor: colors.border,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _LineLegend(),
      ],
    );
  }
}

class FinancialResultBasesPieCharts extends StatelessWidget {
  const FinancialResultBasesPieCharts({
    required this.items,
    this.subtitle,
    super.key,
  });

  final List<FinancialResultBaseReportItem> items;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FinancialResultBasesPieChart(
          title: 'Структура выручки по базам',
          subtitle: subtitle,
          items: items,
          valueOf: (item) => item.revenue,
        ),
        const SizedBox(height: 32),
        FinancialResultBasesPieChart(
          title: 'Структура расходов по базам',
          subtitle: subtitle,
          items: items,
          valueOf: (item) => item.expenses,
        ),
        const SizedBox(height: 32),
        FinancialResultBasesPieChart(
          title: 'Структура прибыли по базам',
          subtitle: subtitle,
          items: items,
          valueOf: (item) => item.profit,
        ),
      ],
    );
  }
}

class FinancialResultBasesPieChart extends StatelessWidget {
  const FinancialResultBasesPieChart({
    required this.title,
    required this.items,
    required this.valueOf,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<FinancialResultBaseReportItem> items;
  final double Function(FinancialResultBaseReportItem item) valueOf;

  static const chartSize = 180.0;

  static final _percentFormat = NumberFormat('#,##0.0', 'ru');

  List<_PieSlice> get _slices {
    final positive = [
      for (final item in items)
        if (valueOf(item) > 0)
          (label: item.baseName, amount: valueOf(item)),
    ];

    final total =
        positive.fold<double>(0, (sum, entry) => sum + entry.amount);
    if (total <= 0) return const [];

    return [
      for (final entry in positive)
        _PieSlice(
          label: entry.label,
          amount: entry.amount,
          percentage: entry.amount / total * 100,
        ),
    ]..sort((a, b) => b.amount.compareTo(a.amount));
  }

  @override
  Widget build(BuildContext context) {
    final slices = _slices;

    return ExpenseChartSection(
      title: title,
      subtitle: subtitle,
      child: slices.isEmpty
          ? const ExpenseChartEmpty(height: chartSize)
          : SizedBox(
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
                        slices: slices,
                        colors: List.generate(
                          slices.length,
                          ExpenseChartColors.at,
                        ),
                        holeColor: context.appColors.surface,
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
                            for (var index = 0; index < slices.length; index++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: _PieLegendItem(
                                  color: ExpenseChartColors.at(index),
                                  label: slices[index].label,
                                  percentage: _percentFormat
                                      .format(slices[index].percentage),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _PieSlice {
  const _PieSlice({
    required this.label,
    required this.amount,
    required this.percentage,
  });

  final String label;
  final double amount;
  final double percentage;
}

class _PieLegendItem extends StatelessWidget {
  const _PieLegendItem({
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
    required this.slices,
    required this.colors,
    required this.holeColor,
  });

  final List<_PieSlice> slices;
  final List<Color> colors;
  final Color holeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    var startAngle = -math.pi / 2;

    for (var index = 0; index < slices.length; index++) {
      final sweepAngle = slices[index].percentage / 100 * 2 * math.pi;
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
    return oldDelegate.slices != slices ||
        oldDelegate.colors != colors ||
        oldDelegate.holeColor != holeColor;
  }
}

class _LineLegend extends StatelessWidget {
  const _LineLegend();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _LineLegendItem(color: AppColors.green, label: 'Выручка'),
        _LineLegendItem(color: AppColors.red, label: 'Расходы'),
        _LineLegendItem(color: AppColors.blue, label: 'Прибыль'),
      ],
    );
  }
}

class _LineLegendItem extends StatelessWidget {
  const _LineLegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: context.appColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _FinancialResultLinePainter extends CustomPainter {
  _FinancialResultLinePainter({
    required this.items,
    required this.axisMax,
    required this.axisMin,
    required this.monthNames,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.borderColor,
  });

  final List<FinancialResultMonthlyReportItem> items;
  final double axisMax;
  final double axisMin;
  final List<String> monthNames;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color borderColor;

  static const _leftPadding = 48.0;
  static const _bottomPadding = 40.0;
  static const _topPadding = 16.0;
  static const _rightPadding = 16.0;
  static const _gridLines = 4;
  static const _dotRadius = 3.0;

  double get _axisRange => axisMax - axisMin;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - _leftPadding - _rightPadding;
    final chartHeight = size.height - _bottomPadding - _topPadding;
    const origin = Offset(_leftPadding, _topPadding);

    _drawGrid(canvas, origin, chartWidth, chartHeight);
    if (axisMin < 0 && axisMax > 0) {
      _drawZeroLine(canvas, origin, chartWidth, chartHeight);
    }
    _drawSeries(
      canvas,
      origin,
      chartWidth,
      chartHeight,
      color: AppColors.green,
      values: items.map((item) => item.revenue).toList(),
    );
    _drawSeries(
      canvas,
      origin,
      chartWidth,
      chartHeight,
      color: AppColors.red,
      values: items.map((item) => item.expenses).toList(),
    );
    _drawSeries(
      canvas,
      origin,
      chartWidth,
      chartHeight,
      color: AppColors.blue,
      values: items.map((item) => item.profit).toList(),
    );
    _drawMonthLabels(canvas, origin, chartWidth, chartHeight);
  }

  void _drawGrid(Canvas canvas, Offset origin, double width, double height) {
    final gridPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1;

    for (var index = 0; index <= _gridLines; index++) {
      final fraction = index / _gridLines;
      final y = origin.dy + height * (1 - fraction);
      canvas.drawLine(
        Offset(origin.dx, y),
        Offset(origin.dx + width, y),
        gridPaint,
      );

      final value = axisMin + _axisRange * fraction;
      final label = TextPainter(
        text: TextSpan(
          text: ExpenseChartAxis.formatLabel(value),
          style: TextStyle(fontSize: 11, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(origin.dx - label.width - 8, y - label.height / 2),
      );
    }
  }

  void _drawZeroLine(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    final zeroY = _yForValue(0, origin, height);
    canvas.drawLine(
      Offset(origin.dx, zeroY),
      Offset(origin.dx + width, zeroY),
      Paint()
        ..color = primaryTextColor.withValues(alpha: 0.25)
        ..strokeWidth = 1.2,
    );
  }

  void _drawSeries(
    Canvas canvas,
    Offset origin,
    double width,
    double height, {
    required Color color,
    required List<double> values,
  }) {
    if (items.isEmpty || _axisRange <= 0) return;

    final slotWidth = width / items.length;
    final path = Path();
    final points = <Offset>[];

    for (var index = 0; index < items.length; index++) {
      if (items[index].isFutureMonth) continue;

      final x = origin.dx + slotWidth * index + slotWidth / 2;
      final y = _yForValue(values[index], origin, height);
      final point = Offset(x, y);
      points.add(point);

      if (points.length == 1) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    if (points.isEmpty) return;

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (final point in points) {
      canvas.drawCircle(point, _dotRadius, Paint()..color = color);
    }
  }

  double _yForValue(double value, Offset origin, double height) {
    final clamped = value.clamp(axisMin, axisMax);
    final fraction = (clamped - axisMin) / _axisRange;
    return origin.dy + height * (1 - fraction);
  }

  void _drawMonthLabels(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    final slotWidth = width / items.length;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final label = TextPainter(
        text: TextSpan(
          text: monthNames[item.month.month - 1],
          style: TextStyle(
            fontSize: 11,
            color: item.isFutureMonth ? borderColor : secondaryTextColor,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: slotWidth);

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      label.paint(
        canvas,
        Offset(slotCenterX - label.width / 2, origin.dy + height + 12),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FinancialResultLinePainter oldDelegate) {
    return oldDelegate.items != items ||
        oldDelegate.axisMax != axisMax ||
        oldDelegate.axisMin != axisMin ||
        oldDelegate.primaryTextColor != primaryTextColor ||
        oldDelegate.secondaryTextColor != secondaryTextColor ||
        oldDelegate.borderColor != borderColor;
  }
}
