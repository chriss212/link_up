import 'package:flutter/material.dart';
import 'package:link_up/config/theme/app_colors.dart';

class AppTheme {
  final Color seed = AppColors.orange;

  ThemeData getTheme() => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    filled: true,
    fillColor: AppColors.surface,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: const StadiumBorder()),
  ),
  
  );


}