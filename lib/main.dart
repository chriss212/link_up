import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme/theme_provider.dart'; // ThemeNotifier y ThemeModeType
import 'config/theme/app_theme.dart';      // AppTheme.lightTheme / darkTheme
import 'config/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider); // lee ThemeModeType del provider

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LinkUp',
      theme: AppTheme.lightTheme, // tema claro definido en app_theme.dart
      darkTheme: AppTheme.darkTheme, // tema oscuro definido en app_theme.dart
      themeMode: mode == ThemeModeType.dark
          ? ThemeMode.dark
          : ThemeMode.light, // conecta tu enum con ThemeMode real
      debugShowCheckedModeBanner: false,
      title: 'Tu App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode == ThemeModeType.light
          ? ThemeMode.light
          : ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
