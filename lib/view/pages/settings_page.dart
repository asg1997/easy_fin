import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/pages/bases_page.dart';
import 'package:easy_fin/view/pages/expense_categories_page.dart';
import 'package:easy_fin/view/pages/income_categories_page.dart';
import 'package:easy_fin/view/pages/renters_page.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TemplatePage(
      title: 'Настройки',
      child: ListView(
        children: [
          _SettingsTile(
            title: 'Базы',
            subtitle: 'Справочник баз',
            icon: LucideIcons.building2,
            onTap: () => BasesPage.navigate(context),
          ),
          const Gap(12),
          _SettingsTile(
            title: 'Арендаторы',
            subtitle: 'Справочник арендаторов',
            icon: LucideIcons.users,
            onTap: () => RentersPage.navigate(context),
          ),
          const Gap(12),
          _SettingsTile(
            title: 'Категории прочих приходов',
            subtitle: 'Справочник для приходов типа «Другое»',
            icon: LucideIcons.tags,
            onTap: () => IncomeCategoriesPage.navigate(context),
          ),
          const Gap(12),
          _SettingsTile(
            title: 'Справочник расходов',
            subtitle: 'Категории расходов',
            icon: LucideIcons.tags,
            onTap: () => ExpenseCategoriesPage.navigate(context),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.purple),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: filterFieldTextStyle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      subtitle,
                      style: filterFieldHintTextStyle,
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
