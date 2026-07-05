import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/view/controllers/import_controller.dart';
import 'package:easy_fin/view/pages/add_expense_page.dart';
import 'package:easy_fin/view/pages/add_income_page.dart';
import 'package:easy_fin/view/pages/add_rent_accrual_page.dart';
import 'package:easy_fin/view/pages/documents_page.dart';
import 'package:easy_fin/view/pages/reports_page.dart';
import 'package:easy_fin/view/pages/settings_page.dart';
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
    final importState = ref.watch(importControllerProvider);
    final isImportLoading = importState.isImportInProgress;

    return ImportStateListener(
      child: Scaffold(
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
                const Gap(20),

                /// Импорт данных
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      /// КНОПКА ПРИХОД
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

                      /// КНОПКА РАСХОД
                      Tooltip(
                        message: !isExpanded ? 'Расход' : '',
                        child: MaterialButton(
                          onPressed: () => AddExpensePage.navigate(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: isExpanded ? 20 : 0,
                          ),
                          minWidth: 50,
                          height: 50,
                          color: AppColors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.circleMinus,
                                size: 20,
                                color: Colors.white,
                              ),
                              if (isExpanded) ...[
                                const Gap(10),
                                const Text(
                                  'Добавить расход',
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

                      /// КНОПКА НАЧИСЛЕНИЕ ПО АРЕНДЕ
                      Tooltip(
                        message: !isExpanded ? 'Начисление по аренде' : '',
                        child: MaterialButton(
                          onPressed: () =>
                              AddRentAccrualPage.navigate(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: isExpanded ? 20 : 0,
                          ),
                          minWidth: 50,
                          height: 50,
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.building2,
                                size: 20,
                                color: Colors.white,
                              ),
                              if (isExpanded) ...[
                                const Gap(10),
                                const Text(
                                  'Начисление по аренде',
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

                      /// КНОПКА ИМПОРТ
                      Tooltip(
                        message: !isExpanded ? 'Импорт' : '',
                        child: MaterialButton(
                          onPressed: () async {
                            if (isImportLoading) return;
                            await ref
                                .read(importControllerProvider.notifier)
                                .pickAndImport();
                          },

                          padding: EdgeInsets.symmetric(
                            horizontal: isExpanded ? 20 : 0,
                          ),
                          minWidth: !isExpanded ? 50 : null,
                          height: 50,
                          color: AppColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              if (isImportLoading)
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                const Icon(
                                  LucideIcons.import,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              if (isExpanded && !isImportLoading) ...[
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
