import 'package:currency_tracker/core/di/injector.dart';
import 'package:currency_tracker/core/theme/theme_controller.dart';
import 'package:currency_tracker/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/theme/app_theme.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");

    print("✅ Arquivo .env carregado! Chave da API: ${dotenv.env['API_KEY']}");
  } catch (e) {
    print("❌ ERRO AO CARREGAR O ARQUIVO .env: $e");
  }

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
