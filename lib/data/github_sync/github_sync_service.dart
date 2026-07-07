import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:easy_fin/data/github_sync/github_api_client.dart';
import 'package:easy_fin/data/github_sync/github_sync_config_storage.dart';
import 'package:easy_fin/data/github_sync/models/github_sync_config.dart';
import 'package:easy_fin/data/github_sync/models/sync_manifest.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/utils/database_path.dart';
import 'package:sqlite3/sqlite3.dart';

const remoteDatabasePath = 'data/easy_fin.sqlite.gz';
const remoteManifestPath = 'sync_manifest.json';

enum SyncDirection { download, upload }

sealed class SyncStartupResult {}

class SyncStartupSkipped extends SyncStartupResult {}

class SyncStartupUpToDate extends SyncStartupResult {}

class SyncStartupShouldDownload extends SyncStartupResult {
  SyncStartupShouldDownload(this.remoteManifest);

  final SyncManifest remoteManifest;
}

class SyncStartupDownloaded extends SyncStartupResult {}

class SyncStartupNeedsUserChoice extends SyncStartupResult {
  SyncStartupNeedsUserChoice({
    required this.localManifest,
    required this.remoteManifest,
  });

  final SyncManifest? localManifest;
  final SyncManifest remoteManifest;
}

class SyncStartupError extends SyncStartupResult {
  SyncStartupError(this.message);

  final String message;
}

class RemoteNewerOnUploadException implements Exception {
  RemoteNewerOnUploadException(this.remoteManifest);

  final SyncManifest remoteManifest;

  @override
  String toString() => 'На сервере более новая версия данных';
}

class SchemaVersionMismatchException implements Exception {
  SchemaVersionMismatchException({
    required this.remoteVersion,
    required this.localVersion,
  });

  final int remoteVersion;
  final int localVersion;

  @override
  String toString() =>
      'Версия схемы на сервере ($remoteVersion) новее локальной ($localVersion). '
      'Обновите приложение.';
}

class GithubSyncService {
  GithubSyncService({
    required GithubApiClient apiClient,
    required GithubSyncConfigStorage configStorage,
    int schemaVersion = AppDatabase.currentSchemaVersion,
  })  : _apiClient = apiClient,
        _configStorage = configStorage,
        _schemaVersion = schemaVersion;

  final GithubApiClient _apiClient;
  final GithubSyncConfigStorage _configStorage;
  final int _schemaVersion;

  Future<bool> hasUnsyncedChanges() async {
    final localManifest = await _configStorage.loadLocalManifest();
    if (localManifest == null) return false;
    final checksum = await _sha256OfDatabaseFile();
    return checksum != localManifest.checksumSha256;
  }

  Future<SyncStartupResult> evaluateStartupSync() async {
    final config = await _configStorage.loadConfig();
    if (!config.isEnabled || !config.isConfigured) {
      return SyncStartupSkipped();
    }

    final token = await _configStorage.loadToken();
    if (token == null || token.isEmpty) {
      return SyncStartupSkipped();
    }

    try {
      final localManifest = await _configStorage.loadLocalManifest();
      final isDirty = await _isDirty(localManifest);
      final remoteManifest = await _fetchRemoteManifest(config, token);

      if (remoteManifest == null) {
        return SyncStartupSkipped();
      }

      if (remoteManifest.schemaVersion > _schemaVersion) {
        return SyncStartupError(
          'На сервере данные из более новой версии приложения. '
          'Обновите Easy Fin.',
        );
      }

      final comparison = compareManifests(localManifest, remoteManifest);
      final isRemoteNewer = comparison == ManifestComparison.remoteNewer;
      final isLocalNewer = comparison == ManifestComparison.localNewer;

      if (isDirty || isLocalNewer) {
        return SyncStartupNeedsUserChoice(
          localManifest: localManifest,
          remoteManifest: remoteManifest,
        );
      }

      if (isRemoteNewer) {
        return SyncStartupShouldDownload(remoteManifest);
      }

      return SyncStartupUpToDate();
    } on SocketException {
      return SyncStartupError('Нет подключения к интернету');
    } on GitHubApiException catch (e) {
      final config = await _configStorage.loadConfig();
      return SyncStartupError(_mapApiError(e, branch: config.branch));
    } catch (e) {
      return SyncStartupError('Ошибка синхронизации: $e');
    }
  }

