import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark }

const _prefsKey = 'app_theme_mode';

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, AppThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends AsyncNotifier<AppThemeMode> {
  @override
  Future<AppThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_prefsKey);
    if (value == 'dark') return AppThemeMode.dark;
    return AppThemeMode.light;
  }

  Future<void> setMode(AppThemeMode mode) async {
    state = AsyncData(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      mode == AppThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> toggle() async {
    final current = state.value ?? AppThemeMode.light;
    await setMode(
      current == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light,
    );
  }
}
