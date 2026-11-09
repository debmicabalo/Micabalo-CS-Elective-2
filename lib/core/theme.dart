import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // 1. Set the font globally for the entire app here
    fontFamily: GoogleFonts.inter().fontFamily, 
    scaffoldBackgroundColor: const Color(0xFFFAFAFA), 
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.light,
    ),
    // 2. Use standard TextTheme and TextStyle (Inter is automatically applied)
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAFAFA),
      foregroundColor: Colors.black,
      elevation: 0, 
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 26.0, 
        fontWeight: FontWeight.w800, 
        color: Colors.black,
        letterSpacing: -1.0, 
      ),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0.0, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        side: BorderSide(color: Color(0xFFEAEAEA), width: 1.0),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // 1. Set the font globally for the dark theme
    fontFamily: GoogleFonts.inter().fontFamily,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A), 
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.dark,
    ),
    // 2. Use standard TextTheme and TextStyle
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A0A0A),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 26.0, 
        fontWeight: FontWeight.w800, 
        color: Colors.white,
        letterSpacing: -1.0, 
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF141414),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        side: BorderSide(color: Color(0xFF2A2A2A), width: 1.0),
      ),
    ),
  );
}