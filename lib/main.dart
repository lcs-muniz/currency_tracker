import 'package:currency_tracker/core/di/injector.dart';
import 'package:currency_tracker/core/theme/theme_controller.dart';
import 'package:currency_tracker/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'core/theme/app_theme.dart';

Future<void> main() async {
  setupDependencyInjection();
  final themeController = injector.get<ThemeController>();
  
  runApp(
    Watch(
      (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Currency Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        home: const HomePage(),
      ),
    ),
  );
}
