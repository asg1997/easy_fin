import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_shortcuts.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/actions/quick_add_actions.dart';
import 'package:easy_fin/view/controllers/import_controller.dart';
import 'package:easy_fin/view/controllers/import_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _labelPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

Widget _speedDialLabel(BuildContext context, String text) {
  final colors = context.appColors;
  return DecoratedBox(
    decoration: BoxDecoration(
      color: colors.surface,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          offset: Offset(0, 2),
          blurRadius: 8,
        ),
      ],
    ),
    child: Padding(
      padding: _labelPadding,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colors.primaryText,
        ),
      ),
    ),
  );
}

class AddActionSpeedDial extends ConsumerWidget {
  const AddActionSpeedDial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importState = ref.watch(importControllerProvider);
    final isImportLoading = importState.isImportInProgress;
    final importPercent = importState is ImportLoading && importState.total > 0
        ? importState.percent
        : null;

    return SpeedDial(
      icon: LucideIcons.plus,
      activeIcon: LucideIcons.x,
      backgroundColor: AppColors.purple,
      foregroundColor: Colors.white,
      activeBackgroundColor: AppColors.purple,
      activeForegroundColor: Colors.white,
      overlayOpacity: 0.4,
      spacing: 12,
      spaceBetweenChildren: 12,
      children: [
        SpeedDialChild(
          child: const Icon(LucideIcons.handCoins, size: 20),
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          labelWidget: _speedDialLabel(
            context,
            'Добавить приход (${shortcutLabel('G')})',
          ),
          onTap: () => openAddIncome(context),
        ),
        SpeedDialChild(
          child: const Icon(LucideIcons.circleMinus, size: 20),
          backgroundColor: AppColors.red,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          labelWidget: _speedDialLabel(
            context,
            'Добавить расход (${shortcutLabel('H')})',
          ),
          onTap: () => openAddExpense(context),
        ),
        SpeedDialChild(
          child: const Icon(LucideIcons.building2, size: 20),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          labelWidget: _speedDialLabel(
            context,
            'Начисление по аренде (${shortcutLabel('Y')})',
          ),
          onTap: () => openAddRentAccrual(context),
        ),
        SpeedDialChild(
          child: isImportLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(LucideIcons.import, size: 20),
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          labelWidget: _speedDialLabel(
            context,
            importPercent != null
                ? 'Импорт $importPercent% (${shortcutLabel('B')})'
                : 'Импорт (${shortcutLabel('B')})',
          ),
          onTap: () => openImport(context, ref),
        ),
      ],
    );
  }
}
