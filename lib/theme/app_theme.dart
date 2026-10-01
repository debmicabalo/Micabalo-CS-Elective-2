import 'package:flutter/material.dart';

class AppTheme {
  static const Color pokemonRed = Color(0xFFE3350D);
  
  // Light Mode Colors
  static const Color backgroundLight = Color(0xFFF4F6F8);
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFE0E0E0);
  static const Color textGreyLight = Color(0xFFAAAAAA);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: pokemonRed,
        primary: pokemonRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: pokemonRed,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black38,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.5),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 6,
        shadowColor: Colors.black26,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Colors.black12, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textDark),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textGrey),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: pokemonRed,
        primary: pokemonRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark, // Darker app bar for dark mode
        foregroundColor: pokemonRed,     // Red text/icons instead
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: pokemonRed),
      ),
      cardTheme: const CardThemeData(
        color: cardDark,
        elevation: 4,
        shadowColor: Colors.black54,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textLight),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textGreyLight),
      ),
    );
  }
}