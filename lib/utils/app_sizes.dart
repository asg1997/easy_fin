import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';

const double filterFieldHeight = 50;
const double filterFieldHorizontalPadding = 12;
const double documentLineFieldHeight = 38;

InputDecoration documentLineFieldDecorationOf(
  BuildContext context, {
  String? hintText,
  EdgeInsetsGeometry? contentPadding,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  );

  return InputDecoration(
    isDense: true,
    hintText: hintText,
    hintStyle: filterFieldHintTextStyleOf(context),
    filled: true,
    fillColor: context.appColors.navActiveBackground,
    contentPadding: contentPadding ??
        const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
    border: border,
    enabledBorder: border,
    focusedBorder: border,
    disabledBorder: border,
    errorBorder: border,
    focusedErrorBorder: border,
  );
}

/// Фон поля ввода на странице: в тёмной теме чуть светлее scaffold.
Color composerFieldFillColorOf(BuildContext context) {
  final colors = context.appColors;
  if (Theme.of(context).brightness != Brightness.dark) {
    return colors.navActiveBackground;
  }

  return Color.alphaBlend(
    Colors.white.withValues(alpha: 0.05),
    Theme.of(context).scaffoldBackgroundColor,
  );
}

InputDecoration composerFieldDecorationOf(
  BuildContext context, {
  String? hintText,
  EdgeInsetsGeometry? contentPadding,
}) {
  final colors = context.appColors;
  final radius = BorderRadius.circular(10);

  return InputDecoration(
    isDense: true,
    hintText: hintText,
    hintStyle: filterFieldHintTextStyleOf(context),
    filled: true,
    fillColor: composerFieldFillColorOf(context),
    contentPadding: contentPadding ?? const EdgeInsets.all(14),
    alignLabelWithHint: true,
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.primaryText),
    ),
  );
}

const filterFieldTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

TextStyle filterFieldHintTextStyleOf(BuildContext context) =>
    filterFieldTextStyle.copyWith(
      color: context.appColors.secondaryText,
    );

@Deprecated('Use filterFieldHintTextStyleOf(context)')
const filterFieldHintTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.grey,
);
