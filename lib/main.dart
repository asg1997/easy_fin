import 'package:easy_fin/utils/app_theme.dart';
import 'package:easy_fin/view/pages/main_nav_page.dart';
import 'package:easy_fin/view/providers/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru');
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode = themeModeAsync.value ?? AppThemeMode.light;

    return MaterialApp(
      title: 'Easy Fin',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ru'),
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode == AppThemeMode.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const MainNavPage(),
    );
  }
}
