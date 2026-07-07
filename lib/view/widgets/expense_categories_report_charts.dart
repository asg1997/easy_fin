import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:easy_fin/view/models/expense_base_report_item.dart';
import 'package:easy_fin/view/models/expense_category_comparison_item.dart';
import 'package:easy_fin/view/models/expense_category_report_item.dart';
import 'package:easy_fin/view/models/expense_monthly_report_item.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/widgets/expense_chart_common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCategoriesVerticalBarChart extends StatelessWidget {
  const ExpenseCategoriesVerticalBarChart({
    required this.items,
    super.key,
  });

  final List<ExpenseCategoryReportItem> items;

  static const chartHeight = 300.0;
  static final _amountFormat = NumberFormat('#,##0', 'ru');

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const ExpenseChartEmpty(height: chartHeight);
    }

    final maxAmount =
        items.fold<double>(0, (max, item) => math.max(max, item.amount));
    final colors = context.appColors;

    return SizedBox(
      width: double.infinity,
      height: chartHeight,
      child: CustomPaint(
        painter: _VerticalBarChartPainter(
          items: items,
          axisMax: ExpenseChartAxis.resolveMax(maxAmount),
          amountFormat: _amountFormat,
          primaryTextColor: colors.primaryText,
          secondaryTextColor: colors.secondaryText,
          borderColor: colors.border,
        ),
      ),
    );
  }
}

class _VerticalBarChartPainter extends CustomPainter {
  _VerticalBarChartPainter({
    required this.items,
    required this.axisMax,
    required this.amountFormat,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.borderColor,
  });

  final List<ExpenseCategoryReportItem> items;
  final double axisMax;
  final NumberFormat amountFormat;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color borderColor;

  static const _gridLines = 4;
  static const _leftPadding = 44.0;
  static const _bottomPadding = 52.0;
  static const _topPadding = 28.0;
  static const _rightPadding = 16.0;
  static const _minBarHeight = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - _leftPadding - _rightPadding;
    final chartHeight = size.height - _bottomPadding - _topPadding;
    final origin = Offset(_leftPadding, _topPadding);

    _drawGrid(canvas, origin, chartWidth, chartHeight);
    _drawBars(canvas, origin, chartWidth, chartHeight);
    _drawValueLabels(canvas, origin, chartWidth, chartHeight);
    _drawCategoryLabels(canvas, origin, chartWidth, chartHeight);
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

      final value = axisMax * fraction;
      final label = TextPainter(
        text: TextSpan(
          text: ExpenseChartAxis.formatLabel(value),
          style: TextStyle(fontSize: 11, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(origin.dx - label.width - 10, y - label.height / 2),
      );
    }

    final baselineY = origin.dy + height;
    canvas.drawLine(
      Offset(origin.dx, baselineY),
      Offset(origin.dx + width, baselineY),
      Paint()..color = borderColor,
    );
  }

