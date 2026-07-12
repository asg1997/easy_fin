import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
  );

  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: colorScheme,
    extensions: const [AppThemeColors.light],
    dividerTheme: const DividerThemeData(
      color: Color(0xFFF0F0F0),
    ),
    cardTheme: CardThemeData(
      color: AppThemeColors.light.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppThemeColors.light.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppThemeColors.light.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppThemeColors.light.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppThemeColors.light.accent,
        foregroundColor: AppThemeColors.light.onAccent,
      ),
    ),
    datePickerTheme: _buildDatePickerTheme(
      backgroundColor: Colors.white,
      weekdayColor: Colors.grey,
      accentColor: AppThemeColors.light.accent,
      onAccentColor: AppThemeColors.light.onAccent,
    ),
  );
}

ThemeData buildDarkTheme() {
  const colors = AppThemeColors.dark;
  const colorScheme = ColorScheme.dark(
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF1F1F1F),
    surface: Color(0xFF2A2A2A),
    onSurface: Color(0xFFFFFFFF),
  );

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1F1F1F),
    colorScheme: colorScheme,
    extensions: const [AppThemeColors.dark],
    dividerTheme: const DividerThemeData(
      color: Color(0xFF333333),
    ),
    cardTheme: CardThemeData(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: colors.onAccent,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.border),
      ),
    ),
    datePickerTheme: _buildDatePickerTheme(
      backgroundColor: colors.surface,
      weekdayColor: colors.secondaryText,
      accentColor: colors.accent,
      onAccentColor: colors.onAccent,
    ),
  );
}

DatePickerThemeData _buildDatePickerTheme({
  required Color backgroundColor,
  required Color weekdayColor,
  required Color accentColor,
  required Color onAccentColor,
}) {
  return DatePickerThemeData(
    backgroundColor: backgroundColor,
    headerBackgroundColor: AppColors.primary,
    headerForegroundColor: Colors.white,
    weekdayStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: weekdayColor,
    ),
    dayStyle: filterFieldTextStyle,
    yearStyle: filterFieldTextStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    cancelButtonStyle: TextButton.styleFrom(
      foregroundColor: accentColor,
    ),
    confirmButtonStyle: TextButton.styleFrom(
      foregroundColor: accentColor,
    ),
    todayForegroundColor: WidgetStateProperty.all(accentColor),
    todayBackgroundColor: WidgetStateProperty.all(
      accentColor.withValues(alpha: 0.12),
    ),
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return onAccentColor;
      }
      return null;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return null;
    }),
  );
}
