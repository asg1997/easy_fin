import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/view/pages/bases_page.dart';
import 'package:easy_fin/view/pages/renters_page.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DatabasePage extends ConsumerWidget {
  const DatabasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TemplatePage(
      title: 'Данные',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DataNavItem(
            title: 'Базы',
            icon: LucideIcons.building2,
            onTap: () => BasesPage.navigate(context),
          ),
          const Gap(12),
          _DataNavItem(
            title: 'Арендаторы',
            icon: LucideIcons.users,
            onTap: () => RentersPage.navigate(context),
          ),
        ],
      ),
    );
  }
}

class _DataNavItem extends StatelessWidget {
  const _DataNavItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
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
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey),
                const Gap(12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
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
      ),
    );
  }
}
