import 'dart:convert';

import 'package:easy_fin/data/github_sync/models/github_sync_config.dart';
import 'package:easy_fin/data/github_sync/models/sync_manifest.dart';
import 'package:easy_fin/utils/database_path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _ownerKey = 'github_sync_owner';
const _repoKey = 'github_sync_repo';
const _branchKey = 'github_sync_branch';
const _enabledKey = 'github_sync_enabled';
const _tokenKey = 'github_sync_token';
const _deviceIdKey = 'device_id';

class GithubSyncConfigStorage {
  GithubSyncConfigStorage({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  Future<GithubSyncConfig> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return GithubSyncConfig(
      owner: prefs.getString(_ownerKey) ?? '',
      repo: prefs.getString(_repoKey) ?? '',
      branch: prefs.getString(_branchKey) ?? 'main',
      isEnabled: prefs.getBool(_enabledKey) ?? false,
    );
  }

  Future<void> saveConfig(GithubSyncConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ownerKey, config.owner);
    await prefs.setString(_repoKey, config.repo);
    await prefs.setString(_branchKey, config.branch);
    await prefs.setBool(_enabledKey, config.isEnabled);
  }

  Future<String?> loadToken() => _secureStorage.read(key: _tokenKey);

  Future<void> saveToken(String token) =>
      _secureStorage.write(key: _tokenKey, value: token);

  Future<void> deleteToken() => _secureStorage.delete(key: _tokenKey);

  Future<String> getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final deviceId = const Uuid().v4();
    await prefs.setString(_deviceIdKey, deviceId);
    return deviceId;
  }

  Future<SyncManifest?> loadLocalManifest() async {
    final file = await getLocalManifestFile();
    if (!await file.exists()) return null;

    final content = await file.readAsString();
    final json = jsonDecode(content) as Map<String, dynamic>;
    return SyncManifest.fromJson(json);
  }

  Future<void> saveLocalManifest(SyncManifest manifest) async {
    final file = await getLocalManifestFile();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(manifest.toJson()),
    );
  }
}
