import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.sidebarBackground,
    required this.surface,
    required this.primaryText,
    required this.secondaryText,
    required this.border,
    required this.navActiveBackground,
    required this.navActiveText,
    required this.tableRowDivider,
    required this.accent,
    required this.onAccent,
  });

  final Color sidebarBackground;
  final Color surface;
  final Color primaryText;
  final Color secondaryText;
  final Color border;
  final Color navActiveBackground;
  final Color navActiveText;
  final Color tableRowDivider;
  /// Primary action button fill (dark in light theme, light in dark theme).
  final Color accent;
  /// Text/icon color on [accent] buttons.
  final Color onAccent;

  static const light = AppThemeColors(
    sidebarBackground: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    primaryText: Color(0xFF1F1F1F),
    secondaryText: Color(0xFF8E8E8E),
    border: Color(0xFFE7E7E7),
    navActiveBackground: Color(0xFFF0F0F0),
    navActiveText: Color(0xFF1F1F1F),
    tableRowDivider: Color(0xFFF0F0F0),
    accent: Color(0xFF1F1F1F),
    onAccent: Color(0xFFFFFFFF),
  );

  static const dark = AppThemeColors(
    sidebarBackground: Color(0xFF282828),
    surface: Color(0xFF2A2A2A),
    primaryText: Color(0xFFFFFFFF),
    secondaryText: Color(0xFF808080),
    border: Color(0xFF333333),
    navActiveBackground: Color(0xFF3A3A3A),
    navActiveText: Color(0xFFFFFFFF),
    tableRowDivider: Color(0xFF333333),
    accent: Color(0xFFFFFFFF),
    onAccent: Color(0xFF1F1F1F),
  );

  @override
  AppThemeColors copyWith({
    Color? sidebarBackground,
    Color? surface,
    Color? primaryText,
    Color? secondaryText,
    Color? border,
    Color? navActiveBackground,
    Color? navActiveText,
    Color? tableRowDivider,
    Color? accent,
    Color? onAccent,
  }) {
    return AppThemeColors(
      sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      surface: surface ?? this.surface,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      border: border ?? this.border,
      navActiveBackground: navActiveBackground ?? this.navActiveBackground,
      navActiveText: navActiveText ?? this.navActiveText,
      tableRowDivider: tableRowDivider ?? this.tableRowDivider,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      sidebarBackground:
          Color.lerp(sidebarBackground, other.sidebarBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      border: Color.lerp(border, other.border, t)!,
      navActiveBackground:
          Color.lerp(navActiveBackground, other.navActiveBackground, t)!,
      navActiveText: Color.lerp(navActiveText, other.navActiveText, t)!,
      tableRowDivider: Color.lerp(tableRowDivider, other.tableRowDivider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get appColors =>
      Theme.of(this).extension<AppThemeColors>()!;
}
