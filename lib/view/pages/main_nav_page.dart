import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/pages/documents_page.dart';
import 'package:easy_fin/view/pages/reports_page.dart';
import 'package:easy_fin/view/pages/settings_page.dart';
import 'package:easy_fin/view/providers/theme_mode_provider.dart';
import 'package:easy_fin/view/widgets/add_action_speed_dial.dart';
import 'package:easy_fin/view/widgets/import_state_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Главная страница навигации
class MainNavPage extends ConsumerStatefulWidget {
  const MainNavPage({super.key});

  @override
  ConsumerState<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends ConsumerState<MainNavPage> {
  bool isExpanded = true;
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
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeModeAsync = ref.watch(themeModeProvider);
    final isDarkMode = themeModeAsync.value == AppThemeMode.dark;

    return ImportStateListener(
      child: Scaffold(
        floatingActionButton: const AddActionSpeedDial(),
        body: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: isExpanded ? 280 : 90,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: colors.sidebarBackground,
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MaterialButton(
                        onPressed: toggleExpanded,
                        shape: const CircleBorder(),
                        child: Icon(
                          size: 16,
                          color: colors.secondaryText,
                          isExpanded
                              ? LucideIcons.chevronsLeft
                              : LucideIcons.chevronsRight,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isExpanded ? 20 : 0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              title: 'Настройки',
                              icon: LucideIcons.settings,
                              onPressed: () => onItemTapped(2),
                              isExpanded: isExpanded,
                              isActive: currentIndex == 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _ThemeToggle(
                      isExpanded: isExpanded,
                      isDarkMode: isDarkMode,
                      onToggle: () =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
            Expanded(
              child: switch (currentIndex) {
                0 => const ReportsPage(),
                1 => const DocumentsPage(),
                2 => const SettingsPage(),
                _ => Container(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({
    required this.isExpanded,
    required this.isDarkMode,
    required this.onToggle,
  });

  final bool isExpanded;
  final bool isDarkMode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (!isExpanded) {
      return Tooltip(
        message: isDarkMode ? 'Светлая тема' : 'Тёмная тема',
        child: MaterialButton(
          onPressed: onToggle,
          shape: const CircleBorder(),
          child: Icon(
            size: 20,
            color: colors.secondaryText,
            isDarkMode ? LucideIcons.sun : LucideIcons.moon,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(
            isDarkMode ? LucideIcons.moon : LucideIcons.sun,
            size: 20,
            color: colors.secondaryText,
          ),
          const Gap(10),
          Expanded(
            child: Text(
              'Тёмная тема',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.primaryText,
              ),
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (_) => onToggle(),
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
    final colors = context.appColors;
    final iconColor =
        isActive ? colors.navActiveText : colors.secondaryText;
    final bgColor =
        isActive ? colors.navActiveBackground : Colors.transparent;

    return Tooltip(
      message: !isExpanded ? title : '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: iconColor,
                    ),
                    if (isExpanded) ...[
                      const Gap(10),
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
