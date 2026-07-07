import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';

const double filterFieldHeight = 50;
const double filterFieldHorizontalPadding = 12;

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
