import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/controllers/import_state.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImportProgressOverlay extends StatelessWidget {
  const ImportProgressOverlay({required this.state, super.key});

  final ImportLoading state;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final progress = state.progress;
    final showPercent = progress != null;

    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.35),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 280,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showPercent)
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    )
                  else
                    const LinearProgressIndicator(
                      minHeight: 6,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  const Gap(16),
                  Text(
                    state.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    showPercent
                        ? '${state.percent}% · ${state.completed} из ${state.total}'
                        : 'Подготовка…',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
