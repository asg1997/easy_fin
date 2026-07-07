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
