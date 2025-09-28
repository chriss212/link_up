import 'package:flutter/material.dart';
import 'package:link_up/config/router/app_router.dart';
import 'package:link_up/config/theme/app_colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LinkUp',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange,),
      ),
      routerConfig: appRouter,
    );
  }
}
