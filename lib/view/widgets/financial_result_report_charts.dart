import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/financial_result_monthly_report_item.dart';
import 'package:easy_fin/view/widgets/expense_chart_common.dart';
import 'package:flutter/material.dart';

class FinancialResultMonthlyLineChart extends StatelessWidget {
  const FinancialResultMonthlyLineChart({
    required this.items,
    super.key,
  });

  final List<FinancialResultMonthlyReportItem> items;

  static const chartHeight = 320.0;

  static const _monthNames = [
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
              monthNames: _monthNames,
              primaryTextColor: colors.primaryText,
              secondaryTextColor: colors.secondaryText,
              borderColor: colors.border,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _Legend(),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _LegendItem(color: AppColors.green, label: 'Выручка'),
        _LegendItem(color: AppColors.red, label: 'Расходы'),
        _LegendItem(color: AppColors.blue, label: 'Прибыль'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
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