  void _drawBars(Canvas canvas, Offset origin, double width, double height) {
    if (items.isEmpty || axisMax <= 0) return;

    final slotWidth = width / items.length;
    final barWidth = math.min(slotWidth * 0.5, 48.0);

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      var barHeight = (item.amount / axisMax) * height;
      if (item.amount > 0 && barHeight < _minBarHeight) {
        barHeight = _minBarHeight;
      }

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      final barLeft = slotCenterX - barWidth / 2;
      final barTop = origin.dy + height - barHeight;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(barLeft, barTop, barWidth, barHeight),
          const Radius.circular(3),
        ),
        Paint()..color = ExpenseChartColors.at(index),
      );
    }
  }

  void _drawValueLabels(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    if (items.isEmpty || axisMax <= 0) return;

    final slotWidth = width / items.length;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      if (item.amount <= 0) continue;

      var barHeight = (item.amount / axisMax) * height;
      if (barHeight < _minBarHeight) barHeight = _minBarHeight;

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      final barTop = origin.dy + height - barHeight;

      paintBarValueLabel(
        canvas,
        text: amountFormat.format(item.amount),
        centerX: slotCenterX,
        barTop: barTop,
        maxWidth: slotWidth - 4,
        chartTop: origin.dy,
        textColor: primaryTextColor,
      );
    }
  }

  void _drawCategoryLabels(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    final slotWidth = width / items.length;

    for (var index = 0; index < items.length; index++) {
      final label = TextPainter(
        text: TextSpan(
          text: truncateChartLabel(items[index].categoryName),
          style: TextStyle(fontSize: 10, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: slotWidth - 4);

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      label.paint(
        canvas,
        Offset(slotCenterX - label.width / 2, origin.dy + height + 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VerticalBarChartPainter oldDelegate) {
    return oldDelegate.items != items ||
        oldDelegate.axisMax != axisMax ||
        oldDelegate.primaryTextColor != primaryTextColor ||
        oldDelegate.secondaryTextColor != secondaryTextColor ||
        oldDelegate.borderColor != borderColor;
  }
}

class ExpenseCategoriesMonthlyChart extends StatelessWidget {
  const ExpenseCategoriesMonthlyChart({
    required this.items,
    super.key,
  });

  final List<ExpenseMonthlyReportItem> items;

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

  bool get _isEmpty {
    if (items.isEmpty) return true;
    return items.every((item) => !item.isFutureMonth && item.amount == 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return const ExpenseChartEmpty(height: chartHeight);
    }

    final maxAmount = items
        .where((item) => !item.isFutureMonth)
        .fold<double>(0, (max, item) => math.max(max, item.amount));
    final colors = context.appColors;

    return SizedBox(
      width: double.infinity,
      height: chartHeight,
      child: CustomPaint(
        painter: _MonthlyChartPainter(
          items: items,
          axisMax: ExpenseChartAxis.resolveMax(maxAmount),
          amountFormat: _amountFormat,
          monthNames: _monthNames,
          primaryTextColor: colors.primaryText,
          secondaryTextColor: colors.secondaryText,
          borderColor: colors.border,
        ),
      ),
    );
  }
}

class _MonthlyChartPainter extends CustomPainter {
  _MonthlyChartPainter({
    required this.items,
    required this.axisMax,
    required this.amountFormat,
    required this.monthNames,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.borderColor,
  });

  final List<ExpenseMonthlyReportItem> items;
  final double axisMax;
  final NumberFormat amountFormat;
  final List<String> monthNames;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color borderColor;

  static const _barColor = Color(0xFF93C5FD);
  static const _futureBarColor = Color(0xFFE5E7EB);
  static const _leftPadding = 44.0;
  static const _bottomPadding = 40.0;
  static const _topPadding = 28.0;
  static const _rightPadding = 16.0;
  static const _gridLines = 4;
  static const _minBarHeight = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - _leftPadding - _rightPadding;
    final chartHeight = size.height - _bottomPadding - _topPadding;
    final origin = Offset(_leftPadding, _topPadding);

    _drawGrid(canvas, origin, chartWidth, chartHeight);
    _drawBars(canvas, origin, chartWidth, chartHeight);
    _drawValueLabels(canvas, origin, chartWidth, chartHeight);
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

      final value = axisMax * fraction;
      final label = TextPainter(
        text: TextSpan(
          text: ExpenseChartAxis.formatLabel(value),
          style: TextStyle(fontSize: 11, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(origin.dx - label.width - 10, y - label.height / 2),
      );
    }
  }

  void _drawBars(Canvas canvas, Offset origin, double width, double height) {
    if (items.isEmpty || axisMax <= 0) return;

    final slotWidth = width / items.length;
    final barWidth = slotWidth * 0.38;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final isFuture = item.isFutureMonth;
      var barHeight = isFuture
          ? _minBarHeight
          : (item.amount / axisMax) * height;

      if (!isFuture && item.amount > 0 && barHeight < _minBarHeight) {
        barHeight = _minBarHeight;
      }

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      final barLeft = slotCenterX - barWidth / 2;
      final barTop = origin.dy + height - barHeight;

      canvas.drawRect(
        Rect.fromLTWH(
          barLeft,
          barTop,
          barWidth,
          barHeight,
        ),
        Paint()..color = isFuture ? _futureBarColor : _barColor,
      );
    }
  }

  void _drawValueLabels(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    if (items.isEmpty || axisMax <= 0) return;

    final slotWidth = width / items.length;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      if (item.isFutureMonth || item.amount <= 0) continue;

      var barHeight = (item.amount / axisMax) * height;
      if (barHeight < _minBarHeight) barHeight = _minBarHeight;

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      final barTop = origin.dy + height - barHeight;

      paintBarValueLabel(
        canvas,
        text: amountFormat.format(item.amount),
        centerX: slotCenterX,
        barTop: barTop,
        maxWidth: slotWidth - 4,
        chartTop: origin.dy,
        textColor: primaryTextColor,
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
      final label = TextPainter(
        text: TextSpan(
          text: monthNames[item.month.month - 1],
          style: TextStyle(
            fontSize: 11,
            color: item.isFutureMonth
                ? borderColor
                : secondaryTextColor,
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
  bool shouldRepaint(covariant _MonthlyChartPainter oldDelegate) {
    return oldDelegate.items != items ||
        oldDelegate.axisMax != axisMax ||
        oldDelegate.primaryTextColor != primaryTextColor ||
        oldDelegate.secondaryTextColor != secondaryTextColor ||
        oldDelegate.borderColor != borderColor;
  }
}

class ExpenseCategoriesComparisonChart extends StatelessWidget {
  const ExpenseCategoriesComparisonChart({
    required this.items,
    required this.currentMonthLabel,
    required this.previousMonthLabel,
    super.key,
  });

  final List<ExpenseCategoryComparisonItem> items;
  final String currentMonthLabel;
  final String previousMonthLabel;

  static const chartHeight = 300.0;

  bool get _isEmpty {
    if (items.isEmpty) return true;
    return items.every(
      (item) => item.currentAmount == 0 && item.previousAmount == 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return const ExpenseChartEmpty(height: chartHeight);
    }

    final maxAmount = items.fold<double>(0, (max, item) {
      return math.max(
        max,
        math.max(item.currentAmount, item.previousAmount),
      );
    });
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _LegendDot(color: const Color(0xFF2563EB), label: currentMonthLabel),
            const SizedBox(width: 16),
            _LegendDot(
              color: const Color(0xFFD1D5DB),
              label: previousMonthLabel,
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: chartHeight,
          child: CustomPaint(
            painter: _ComparisonChartPainter(
              items: items,
              axisMax: ExpenseChartAxis.resolveMax(maxAmount),
              amountFormat: NumberFormat('#,##0', 'ru'),
              primaryTextColor: colors.primaryText,
              secondaryTextColor: colors.secondaryText,
              borderColor: colors.border,
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colors.secondaryText),
        ),
      ],
    );
  }
}

class _ComparisonChartPainter extends CustomPainter {
  _ComparisonChartPainter({
    required this.items,
    required this.axisMax,
    required this.amountFormat,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.borderColor,
  });

  final List<ExpenseCategoryComparisonItem> items;
  final double axisMax;
  final NumberFormat amountFormat;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color borderColor;

  static const _currentColor = Color(0xFF2563EB);
  static const _previousColor = Color(0xFFD1D5DB);
  static const _leftPadding = 44.0;
  static const _bottomPadding = 52.0;
  static const _topPadding = 28.0;
  static const _rightPadding = 16.0;
  static const _gridLines = 4;
  static const _minBarHeight = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - _leftPadding - _rightPadding;
    final chartHeight = size.height - _bottomPadding - _topPadding;
    final origin = Offset(_leftPadding, _topPadding);

    _drawGrid(canvas, origin, chartWidth, chartHeight);
    _drawBars(canvas, origin, chartWidth, chartHeight);
    _drawLabels(canvas, origin, chartWidth, chartHeight);
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

      final value = axisMax * fraction;
      final label = TextPainter(
        text: TextSpan(
          text: ExpenseChartAxis.formatLabel(value),
          style: TextStyle(fontSize: 11, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(origin.dx - label.width - 10, y - label.height / 2),
      );
    }
  }

  void _drawBars(Canvas canvas, Offset origin, double width, double height) {
    if (items.isEmpty || axisMax <= 0) return;

    final slotWidth = width / items.length;
    final barWidth = math.min(slotWidth * 0.22, 20.0);
    final groupWidth = barWidth * 2 + 4;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      final groupLeft = slotCenterX - groupWidth / 2;

      _drawBar(
        canvas,
        left: groupLeft,
        amount: item.previousAmount,
        origin: origin,
        height: height,
        barWidth: barWidth,
        color: _previousColor,
      );
      _drawBar(
        canvas,
        left: groupLeft + barWidth + 4,
        amount: item.currentAmount,
        origin: origin,
        height: height,
        barWidth: barWidth,
        color: _currentColor,
      );
    }
  }

  void _drawBar(
    Canvas canvas, {
    required double left,
    required double amount,
    required Offset origin,
    required double height,
    required double barWidth,
    required Color color,
  }) {
    if (amount <= 0) return;

    var barHeight = (amount / axisMax) * height;
    if (barHeight < _minBarHeight) barHeight = _minBarHeight;

    final barTop = origin.dy + height - barHeight;
    final barCenterX = left + barWidth / 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, barTop, barWidth, barHeight),
        const Radius.circular(2),
      ),
      Paint()..color = color,
    );

    paintBarValueLabel(
      canvas,
      text: amountFormat.format(amount),
      centerX: barCenterX,
      barTop: barTop,
      maxWidth: barWidth + 8,
      chartTop: origin.dy,
      fontSize: 9,
      textColor: primaryTextColor,
    );
  }

  void _drawLabels(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    final slotWidth = width / items.length;

    for (var index = 0; index < items.length; index++) {
      final label = TextPainter(
        text: TextSpan(
          text: truncateChartLabel(items[index].categoryName),
          style: TextStyle(fontSize: 10, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: slotWidth - 4);

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      label.paint(
        canvas,
        Offset(slotCenterX - label.width / 2, origin.dy + height + 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ComparisonChartPainter oldDelegate) {
    return oldDelegate.items != items ||
        oldDelegate.axisMax != axisMax ||
        oldDelegate.primaryTextColor != primaryTextColor ||
        oldDelegate.secondaryTextColor != secondaryTextColor ||
        oldDelegate.borderColor != borderColor;
  }
}

class ExpenseCategoriesTop5Chart extends StatelessWidget {
  const ExpenseCategoriesTop5Chart({
    required this.items,
    super.key,
  });

  final List<ExpenseCategoryReportItem> items;

  static const rowHeight = 36.0;
  static const chartHeight = rowHeight * 5 + 16;
  static final _amountFormat = NumberFormat('#,##0', 'ru');

  List<ExpenseCategoryReportItem> get _topItems {
    if (items.length <= 5) return items;
    return items.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topItems = _topItems;
    if (topItems.isEmpty) {
      return const ExpenseChartEmpty(height: chartHeight);
    }

    final maxAmount =
        topItems.fold<double>(0, (max, item) => math.max(max, item.amount));
    final colors = context.appColors;

    return SizedBox(
      width: double.infinity,
      height: chartHeight,
      child: CustomPaint(
        painter: _Top5ChartPainter(
          items: topItems,
          maxAmount: maxAmount,
          amountFormat: _amountFormat,
          primaryTextColor: colors.primaryText,
          secondaryTextColor: colors.secondaryText,
        ),
      ),
    );
  }
}

class _Top5ChartPainter extends CustomPainter {
  _Top5ChartPainter({
    required this.items,
    required this.maxAmount,
    required this.amountFormat,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  final List<ExpenseCategoryReportItem> items;
  final double maxAmount;
  final NumberFormat amountFormat;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  static const _leftPadding = 120.0;
  static const _rightPadding = 72.0;
  static const _topPadding = 8.0;
  static const _rowHeight = 36.0;
  static const _minBarWidth = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final barAreaWidth = size.width - _leftPadding - _rightPadding;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final rowTop = _topPadding + index * _rowHeight;
      final rowCenterY = rowTop + _rowHeight / 2;

      final nameLabel = TextPainter(
        text: TextSpan(
          text: truncateChartLabel(item.categoryName, maxLength: 14),
          style: TextStyle(fontSize: 12, color: primaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
        textAlign: TextAlign.right,
      )..layout(maxWidth: _leftPadding - 12);

      nameLabel.paint(
        canvas,
        Offset(_leftPadding - nameLabel.width - 12, rowCenterY - nameLabel.height / 2),
      );

      final barWidth = maxAmount > 0
          ? math.max(_minBarWidth, item.amount / maxAmount * barAreaWidth)
          : 0.0;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            _leftPadding,
            rowCenterY - 10,
            barWidth,
            20,
          ),
          const Radius.circular(4),
        ),
        Paint()..color = ExpenseChartColors.at(index),
      );

      final amountLabel = TextPainter(
        text: TextSpan(
          text: amountFormat.format(item.amount),
          style: TextStyle(fontSize: 11, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      amountLabel.paint(
        canvas,
        Offset(_leftPadding + barWidth + 8, rowCenterY - amountLabel.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _Top5ChartPainter oldDelegate) {
    return oldDelegate.items != items ||
        oldDelegate.maxAmount != maxAmount ||
        oldDelegate.primaryTextColor != primaryTextColor ||
        oldDelegate.secondaryTextColor != secondaryTextColor;
  }
}

class ExpenseCategoriesParetoChart extends StatelessWidget {
  const ExpenseCategoriesParetoChart({
    required this.items,
    super.key,
  });

  final List<ExpenseCategoryReportItem> items;

  static const chartHeight = 300.0;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const ExpenseChartEmpty(height: chartHeight);
    }

    final maxAmount =
        items.fold<double>(0, (max, item) => math.max(max, item.amount));
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _LegendDot(color: ExpenseChartColors.at(0), label: 'Сумма'),
            const SizedBox(width: 16),
            const _LegendDot(
              color: Color(0xFFEA580C),
              label: 'Накопленный %',
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: chartHeight,
          child: CustomPaint(
            painter: _ParetoChartPainter(
              items: items,
              axisMax: ExpenseChartAxis.resolveMax(maxAmount),
              amountFormat: NumberFormat('#,##0', 'ru'),
              primaryTextColor: colors.primaryText,
              secondaryTextColor: colors.secondaryText,
              borderColor: colors.border,
            ),
          ),
        ),
      ],
    );
  }
}

class _ParetoChartPainter extends CustomPainter {
  _ParetoChartPainter({
    required this.items,
    required this.axisMax,
    required this.amountFormat,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.borderColor,
  });

  final List<ExpenseCategoryReportItem> items;
  final double axisMax;
  final NumberFormat amountFormat;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color borderColor;

  static const _leftPadding = 44.0;
  static const _rightPadding = 40.0;
  static const _bottomPadding = 52.0;
  static const _topPadding = 28.0;
  static const _gridLines = 4;
  static const _lineColor = Color(0xFFEA580C);
  static const _minBarHeight = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - _leftPadding - _rightPadding;
    final chartHeight = size.height - _bottomPadding - _topPadding;
    final origin = Offset(_leftPadding, _topPadding);

    _drawLeftGrid(canvas, origin, chartWidth, chartHeight);
    _drawRightGrid(canvas, origin, chartWidth, chartHeight, size.width);
    _drawBars(canvas, origin, chartWidth, chartHeight);
    _drawValueLabels(canvas, origin, chartWidth, chartHeight);
    _drawCumulativeLine(canvas, origin, chartWidth, chartHeight);
    _drawCategoryLabels(canvas, origin, chartWidth, chartHeight);
  }

  void _drawLeftGrid(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
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

      final value = axisMax * fraction;
      final label = TextPainter(
        text: TextSpan(
          text: ExpenseChartAxis.formatLabel(value),
          style: TextStyle(fontSize: 11, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(origin.dx - label.width - 10, y - label.height / 2),
      );
    }
  }

  void _drawRightGrid(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
    double totalWidth,
  ) {
    const percents = [0, 25, 50, 75, 100];

    for (final percent in percents) {
      final fraction = percent / 100;
      final y = origin.dy + height * (1 - fraction);

      final label = TextPainter(
        text: TextSpan(
          text: '$percent%',
          style: TextStyle(fontSize: 10, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(totalWidth - _rightPadding + 6, y - label.height / 2),
      );
    }
  }

  void _drawBars(Canvas canvas, Offset origin, double width, double height) {
    if (items.isEmpty || axisMax <= 0) return;

    final slotWidth = width / items.length;
    final barWidth = math.min(slotWidth * 0.5, 48.0);

    for (var index = 0; index < items.length; index++) {
      var barHeight = (items[index].amount / axisMax) * height;
      if (items[index].amount > 0 && barHeight < _minBarHeight) {
        barHeight = _minBarHeight;
      }

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      final barLeft = slotCenterX - barWidth / 2;
      final barTop = origin.dy + height - barHeight;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(barLeft, barTop, barWidth, barHeight),
          const Radius.circular(3),
        ),
        Paint()..color = ExpenseChartColors.at(0).withValues(alpha: 0.75),
      );
    }
  }

  void _drawValueLabels(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    if (items.isEmpty || axisMax <= 0) return;

    final slotWidth = width / items.length;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      if (item.amount <= 0) continue;

      var barHeight = (item.amount / axisMax) * height;
      if (barHeight < _minBarHeight) barHeight = _minBarHeight;

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      final barTop = origin.dy + height - barHeight;

      paintBarValueLabel(
        canvas,
        text: amountFormat.format(item.amount),
        centerX: slotCenterX,
        barTop: barTop,
        maxWidth: slotWidth - 4,
        chartTop: origin.dy,
        textColor: primaryTextColor,
      );
    }
  }

  void _drawCumulativeLine(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    if (items.isEmpty) return;

    final slotWidth = width / items.length;
    final path = Path();
    var cumulative = 0.0;

    for (var index = 0; index < items.length; index++) {
      cumulative += items[index].percentage;
      final x = origin.dx + slotWidth * index + slotWidth / 2;
      final y = origin.dy + height * (1 - cumulative / 100);

      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = _lineColor,
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = _lineColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawCategoryLabels(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    final slotWidth = width / items.length;

    for (var index = 0; index < items.length; index++) {
      final label = TextPainter(
        text: TextSpan(
          text: truncateChartLabel(items[index].categoryName),
          style: TextStyle(fontSize: 10, color: secondaryTextColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: slotWidth - 4);

      final slotCenterX = origin.dx + slotWidth * index + slotWidth / 2;
      label.paint(
        canvas,
        Offset(slotCenterX - label.width / 2, origin.dy + height + 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParetoChartPainter oldDelegate) {
    return oldDelegate.items != items ||
        oldDelegate.axisMax != axisMax ||
        oldDelegate.primaryTextColor != primaryTextColor ||
        oldDelegate.secondaryTextColor != secondaryTextColor ||
        oldDelegate.borderColor != borderColor;
  }
}

class ExpenseBasesStructureChart extends StatelessWidget {
  const ExpenseBasesStructureChart({
    required this.items,
    super.key,
  });

  final List<ExpenseBaseReportItem> items;

  static const chartSize = 180.0;
  static const legendMaxWidth = 220.0;
  static final _percentFormat = NumberFormat('#,##0.0', 'ru');

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const ExpenseChartEmpty();
    }

    final colors = context.appColors;

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
              painter: _BasesPiePainter(
                items: items,
                colors: _resolveColors(items.length),
                holeColor: colors.surface,
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
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _resolveColors(items.length)[index],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                items[index].baseName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.primaryText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_percentFormat.format(items[index].percentage)}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.secondaryText,
                              ),
                            ),
                          ],
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

class _BasesPiePainter extends CustomPainter {
  _BasesPiePainter({
    required this.items,
    required this.colors,
    required this.holeColor,
  });

  final List<ExpenseBaseReportItem> items;
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
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        Paint()
          ..color = colors[index]
          ..style = PaintingStyle.fill,
      );
      startAngle += sweepAngle;
    }

    canvas.drawCircle(
      center,
      radius * 0.55,
      Paint()..color = holeColor,
    );
  }

  @override
  bool shouldRepaint(covariant _BasesPiePainter oldDelegate) {
    return oldDelegate.items != items ||
        oldDelegate.colors != colors ||
        oldDelegate.holeColor != holeColor;
  }
}
