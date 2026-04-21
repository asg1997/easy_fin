import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/view/pages/add_income_page.dart';
import 'package:easy_fin/view/pages/database_page.dart';
import 'package:easy_fin/view/pages/documents_page.dart';
import 'package:easy_fin/view/pages/reports_page.dart';
import 'package:easy_fin/view/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Главная страница навигации
class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  bool isExpanded = false;
  int currentIndex = 0;

  void onItemTapped(int index) {
    currentIndex = index;
    setState(() {});
  }

  void toggleExpanded() {
    isExpanded = !isExpanded;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  onPressed: toggleExpanded,
                  shape: const CircleBorder(),
                  child: Icon(
                    size: 16,
                    color: Colors.grey,
                    isExpanded
                        ? LucideIcons.chevronsLeft
                        : LucideIcons.chevronsRight,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isExpanded ? 20 : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavItem(
                          title: 'Отчеты',
                          icon: LucideIcons.chartArea,
                          onPressed: () => onItemTapped(0),
                          isExpanded: isExpanded,
                          isActive: currentIndex == 0,
                        ),
                        NavItem(
                          title: 'Документы',
                          icon: LucideIcons.fileText,
                          onPressed: () => onItemTapped(1),
                          isExpanded: isExpanded,
                          isActive: currentIndex == 1,
                        ),
                        NavItem(
                          title: 'Данные',
                          icon: LucideIcons.database,
                          onPressed: () => onItemTapped(2),
                          isExpanded: isExpanded,
                          isActive: currentIndex == 2,
                        ),
                        NavItem(
                          title: 'Настройки',
                          icon: LucideIcons.settings,
                          onPressed: () => onItemTapped(3),
                          isExpanded: isExpanded,
                          isActive: currentIndex == 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),

                /// Импорт данных
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Tooltip(
                        message: !isExpanded ? 'Приход' : '',
                        child: MaterialButton(
                          onPressed: () => AddIncomePage.navigate(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: isExpanded ? 20 : 0,
                          ),
                          minWidth: 50,
                          height: 50,
                          color: AppColors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.handCoins,
                                size: 20,
                                color: Colors.white,
                              ),
                              if (isExpanded) ...[
                                const Gap(10),
                                const Text(
                                  'Добавить приход',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      Tooltip(
                        message: !isExpanded ? 'Импорт' : '',
                        child: MaterialButton(
                          onPressed: () {},
                          padding: EdgeInsets.symmetric(
                            horizontal: isExpanded ? 20 : 0,
                          ),
                          minWidth: 50,
                          height: 50,
                          color: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.import,
                                size: 20,
                                color: Colors.white,
                              ),
                              if (isExpanded) ...[
                                const Gap(10),
                                const Text(
                                  'Импорт',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (currentIndex) {
              0 => const ReportsPage(),
              1 => const DocumentsPage(),
              2 => const DatabasePage(),
              3 => const SettingsPage(),
              _ => Container(),
            },
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.isExpanded,
    required this.isActive,
    super.key,
  });
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isExpanded;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: !isExpanded ? title : '',
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),

        child: SizedBox(
          height: 50,

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              if (isExpanded) ...[
                const Gap(10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
