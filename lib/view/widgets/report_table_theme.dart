import 'package:easy_fin/utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract class ReportTableTheme {
  static const standardWidth = 560.0;
  static const headerHeight = 36.0;
  static const rowHeight = 40.0;
  static const footerHeight = 40.0;
  static const horizontalPadding = 12.0;
  static const rowDividerColor = Color(0xFFF0F0F0);
  static const secondaryText = Color(0xFF8E8E8E);
  static const primaryText = Color(0xFF333333);
  static const borderColor = Color(0xFFEBEBEB);
  static const borderWidth = 1.0;

  static const sectionTitleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: primaryText,
    height: 1.3,
  );

  static const headerTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: secondaryText,
  );

  static const cellTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: primaryText,
  );

  static const secondaryCellTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: secondaryText,
  );

  static const borderRadius = BorderRadius.all(Radius.circular(8));

  static const rowDivider = Divider(
    height: 1,
    thickness: 1,
    color: rowDividerColor,
  );

  static const sectionDivider = Divider(
    height: 1,
    thickness: 1,
    color: AppColors.border,
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: ReportTableTheme.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: ReportTableTheme.borderRadius,
          side: const BorderSide(
            color: ReportTableTheme.borderColor,
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.border,
      ),
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
      style: ReportTableTheme.sectionTitleTextStyle,
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
      style: ReportTableTheme.headerTextStyle,
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
    return Column(
      children: [
        ReportTableTheme.sectionDivider,
        Container(
          height: ReportTableTheme.footerHeight,
          color: Colors.white,
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
                    const TextSpan(
                      text: 'Sum ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: ReportTableTheme.secondaryText,
                      ),
                    ),
                    TextSpan(
                      text: '$amount$suffix',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: ReportTableTheme.primaryText,
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
