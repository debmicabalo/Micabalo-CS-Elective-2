import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF6949F5);
  static const Color primaryDark = Color(0xFF8067FF);

  static const Color lightBackground = Color(0xFFF6F6F3);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF111116);
  static const Color lightBorder = Color(0xFFE3E3E0);

  static const Color darkBackground = Color(0xFF0D0D10);
  static const Color darkSurface = Color(0xFF151519);
  static const Color darkText = Color(0xFFF3F3F0);
  static const Color darkBorder = Color(0xFF29292F);

  static ThemeData get lightTheme {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      onPrimary: Colors.white,
      surface: lightSurface,
      onSurface: lightText,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: lightBackground,
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(
            color: lightBorder,
            width: 1,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: lightBackground,
        foregroundColor: lightText,
        centerTitle: false,
      ),
    );
  }

  static ThemeData get darkTheme {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: primaryDark,
      brightness: Brightness.dark,
    ).copyWith(
      primary: primaryDark,
      onPrimary: Colors.white,
      surface: darkSurface,
      onSurface: darkText,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: darkBackground,
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(
            color: darkBorder,
            width: 1,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: darkBackground,
        foregroundColor: darkText,
        centerTitle: false,
      ),
    );
  }
}