import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:easy_fin/utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class ExpenseChartColors {
  static const palette = [
    AppColors.blue,
    AppColors.green,
    AppColors.purple,
    AppColors.red,
    Color(0xFFF59E0B),
    Color(0xFF0891B2),
    Color(0xFFDB2777),
    Color(0xFF65A30D),
    Color(0xFFEA580C),
    Color(0xFF4B5563),
  ];

  static Color at(int index) => palette[index % palette.length];
}

abstract class ExpenseChartAxis {
  static double resolveMax(double maxValue) {
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

  static String formatLabel(double value) {
    if (value >= 1000) {
      final thousands = value / 1000;
      if (thousands == thousands.roundToDouble()) {
        return '${thousands.toInt()}k';
      }
      return '${thousands.toStringAsFixed(1)}k';
    }

    return value.round().toString();
  }
}

class ExpenseChartSection extends StatelessWidget {
  const ExpenseChartSection({
    required this.title,
    required this.child,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class ExpenseChartEmpty extends StatelessWidget {
  const ExpenseChartEmpty({
    this.height = 220,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
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
}

String truncateChartLabel(String label, {int maxLength = 10}) {
  if (label.length <= maxLength) return label;
  return '${label.substring(0, maxLength - 1)}…';
}

void paintBarValueLabel(
  Canvas canvas, {
  required String text,
  required double centerX,
  required double barTop,
  required double maxWidth,
  double chartTop = 0,
  double fontSize = 11,
}) {
  final label = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F1F1F),
      ),
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  var labelY = barTop - label.height - 4;
  if (labelY < chartTop) {
    labelY = barTop + 4;
  }

  label.paint(
    canvas,
    Offset(centerX - label.width / 2, labelY),
  );
}
