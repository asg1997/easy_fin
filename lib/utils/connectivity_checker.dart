import 'dart:io';

/// Проверка реального доступа в интернет (DNS-запрос, не только Wi‑Fi/Ethernet).
class ConnectivityChecker {
  ConnectivityChecker._();

  static const _hosts = ['one.one.one.one', 'dns.google', 'github.com'];
  static const _timeout = Duration(seconds: 3);

  /// `true`, если хотя бы один хост резолвится.
  static Future<bool> hasInternet() async {
    for (final host in _hosts) {
      try {
        final result = await InternetAddress.lookup(host).timeout(_timeout);
        if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
          return true;
        }
      } on Object {
        // Пробуем следующий хост.
      }
    }
    return false;
  }
}
