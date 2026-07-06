import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:easy_fin/view/models/renter_debt_monthly_report_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RenterDebtsBarChart extends StatelessWidget {
  const RenterDebtsBarChart({
    required this.items,
    super.key,
  });

  final List<RenterDebtMonthlyReportItem> items;

  static const chartHeight = 300.0;

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

  static final _amountFormat = NumberFormat('#,##0', 'ru');

  bool get _shouldShowEmpty {
    if (items.isEmpty) return true;
    return items.every((item) => !item.isFutureMonth && item.debt == 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldShowEmpty) {
      return SizedBox(
        width: double.infinity,
        height: chartHeight,
        child: const Center(
          child: Text(
            'Нет данных для диаграммы',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final maxDebt = items
        .where((item) => !item.isFutureMonth)
        .fold<double>(0, (max, item) => math.max(max, item.debt));

    return SizedBox(
      width: double.infinity,
      height: chartHeight,
      child: CustomPaint(
        painter: _BarChartPainter(
          items: items,
          axisMax: _resolveAxisMax(maxDebt),
          amountFormat: _amountFormat,
        ),
      ),
    );
  }

  static double _resolveAxisMax(double maxValue) {
    if (maxValue <= 0) return 10000;

    final step = _resolveStep(maxValue);
    return (maxValue / step).ceil() * step;
  }

  static double _resolveStep(double maxValue) {
    if (maxValue <= 1000) return 200;
    if (maxValue <= 5000) return 1000;
    if (maxValue <= 20000) return 5000;
    if (maxValue <= 50000) return 10000;
    if (maxValue <= 200000) return 50000;
    if (maxValue <= 500000) return 100000;

    final magnitude = math.pow(10, (math.log(maxValue) / math.ln10).floor());
    return magnitude.toDouble();
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.items,
    required this.axisMax,
    required this.amountFormat,
  });

  final List<RenterDebtMonthlyReportItem> items;
  final double axisMax;
  final NumberFormat amountFormat;

  static const _barColor = Color(0xFF93C5FD);
  static const _futureBarColor = Color(0xFFE5E7EB);
  static const _gridColor = Color(0xFFE5E7EB);
  static const _axisColor = Color(0xFFD1D5DB);
  static const _axisLabelColor = Color(0xFF9CA3AF);
  static const _futureLabelColor = Color(0xFFD1D5DB);

  static const _leftPadding = 44.0;
  static const _bottomPadding = 40.0;
  static const _topPadding = 28.0;
  static const _rightPadding = 16.0;

  static const _gridLines = 4;
  static const _futureBarMinHeight = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - _leftPadding - _rightPadding;
    final chartHeight = size.height - _bottomPadding - _topPadding;
    final chartOrigin = Offset(_leftPadding, _topPadding);

    _drawGrid(canvas, chartOrigin, chartWidth, chartHeight);
    _drawXAxis(canvas, chartOrigin, chartWidth, chartHeight);
    _drawBars(canvas, chartOrigin, chartWidth, chartHeight);
    _drawValueLabels(canvas, chartOrigin, chartWidth, chartHeight);
    _drawMonthLabels(canvas, chartOrigin, chartWidth, chartHeight);
  }

  void _drawGrid(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    final gridPaint = Paint()
      ..color = _gridColor
      ..strokeWidth = 1;

    final labelStyle = TextStyle(
      fontSize: 11,
      color: _axisLabelColor,
    );

    for (var index = 0; index <= _gridLines; index++) {
      final fraction = index / _gridLines;
      final y = origin.dy + height * (1 - fraction);

      canvas.drawLine(
        Offset(origin.dx, y),
        Offset(origin.dx + width, y),
        gridPaint,
      );

      final value = axisMax * fraction;
      final label = TextPainter(
        text: TextSpan(
          text: _formatAxisLabel(value),
          style: labelStyle,
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(origin.dx - label.width - 10, y - label.height / 2),
      );
    }
  }

  void _drawXAxis(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    final axisPaint = Paint()
      ..color = _axisColor
      ..strokeWidth = 1;

    final baselineY = origin.dy + height;
    canvas.drawLine(
      Offset(origin.dx, baselineY),
      Offset(origin.dx + width, baselineY),
      axisPaint,
    );

    final slotWidth = width / items.length;
    for (var index = 0; index <= items.length; index++) {
      final x = origin.dx + slotWidth * index;
      canvas.drawLine(
        Offset(x, baselineY),
        Offset(x, baselineY + 4),
        axisPaint,
      );
    }
  }

  void _drawBars(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    if (items.isEmpty || axisMax <= 0) return;

    final slotWidth = width / items.length;
    final barWidth = slotWidth * 0.38;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final isFuture = item.isFutureMonth;
      final barPaint = Paint()
        ..color = isFuture ? _futureBarColor : _barColor;

      var barHeight = isFuture
          ? _futureBarMinHeight
          : (item.debt / axisMax) * height;

      if (!isFuture && item.debt > 0 && barHeight < _futureBarMinHeight) {
        barHeight = _futureBarMinHeight;
      }

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      final barLeft = slotCenterX - barWidth / 2;
      final barTop = origin.dy + height - barHeight;

      canvas.drawRect(
        Rect.fromLTWH(barLeft, barTop, barWidth, barHeight),
        barPaint,
      );
    }
  }

  void _drawValueLabels(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    final slotWidth = width / items.length;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      if (item.isFutureMonth || item.debt == 0) continue;

      final barHeight = (item.debt / axisMax) * height;
      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      final labelY = origin.dy + height - barHeight - 20;

      final label = TextPainter(
        text: TextSpan(
          text: amountFormat.format(item.debt),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F1F1F),
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: slotWidth);

      label.paint(
        canvas,
        Offset(slotCenterX - label.width / 2, labelY),
      );
    }
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
      final monthLabel = _formatMonth(item.month);
      final labelStyle = TextStyle(
        fontSize: 11,
        color: item.isFutureMonth ? _futureLabelColor : _axisLabelColor,
      );

      final label = TextPainter(
        text: TextSpan(text: monthLabel, style: labelStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: slotWidth);

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      label.paint(
        canvas,
        Offset(slotCenterX - label.width / 2, origin.dy + height + 12),
      );
    }
  }

  String _formatMonth(DateTime month) {
    return RenterDebtsBarChart._monthNames[month.month - 1];
  }

  String _formatAxisLabel(double value) {
    if (value >= 1000) {
      final thousands = value / 1000;
      if (thousands == thousands.roundToDouble()) {
        return '${thousands.toInt()}k';
      }
      return '${thousands.toStringAsFixed(1)}k';
    }

    return amountFormat.format(value);
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.axisMax != axisMax;
  }
}
