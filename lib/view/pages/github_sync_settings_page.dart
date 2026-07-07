import 'package:easy_fin/data/github_sync/github_repo_ref.dart';
import 'package:easy_fin/data/github_sync/github_sync_service.dart';
import 'package:easy_fin/data/github_sync/models/github_sync_config.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_snack_bar.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class GithubSyncSettingsPage extends ConsumerStatefulWidget {
  const GithubSyncSettingsPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const GithubSyncSettingsPage(),
      ),
    );
  }

  @override
  ConsumerState<GithubSyncSettingsPage> createState() =>
      _GithubSyncSettingsPageState();
}

class _GithubSyncSettingsPageState extends ConsumerState<GithubSyncSettingsPage> {
  final _ownerController = TextEditingController();
  final _repoController = TextEditingController();
  final _branchController = TextEditingController(text: 'main');
  final _tokenController = TextEditingController();

  bool _isEnabled = false;
  bool _isSaving = false;
  bool _isTesting = false;
  bool _isUploading = false;
  bool _tokenObscured = false;
  String? _loadedToken;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final config = await ref.read(githubSyncConfigStorageProvider).loadConfig();
    final token = await ref.read(githubSyncConfigStorageProvider).loadToken();
    if (!mounted) return;

    setState(() {
      _ownerController.text = config.owner;
      _repoController.text = config.repo;
      _branchController.text = config.branch;
      _isEnabled = config.isEnabled;
      _loadedToken = token;
      _tokenController.text = token ?? '';
    });
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _repoController.dispose();
    _branchController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  GithubSyncConfig _buildConfig() {
    final ref = GithubRepoRef.parse(
      owner: _ownerController.text,
      repo: _repoController.text,
    );

    return GithubSyncConfig(
      owner: ref.owner,
      repo: ref.repo,
      branch: _branchController.text.trim().isEmpty
          ? 'main'
          : _branchController.text.trim(),
      isEnabled: _isEnabled,
    );
  }

  void _applyNormalizedRepoFields(GithubSyncConfig config) {
    _ownerController.text = config.owner;
    _repoController.text = config.repo;
    _branchController.text = config.branch;
  }

  String? _validateConfig(GithubSyncConfig config) {
    if (config.owner.isEmpty) {
      return 'Укажите логин GitHub (владелец репозитория)';
    }
    if (config.repo.isEmpty) {
      return 'Укажите имя репозитория';
    }
    return null;
  }

  String? _tokenToSave() {
    final value = _tokenController.text.trim();
    if (value.isEmpty) return null;
    return value;
  }

