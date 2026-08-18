import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({
    required this.child,
    required this.title,
    this.hasBackButton = false,
    this.titleSuffix,
    super.key,
  });
  final Widget child;
  final String title;
  final bool hasBackButton;
  final Widget? titleSuffix;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final suffix = titleSuffix;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ).copyWith(top: 30, bottom: 10),
          child: Row(
            children: [
              if (hasBackButton) ...[
                BackButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(colors.secondaryText),
                    iconSize: WidgetStateProperty.all(20),
                  ),
                ),
                const Gap(10),
              ],
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryText,
                  ),
                ),
              ),
              if (suffix != null) ...[
                const Gap(10),
                suffix,
              ],
            ],
          ),
        ),
        Divider(color: colors.border, thickness: .5),
        const Gap(20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: child,
          ),
        ),
      ],
    );
  }
}
