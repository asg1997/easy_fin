import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
  );

  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: colorScheme,
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: AppColors.primary,
      headerForegroundColor: Colors.white,
      weekdayStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
      dayStyle: filterFieldTextStyle,
      yearStyle: filterFieldTextStyle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
      todayForegroundColor: WidgetStateProperty.all(AppColors.primary),
      todayBackgroundColor: WidgetStateProperty.all(
        AppColors.primary.withValues(alpha: 0.12),
      ),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return null;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return null;
      }),
    ),
  );
}