  Future<void> _copyToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нечего копировать')),
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: token));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Токен скопирован')),
    );
  }

  Future<void> _saveSettings() async {
    final config = _buildConfig();
    final validationError = _validateConfig(config);
    if (validationError != null) {
      AppSnackBar.showError(context, validationError);
      return;
    }

    setState(() => _isSaving = true);
    try {
      final token = _tokenToSave();
      await ref.read(githubSyncConfigProvider.notifier).save(
            config,
            token: token,
          );
      if (!mounted) return;
      _applyNormalizedRepoFields(config);
      AppSnackBar.showMessage(context, 'Настройки сохранены');
      await _loadSettings();
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Ошибка сохранения: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _testConnection() async {
    final config = _buildConfig();
    final validationError = _validateConfig(config);
    if (validationError != null) {
      AppSnackBar.showError(context, validationError);
      return;
    }

    _applyNormalizedRepoFields(config);
    final token = _tokenToSave() ?? _loadedToken;
    if (token == null || token.isEmpty) {
      AppSnackBar.showError(context, 'Укажите токен GitHub');
      return;
    }

    setState(() => _isTesting = true);
    try {
      final message =
          await ref.read(githubSyncProvider.notifier).testConnection(
                config,
                token,
              );
      if (!mounted) return;
      AppSnackBar.showMessage(context, message);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Ошибка подключения: $e');
    } finally {
      if (mounted) setState(() => _isTesting = false);
    }
  }

  Future<void> _upload({bool force = false}) async {
    if (!force) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Синхронизировать?'),
          content: const Text(
            'Локальная база данных будет отправлена на GitHub. '
            'Перед сменой устройства обязательно нажмите эту кнопку.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Отправить'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    setState(() => _isUploading = true);
    try {
      await ref.read(githubSyncProvider.notifier).upload(force: force);
      if (!mounted) return;
      AppSnackBar.showMessage(context, 'Данные отправлены на GitHub');
      ref.invalidate(githubSyncDirtyProvider);
    } on RemoteNewerOnUploadException {
      if (!mounted) return;
      final forceUpload = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('На сервере новее'),
          content: const Text(
            'На GitHub более новая версия данных. '
            'Сначала скачайте её или загрузите локальную принудительно.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Всё равно загрузить'),
            ),
          ],
        ),
      );
      if (forceUpload == true) {
        await _upload(force: true);
      }
    } catch (_) {
      if (!mounted) return;
      final syncState = ref.read(githubSyncProvider);
      if (syncState is GithubSyncError) {
        AppSnackBar.showError(context, syncState.message);
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final syncState = ref.watch(githubSyncProvider);
    final dirtyAsync = ref.watch(githubSyncDirtyProvider);
    final isBusy = _isSaving ||
        _isTesting ||
        _isUploading ||
        syncState is GithubSyncInProgress;

    return Scaffold(
      body: TemplatePage(
        title: 'Синхронизация',
        hasBackButton: true,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                _buildInfoCard(colors),
                const Gap(24),
                _buildSectionTitle(
                  context,
                  title: 'Автосинхронизация',
                  subtitle:
                      'При запуске приложения скачивать данные с GitHub, '
                      'если на сервере версия новее',
                ),
                const Gap(12),
                _buildToggleCard(colors, isBusy),
                const Gap(28),
                _buildSectionTitle(
                  context,
                  title: 'Репозиторий GitHub',
                  subtitle:
                      'Приватный репозиторий, куда сохраняется копия базы данных',
                ),
                const Gap(12),
                _buildLabeledField(
                  label: 'Логин GitHub',
                  helper:
                      'Владелец репозитория — ваш логин или организация. '
                      'Не URL, только имя: ivanov',
                  controller: _ownerController,
                  hint: 'ivanov',
                  enabled: !isBusy,
                ),
                const Gap(16),
                _buildLabeledField(
                  label: 'Имя репозитория',
                  helper:
                      'Только имя repo или ссылка: '
                      'easy-fin-data или github.com/ivanov/easy-fin-data',
                  controller: _repoController,
                  hint: 'easy-fin-data',
                  enabled: !isBusy,
                ),
                const Gap(16),
                _buildLabeledField(
                  label: 'Ветка',
                  helper:
                      'Для пустого репозитория укажите main — '
                      'ветка создастся при первой синхронизации',
                  controller: _branchController,
                  hint: 'main',
                  enabled: !isBusy,
                ),
                const Gap(28),
                _buildSectionTitle(
                  context,
                  title: 'Токен доступа',
                  subtitle:
                      'Classic: Settings → Developer settings → '
                      'Personal access tokens → Tokens (classic), право repo. '
                      'Fine-grained (github_pat_): выберите репозиторий '
                      'и права Contents (Read and write).',
                ),
                const Gap(12),
                _buildLabeledField(
                  label: 'Токен',
                  helper: 'Начинается с ghp_ или github_pat_',
                  controller: _tokenController,
                  hint: 'вставьте токен сюда',
                  enabled: !isBusy,
                  obscureText: _tokenObscured,
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Копировать',
                        onPressed: isBusy ? null : _copyToken,
                        icon: Icon(
                          LucideIcons.copy,
                          size: 18,
                          color: colors.secondaryText,
                        ),
                      ),
                      IconButton(
                        tooltip: _tokenObscured ? 'Показать' : 'Скрыть',
                        onPressed: isBusy
                            ? null
                            : () => setState(
                                  () => _tokenObscured = !_tokenObscured,
                                ),
                        icon: Icon(
                          _tokenObscured ? LucideIcons.eye : LucideIcons.eyeOff,
                          size: 18,
                          color: colors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                dirtyAsync.when(
                  data: (isDirty) {
                    if (!isDirty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.circleAlert,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              'Есть несинхронизированные изменения',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                if (syncState is GithubSyncSuccess) ...[
                  Text(
                    'Последняя операция: '
                    '${syncState.direction == SyncDirection.upload ? 'отправка' : 'скачивание'} '
                    '${DateFormat('dd.MM.yyyy HH:mm').format(syncState.at)}',
                    style: filterFieldHintTextStyleOf(context),
                  ),
                  const Gap(16),
                ],
                if (syncState is GithubSyncError) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          syncState.message,
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: syncState.message),
                          );
                        },
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Копировать'),
                      ),
                    ],
                  ),
                  const Gap(16),
                ],
                _buildSectionTitle(
                  context,
                  title: 'Действия',
                  subtitle:
                      'Сначала сохраните настройки и проверьте подключение. '
                      '«Синхронизировать» отправляет данные на GitHub.',
                ),
                const Gap(12),
                _buildPrimaryButton(
                  label: 'Сохранить',
                  icon: LucideIcons.save,
                  onPressed: isBusy ? null : _saveSettings,
                  isLoading: _isSaving,
                ),
                const Gap(12),
                _buildSecondaryButton(
                  label: 'Проверить подключение',
                  icon: LucideIcons.wifi,
                  onPressed: isBusy ? null : _testConnection,
                  isLoading: _isTesting,
                ),
                const Gap(12),
                _buildPrimaryButton(
                  label: 'Синхронизировать',
                  icon: LucideIcons.cloudUpload,
                  onPressed: isBusy ? null : _upload,
                  isLoading: _isUploading,
                ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(AppThemeColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.info, size: 18, color: AppColors.purple),
              const Gap(8),
              Text(
                'Как настроить',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.primaryText,
                ),
              ),
            ],
          ),
          const Gap(12),
          _buildSetupStep('1', 'Создайте приватный репозиторий на GitHub'),
          const Gap(8),
          _buildSetupStep('2', 'Создайте токен с правом repo'),
          const Gap(8),
          _buildSetupStep('3', 'Заполните поля ниже и нажмите «Сохранить»'),
          const Gap(8),
          _buildSetupStep('4', 'Нажмите «Проверить подключение»'),
        ],
      ),
    );
  }

  Widget _buildSetupStep(String number, String text) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.secondaryText,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: filterFieldHintTextStyleOf(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colors.primaryText,
          ),
        ),
        const Gap(4),
        Text(
          subtitle,
          style: filterFieldHintTextStyleOf(context),
        ),
      ],
    );
  }

  Widget _buildToggleCard(AppThemeColors colors, bool isBusy) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Скачивать при запуске',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.primaryText,
              ),
            ),
          ),
          Switch(
            value: _isEnabled,
            onChanged: isBusy
                ? null
                : (value) => setState(() => _isEnabled = value),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration() {
    final colors = context.appColors;

    return InputDecoration(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: filterFieldHorizontalPadding,
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      height: filterFieldHeight,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        color: AppColors.purple,
        disabledColor: AppColors.purple.withValues(alpha: 0.35),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: Colors.white),
                  const Gap(8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    final colors = context.appColors;

    return SizedBox(
      width: double.infinity,
      height: filterFieldHeight,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        elevation: 0,
        color: colors.surface,
        disabledColor: colors.surface.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(color: AppColors.purple),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.purple,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: AppColors.purple),
                  const Gap(8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.purple,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required String helper,
    required TextEditingController controller,
    required String hint,
    required bool enabled,
    bool obscureText = false,
    Widget? suffix,
  }) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.primaryText,
          ),
        ),
        const Gap(4),
        Text(
          helper,
          style: filterFieldHintTextStyleOf(context),
        ),
        const Gap(8),
        SizedBox(
          height: filterFieldHeight,
          child: TextField(
            controller: controller,
            enabled: enabled,
            obscureText: obscureText,
            enableInteractiveSelection: true,
            style: filterFieldTextStyle.copyWith(color: colors.primaryText),
            decoration: _fieldDecoration().copyWith(
              hintText: hint,
              hintStyle: filterFieldHintTextStyleOf(context),
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}
