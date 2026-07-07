import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';

abstract class ReportTableTheme {
  static const standardWidth = 560.0;
  static const headerHeight = 36.0;
  static const rowHeight = 40.0;
  static const footerHeight = 40.0;
  static const horizontalPadding = 12.0;
  static const borderWidth = 1.0;
  static const borderRadius = BorderRadius.all(Radius.circular(8));

  static TextStyle sectionTitleTextStyle(BuildContext context) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: context.appColors.primaryText,
        height: 1.3,
      );

  static TextStyle headerTextStyle(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: context.appColors.secondaryText,
      );

  static TextStyle cellTextStyle(BuildContext context) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: context.appColors.primaryText,
      );

  static TextStyle secondaryCellTextStyle(BuildContext context) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: context.appColors.secondaryText,
      );

  static Widget rowDivider(BuildContext context) => Divider(
        height: 1,
        thickness: 1,
        color: context.appColors.tableRowDivider,
      );

  static Widget sectionDivider(BuildContext context) => Divider(
        height: 1,
        thickness: 1,
        color: context.appColors.border,
      );
}

class ReportTableFrame extends StatelessWidget {
  const ReportTableFrame({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: ReportTableTheme.borderRadius,
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: colors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: ReportTableTheme.borderRadius,
          side: BorderSide(
            color: colors.border,
            width: ReportTableTheme.borderWidth,
          ),
        ),
        child: child,
      ),
    );
  }
}

class ReportTableSectionDivider extends StatelessWidget {
  const ReportTableSectionDivider({super.key});

  static const verticalPadding = 24.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: verticalPadding),
      child: ReportTableTheme.sectionDivider(context),
    );
  }
}

class ReportTableTitle extends StatelessWidget {
  const ReportTableTitle(
    this.title, {
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: ReportTableTheme.sectionTitleTextStyle(context),
    );
  }
}

class ReportTableHeaderLabel extends StatelessWidget {
  const ReportTableHeaderLabel({
    required this.label,
    this.textAlign = TextAlign.left,
    super.key,
  });

  final String label;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      style: ReportTableTheme.headerTextStyle(context),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ReportTableSumFooter extends StatelessWidget {
  const ReportTableSumFooter({
    required this.amount,
    this.suffix = '',
    super.key,
  });

  final String amount;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        ReportTableTheme.sectionDivider(context),
        Container(
          height: ReportTableTheme.footerHeight,
          color: colors.surface,
          padding: const EdgeInsets.symmetric(
            horizontal: ReportTableTheme.horizontalPadding,
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Sum ',
                      style: ReportTableTheme.secondaryCellTextStyle(context),
                    ),
                    TextSpan(
                      text: '$amount$suffix',
                      style: ReportTableTheme.cellTextStyle(context).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
