import 'package:flutter/material.dart';

class AppTheme {
  final Color seed = const Color(0xFFEB7A36);

  ThemeData getTheme() => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF9F7F5),
    inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    filled: true,
    fillColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: const StadiumBorder()),
  ),
  
  );


}