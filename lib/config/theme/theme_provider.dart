import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';

enum ThemeModeType { light, dark }

class ThemeNotifier extends StateNotifier<ThemeModeType> {
  ThemeNotifier() : super(ThemeModeType.light);

  void toggleTheme() {
    state = state == ThemeModeType.light
        ? ThemeModeType.dark
        : ThemeModeType.light;
  }

  void setTheme(ThemeModeType mode) {
    state = mode;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeModeType>(
  (ref) => ThemeNotifier(),
);

ThemeData getThemeFromMode(ThemeModeType mode) {
  switch (mode) {
    case ThemeModeType.dark:
      return AppTheme.darkTheme;
    case ThemeModeType.light:
      return AppTheme.lightTheme;
  }
}
