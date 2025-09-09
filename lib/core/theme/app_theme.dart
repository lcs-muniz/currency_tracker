import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF8A1538), // Bordô
    scaffoldBackgroundColor: const Color(0xFFFFFFFF), // Branco
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF006341)), // Verde
      bodyMedium: TextStyle(color: Color(0xFF006341)),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF8A1538), // Bordô
      secondary: Color(0xFF006341), // Verde
      background: Color(0xFFFFFFFF), // Branco
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.black,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF8A1538), // Bordô
    scaffoldBackgroundColor: const Color(0xFF006341), // Verde escuro
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFFFFFFF)), // Branco
      bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8A1538), // Bordô
      secondary: Color(0xFFFFFFFF), // Branco
      background: Color(0xFF006341), // Verde escuro
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.white,
    ),
  );

  static bool currentMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
