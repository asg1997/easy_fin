import 'package:easy_fin/data/github_sync/github_sync_service.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_snack_bar.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/pages/documents_page.dart';
import 'package:easy_fin/view/pages/github_sync_settings_page.dart';
import 'package:easy_fin/view/pages/notes_page.dart';
import 'package:easy_fin/view/pages/reports_page.dart';
import 'package:easy_fin/view/pages/settings_page.dart';
import 'package:easy_fin/view/providers/connectivity_provider.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/providers/theme_mode_provider.dart';
import 'package:easy_fin/view/widgets/add_action_speed_dial.dart';
import 'package:easy_fin/view/widgets/app_keyboard_shortcuts.dart';
import 'package:easy_fin/view/widgets/github_sync_conflict_dialog.dart';
import 'package:easy_fin/view/widgets/import_state_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Главная страница навигации
class MainNavPage extends ConsumerStatefulWidget {
  const MainNavPage({super.key});

  @override
  ConsumerState<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends ConsumerState<MainNavPage> {
  bool isExpanded = true;
  int currentIndex = 0;
  bool _isStartupSyncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runStartupSync());
  }

  Future<void> _runStartupSync() async {
    setState(() => _isStartupSyncing = true);
    try {
      final result =
          await ref.read(githubSyncProvider.notifier).downloadOnStartup();

      if (!mounted) return;

      switch (result) {
        case SyncStartupNeedsUserChoice(
            :final localManifest,
            :final remoteManifest,
          ):
          await showGithubSyncConflictDialog(
            context,
            ref,
            localManifest: localManifest,
            remoteManifest: remoteManifest,
          );
        case SyncStartupError(:final message):
          AppSnackBar.showError(context, message);
        case SyncStartupDownloaded():
          AppSnackBar.showMessage(context, 'Данные скачаны с GitHub');
        case SyncStartupShouldDownload():
          break;
        case SyncStartupSkipped() ||
              SyncStartupUpToDate() ||
              SyncStartupOffline():
          break;
      }
    } finally {
      if (mounted) setState(() => _isStartupSyncing = false);
    }
  }

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

    return AppKeyboardShortcuts(
      child: ImportStateListener(
        child: Stack(
        children: [
          Scaffold(
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
                              title: 'Заметки',
                              icon: LucideIcons.stickyNote,
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
                    _ThemeToggle(
                      isExpanded: isExpanded,
                      isDarkMode: isDarkMode,
                      onToggle: () =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),
                    const Gap(12),
                    _SyncButton(isExpanded: isExpanded),
                    const Gap(20),
                  ],
                ),
              ),
            ),
            Expanded(
              child: switch (currentIndex) {
                0 => const ReportsPage(),
                1 => const DocumentsPage(),
                2 => const NotesPage(),
                3 => const SettingsPage(),
                _ => Container(),
              },
            ),
          ],
        ),
          ),
          if (_isStartupSyncing)
            ColoredBox(
              color: Colors.black.withValues(alpha: 0.35),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const Gap(16),
                        Text(
                          'Загрузка данных…',
                          style: TextStyle(color: colors.primaryText),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
        ),
      ),
    );
  }
}

class _SyncButton extends ConsumerWidget {
  const _SyncButton({required this.isExpanded});

  final bool isExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(githubSyncProvider);
    final isBusy = syncState is GithubSyncInProgress;
    final config = ref.watch(githubSyncConfigProvider).value;
    final dirtyAsync = ref.watch(githubSyncDirtyProvider);
    final connectivityAsync = ref.watch(connectivityProvider);
    final isOnline = connectivityAsync.value ?? true;
    final isDirty = dirtyAsync.value ?? false;
    final isDirtyLoaded = dirtyAsync.hasValue;
    final isSyncConfigured = config?.isConfigured == true;
    final showOfflineMessage = isSyncConfigured && !isBusy && !isOnline;
    final showDirtyMessage = isSyncConfigured &&
        isDirtyLoaded &&
        isDirty &&
        !isBusy &&
        isOnline;
    final showSyncedMessage = isSyncConfigured &&
        isDirtyLoaded &&
        !isDirty &&
        !isBusy &&
        isOnline;

    Future<void> onSync() async {
      await ref.read(connectivityProvider.notifier).refresh();
      final online = ref.read(connectivityProvider).value ?? false;
      if (!online) {
        if (!context.mounted) return;
        AppSnackBar.showError(context, 'Подключение отсутствует');
        return;
      }

      final config = ref.read(githubSyncConfigProvider).value;
      if (config == null || !config.isConfigured) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Сначала настройте GitHub: Настройки → Синхронизация',
            ),
            action: SnackBarAction(
              label: 'Настроить',
              onPressed: () => GithubSyncSettingsPage.navigate(context),
            ),
          ),
        );
        return;
      }

      final token =
          await ref.read(githubSyncConfigStorageProvider).loadToken();
      if (token == null || token.isEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Укажите GitHub-токен в настройках синхронизации',
            ),
            action: SnackBarAction(
              label: 'Настроить',
              onPressed: () => GithubSyncSettingsPage.navigate(context),
            ),
          ),
        );
        return;
      }

      try {
        await ref.read(githubSyncProvider.notifier).upload();
        if (!context.mounted) return;
        AppSnackBar.showMessage(context, 'Данные отправлены на GitHub');
      } on RemoteNewerOnUploadException {
        if (!context.mounted) return;
        AppSnackBar.showError(
          context,
          'На сервере новее. Откройте настройки синхронизации.',
        );
      } on Object catch (_) {
        if (!context.mounted) return;
        final syncState = ref.read(githubSyncProvider);
        if (syncState is GithubSyncError) {
          AppSnackBar.showError(context, syncState.message);
        }
      }
    }

    final icon = isBusy
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Icon(
            showOfflineMessage ? LucideIcons.cloudOff : LucideIcons.cloudUpload,
            size: 20,
            color: Colors.white,
          );

    String collapsedTooltip() {
      if (showOfflineMessage) {
        return 'Синхронизировать — подключение отсутствует';
      }
      if (showDirtyMessage) {
        return 'Синхронизировать — необходима синхронизация';
      }
      if (showSyncedMessage) {
        return 'Синхронизировать — всё синхронизировано';
      }
      return 'Синхронизировать';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isExpanded ? 20 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: !isExpanded ? collapsedTooltip() : '',
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Material(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    onTap: isBusy ? null : onSync,
                    borderRadius: BorderRadius.circular(25),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          icon,
                          if (isExpanded) ...[
                            const Gap(10),
                            const Text(
                              'Синхронизировать',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isExpanded && (showDirtyMessage || showOfflineMessage))
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: showOfflineMessage
                            ? Colors.redAccent
                            : Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.purple,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isExpanded && showOfflineMessage) ...[
            const Gap(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.cloudOff,
                  size: 14,
                  color: colorsForOffline(context),
                ),
                const Gap(6),
                Text(
                  'Подключение отсутствует',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorsForOffline(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (isExpanded && showDirtyMessage) ...[
            const Gap(6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.circleAlert,
                  size: 14,
                  color: Colors.orange,
                ),
                Gap(6),
                Text(
                  'Необходима синхронизация',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (isExpanded && showSyncedMessage) ...[
            const Gap(6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.circleCheck,
                  size: 14,
                  color: AppColors.green,
                ),
                Gap(6),
                Text(
                  'Все синхронизировано',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color colorsForOffline(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.redAccent.shade100
        : Colors.redAccent.shade700;
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
