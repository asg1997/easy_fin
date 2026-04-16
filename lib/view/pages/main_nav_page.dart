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
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  onPressed: () => toggleExpanded(),
                  shape: CircleBorder(),
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
                Gap(20),

                /// Импорт данных
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                        Icon(LucideIcons.import, size: 20, color: Colors.white),
                        if (isExpanded) ...[
                          Gap(10),
                          Text(
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
          Expanded(
            child: switch (currentIndex) {
              0 => ReportsPage(),
              1 => DocumentsPage(),
              2 => DatabasePage(),
              3 => SettingsPage(),
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
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.isExpanded,
    required this.isActive,
  });
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isExpanded;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      shape: CircleBorder(),

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
              Gap(10),
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
    );
  }
}
