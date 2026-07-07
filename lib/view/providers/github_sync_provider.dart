import 'package:easy_fin/data/github_sync/github_api_client.dart';
import 'package:easy_fin/data/github_sync/github_sync_config_storage.dart';
import 'package:easy_fin/data/github_sync/github_sync_service.dart';
import 'package:easy_fin/data/github_sync/models/github_sync_config.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_charts_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_report_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_by_base_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_monthly_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/providers/renters_list_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final githubApiClientProvider = Provider<GithubApiClient>((ref) {
  return GithubApiClient();
});

final githubSyncConfigStorageProvider = Provider<GithubSyncConfigStorage>((ref) {
  return GithubSyncConfigStorage();
});

final githubSyncServiceProvider = Provider<GithubSyncService>((ref) {
  return GithubSyncService(
    apiClient: ref.watch(githubApiClientProvider),
    configStorage: ref.watch(githubSyncConfigStorageProvider),
  );
});

final githubSyncConfigProvider =
    AsyncNotifierProvider<GithubSyncConfigNotifier, GithubSyncConfig>(
  GithubSyncConfigNotifier.new,
);

class GithubSyncConfigNotifier extends AsyncNotifier<GithubSyncConfig> {
  @override
  Future<GithubSyncConfig> build() async {
    return ref.read(githubSyncConfigStorageProvider).loadConfig();
  }

  Future<void> save(GithubSyncConfig config, {String? token}) async {
    await ref.read(githubSyncConfigStorageProvider).saveConfig(config);
    if (token != null && token.isNotEmpty) {
      await ref.read(githubSyncConfigStorageProvider).saveToken(token);
    }
    state = AsyncData(config);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(await ref.read(githubSyncConfigStorageProvider).loadConfig());
  }
}

@immutable
sealed class GithubSyncState {}

class GithubSyncIdle extends GithubSyncState {}

class GithubSyncInProgress extends GithubSyncState {}

class GithubSyncSuccess extends GithubSyncState {
  GithubSyncSuccess({required this.direction, required this.at});

  final SyncDirection direction;
  final DateTime at;
}

class GithubSyncError extends GithubSyncState {
  GithubSyncError(this.message);

  final String message;
}

final githubSyncProvider =
    NotifierProvider<GithubSyncNotifier, GithubSyncState>(
  GithubSyncNotifier.new,
);

final githubSyncDirtyProvider = FutureProvider<bool>((ref) async {
  return ref.read(githubSyncServiceProvider).hasUnsyncedChanges();
});

class GithubSyncNotifier extends Notifier<GithubSyncState> {
  @override
  GithubSyncState build() => GithubSyncIdle();

  Future<SyncStartupResult> downloadOnStartup() async {
    state = GithubSyncInProgress();
    try {
      final service = ref.read(githubSyncServiceProvider);
      final result = await service.evaluateStartupSync();

      if (result is SyncStartupShouldDownload) {
        await _closeDatabase();
        await service.forceDownload();
        await _reopenDatabase();
        state = GithubSyncSuccess(
          direction: SyncDirection.download,
          at: DateTime.now(),
        );
        return SyncStartupDownloaded();
      }

      state = GithubSyncIdle();
      return result;
    } catch (e) {
      await _reopenDatabase();
      state = GithubSyncError('$e');
      return SyncStartupError('$e');
    }
  }

  Future<void> upload({bool force = false}) async {
    state = GithubSyncInProgress();
    try {
      await _closeDatabase();
      await ref.read(githubSyncServiceProvider).upload(force: force);
      await _reopenDatabase();
      state = GithubSyncSuccess(
        direction: SyncDirection.upload,
        at: DateTime.now(),
      );
    } on RemoteNewerOnUploadException {
      await _reopenDatabase();
      state = GithubSyncError(
        'На сервере более новая версия. Сначала скачайте или загрузите принудительно.',
      );
      rethrow;
    } catch (e) {
      await _reopenDatabase();
      state = GithubSyncError('$e');
      rethrow;
    }
  }

  Future<void> forceDownload() async {
    state = GithubSyncInProgress();
    try {
      await _closeDatabase();
      await ref.read(githubSyncServiceProvider).forceDownload();
      await _reopenDatabase();
      state = GithubSyncSuccess(
        direction: SyncDirection.download,
        at: DateTime.now(),
      );
    } catch (e) {
      await _reopenDatabase();
      state = GithubSyncError('$e');
      rethrow;
    }
  }

  Future<String> testConnection(GithubSyncConfig config, String token) {
    return ref.read(githubSyncServiceProvider).testConnection(config, token);
  }

  Future<void> _closeDatabase() async {
    ref.invalidate(appDatabaseProvider);
    await Future<void>.delayed(Duration.zero);
  }

  Future<void> _reopenDatabase() async {
    ref.invalidate(appDatabaseProvider);
    ref.read(appDatabaseProvider);
    _invalidateAppDataProviders();
  }

  void _invalidateAppDataProviders() {
    ref
      ..invalidate(basesListProvider)
      ..invalidate(documentsListProvider)
      ..invalidate(rentersListProvider)
      ..invalidate(accountBalancesProvider)
      ..invalidate(expenseCategoriesReportProvider)
      ..invalidate(expenseCategoriesMonthlyProvider)
      ..invalidate(expenseCategoriesComparisonProvider)
      ..invalidate(expenseBasesReportProvider)
      ..invalidate(renterDebtsProvider)
      ..invalidate(renterDebtsMonthlyProvider)
      ..invalidate(renterDebtsByBaseProvider)
      ..invalidate(githubSyncDirtyProvider);
  }
}