  Future<void> forceDownload() async {
    final config = await _requireConfigured();
    final token = await _requireToken();
    final remoteManifest = await _fetchRemoteManifest(config, token);
    if (remoteManifest == null) {
      throw StateError('На сервере ещё нет данных для скачивания');
    }
    if (remoteManifest.schemaVersion > _schemaVersion) {
      throw SchemaVersionMismatchException(
        remoteVersion: remoteManifest.schemaVersion,
        localVersion: _schemaVersion,
      );
    }
    await _downloadDatabase(config, token, remoteManifest);
  }

  Future<void> upload({bool force = false}) async {
    final config = await _requireConfigured();
    final token = await _requireToken();

    try {
      final localManifest = await _configStorage.loadLocalManifest();
      final remoteManifest = await _fetchRemoteManifest(config, token);

      if (!force &&
          remoteManifest != null &&
          remoteManifest.updatedAt.isAfter(
            localManifest?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
          )) {
        throw RemoteNewerOnUploadException(remoteManifest);
      }

      if (remoteManifest != null &&
          remoteManifest.schemaVersion > _schemaVersion) {
        throw SchemaVersionMismatchException(
          remoteVersion: remoteManifest.schemaVersion,
          localVersion: _schemaVersion,
        );
      }

      final dbFile = await getDatabaseFile();
      if (!await dbFile.exists()) {
        throw StateError('Локальная база данных не найдена');
      }

      await _ensureBranchExists(config, token);

      await _checkpointDatabase(dbFile.path);

      final dbBytes = await dbFile.readAsBytes();
      final checksum = _sha256OfBytes(dbBytes);
      final compressed = gzip.encode(dbBytes);
      final deviceId = await _configStorage.getOrCreateDeviceId();
      final now = DateTime.now().toUtc();

      await _putFileWithRetry(
        config: config,
        token: token,
        path: remoteDatabasePath,
        bytes: compressed,
        message: 'sync: upload database',
        existingSha: await _getRemoteSha(config, token, remoteDatabasePath),
      );

      final manifest = SyncManifest(
        updatedAt: now,
        schemaVersion: _schemaVersion,
        deviceId: deviceId,
        checksumSha256: checksum,
        sizeBytes: dbBytes.length,
      );

      await _putFileWithRetry(
        config: config,
        token: token,
        path: remoteManifestPath,
        bytes: utf8.encode(
          const JsonEncoder.withIndent('  ').convert(manifest.toJson()),
        ),
        message: 'sync: upload manifest',
        existingSha: await _getRemoteSha(config, token, remoteManifestPath),
      );

      await _configStorage.saveLocalManifest(manifest);
    } on GitHubApiException catch (e) {
      throw StateError(_mapApiError(e, branch: config.branch));
    }
  }

  Future<String> testConnection(GithubSyncConfig config, String token) async {
    try {
      return await _apiClient.testConnection(
        owner: config.owner,
        repo: config.repo,
        branch: config.branch,
        token: token,
      );
    } on GitHubApiException catch (e) {
      throw StateError(_mapApiError(e, branch: config.branch));
    }
  }

  Future<SyncManifest?> _fetchRemoteManifest(
    GithubSyncConfig config,
    String token,
  ) async {
    final file = await _apiClient.getFile(
      owner: config.owner,
      repo: config.repo,
      path: remoteManifestPath,
      branch: config.branch,
      token: token,
    );
    if (file == null) return null;

    final json = jsonDecode(utf8.decode(file.bytes)) as Map<String, dynamic>;
    return SyncManifest.fromJson(json);
  }

  Future<void> _downloadDatabase(
    GithubSyncConfig config,
    String token,
    SyncManifest remoteManifest,
  ) async {
    final remoteFile = await _apiClient.getFile(
      owner: config.owner,
      repo: config.repo,
      path: remoteDatabasePath,
      branch: config.branch,
      token: token,
    );
    if (remoteFile == null) {
      throw StateError('Файл базы данных не найден на сервере');
    }

    final dbBytes = gzip.decode(remoteFile.bytes);
    final checksum = _sha256OfBytes(dbBytes);
    if (checksum != remoteManifest.checksumSha256) {
      throw StateError(
        'Контрольная сумма не совпала после скачивания. '
        'Локальная база не изменена.',
      );
    }

    final dbFile = await getDatabaseFile();
    final tempFile = File('${dbFile.path}.tmp');
    await tempFile.writeAsBytes(dbBytes, flush: true);
    await _removeWalFiles(dbFile.path);
    await tempFile.rename(dbFile.path);

    await _configStorage.saveLocalManifest(remoteManifest);
  }

