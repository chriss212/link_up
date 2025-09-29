import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';

enum ThemeModeType { light, dark }

/// Notifier de Riverpod v3
class ThemeNotifier extends Notifier<ThemeModeType> {
  @override
  ThemeModeType build() => ThemeModeType.light;

  void toggleTheme() {
    state = state == ThemeModeType.light
        ? ThemeModeType.dark
        : ThemeModeType.light;
  }

  void setTheme(ThemeModeType mode) {
    state = mode;
  }
}

/// Provider para leer/escuchar el modo de tema
final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeModeType>(ThemeNotifier.new);

/// Helper para mapear tu enum a ThemeData
ThemeData getThemeFromMode(ThemeModeType mode) {
  switch (mode) {
    case ThemeModeType.dark:
      return AppTheme.darkTheme;
    case ThemeModeType.light:
      return AppTheme.lightTheme;
  }
}
