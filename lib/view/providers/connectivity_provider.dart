import 'dart:async';

import 'package:easy_fin/utils/connectivity_checker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Доступность интернета. Периодически обновляется, чтобы статус
/// у синхронизации менялся без перезапуска приложения.
final connectivityProvider =
    AsyncNotifierProvider<ConnectivityNotifier, bool>(ConnectivityNotifier.new);

class ConnectivityNotifier extends AsyncNotifier<bool> {
  static const _recheckInterval = Duration(seconds: 20);

  @override
  Future<bool> build() async {
    final timer = Timer.periodic(_recheckInterval, (_) {
      unawaited(refresh());
    });
    ref.onDispose(timer.cancel);
    return ConnectivityChecker.hasInternet();
  }

  Future<void> refresh() async {
    final online = await ConnectivityChecker.hasInternet();
    if (!ref.mounted) return;
    state = AsyncData(online);
  }
}