  Future<bool> _isDirty(SyncManifest? localManifest) async {
    if (localManifest == null) return false;
    final checksum = await _sha256OfDatabaseFile();
    return checksum != localManifest.checksumSha256;
  }

  Future<String> _sha256OfDatabaseFile() async {
    final dbFile = await getDatabaseFile();
    if (!await dbFile.exists()) return '';
    final bytes = await dbFile.readAsBytes();
    return _sha256OfBytes(bytes);
  }

  String _sha256OfBytes(List<int> bytes) {
    return sha256.convert(bytes).toString();
  }

  Future<void> _checkpointDatabase(String dbPath) async {
    final db = sqlite3.open(dbPath);
    try {
      db.execute('PRAGMA wal_checkpoint(FULL);');
    } finally {
      db.close();
    }
    await _removeWalFiles(dbPath);
  }

  Future<void> _removeWalFiles(String dbPath) async {
    for (final suffix in ['-wal', '-shm']) {
      final file = File('$dbPath$suffix');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<String?> _getRemoteSha(
    GithubSyncConfig config,
    String token,
    String path,
  ) async {
    final file = await _apiClient.getFile(
      owner: config.owner,
      repo: config.repo,
      path: path,
      branch: config.branch,
      token: token,
    );
    return file?.sha;
  }

  Future<void> _ensureBranchExists(
    GithubSyncConfig config,
    String token,
  ) async {
    final exists = await _apiClient.branchExists(
      owner: config.owner,
      repo: config.repo,
      branch: config.branch,
      token: token,
    );
    if (exists) return;

    try {
      await _apiClient.initializeEmptyBranch(
        owner: config.owner,
        repo: config.repo,
        branch: config.branch,
        token: token,
      );
    } on GitHubApiException catch (e) {
      throw StateError(_mapApiError(e, branch: config.branch));
    }
  }

  Future<String> _putFileWithRetry({
    required GithubSyncConfig config,
    required String token,
    required String path,
    required List<int> bytes,
    required String message,
    String? existingSha,
  }) async {
    try {
      return await _apiClient.putFile(
        owner: config.owner,
        repo: config.repo,
        path: path,
        branch: config.branch,
        token: token,
        bytes: bytes,
        message: message,
        sha: existingSha,
      );
    } on GitHubApiException catch (e) {
      if (e.statusCode == 404) {
        await _ensureBranchExists(config, token);
        return _apiClient.putFile(
          owner: config.owner,
          repo: config.repo,
          path: path,
          branch: config.branch,
          token: token,
          bytes: bytes,
          message: message,
          sha: existingSha,
        );
      }
      if (e.statusCode != 409) rethrow;

      final latestSha = await _getRemoteSha(config, token, path);
      return _apiClient.putFile(
        owner: config.owner,
        repo: config.repo,
        path: path,
        branch: config.branch,
        token: token,
        bytes: bytes,
        message: message,
        sha: latestSha,
      );
    }
  }

  Future<GithubSyncConfig> _requireConfigured() async {
    final config = await _configStorage.loadConfig();
    if (!config.isConfigured) {
      throw StateError('Укажите owner и repository в настройках синхронизации');
    }
    return config;
  }

  Future<String> _requireToken() async {
    final token = await _configStorage.loadToken();
    if (token == null || token.isEmpty) {
      throw StateError('Укажите GitHub-токен в настройках синхронизации');
    }
    return token;
  }

  String _mapApiError(GitHubApiException e, {String? branch}) {
    if (e.body.isNotEmpty &&
        !e.body.startsWith('{') &&
        e.body.length < 200) {
      return e.body;
    }

    return switch (e.statusCode) {
      401 => 'Неверный токен. Проверьте настройки синхронизации.',
      403 => 'Нет доступа к репозиторию или превышен лимит запросов.',
      404 => branch != null
          ? 'Репозиторий или ветка «$branch» не найдены. '
              'Проверьте логин, имя репозитория и ветку. '
              'Для пустого репозитория укажите main.'
          : 'Репозиторий не найден. Проверьте логин и имя репозитория.',
      _ => 'Ошибка GitHub API (${e.statusCode})',
    };
  }
}
