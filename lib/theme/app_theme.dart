import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color pokemonRed = Color(0xFFE3350D);
  
  static const Color backgroundLight = Color(0xFFF4F6F8);
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);

  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFE0E0E0);
  static const Color textGreyLight = Color(0xFFAAAAAA);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      // 1. Apply the font to the entire Light theme
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: textDark),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: textGrey),
      ),
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: pokemonRed,
        primary: pokemonRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: pokemonRed,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black38,
        centerTitle: true,
        // 2. Lock the AppBar font
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22, 
          fontWeight: FontWeight.w900, // Made it extra bold for the title
          letterSpacing: 1.5, 
          color: Colors.white
        ),
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
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      // 3. Apply the font to the entire Dark theme
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: textLight),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: textGreyLight),
      ),
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: pokemonRed,
        primary: pokemonRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: pokemonRed,
        elevation: 0,
        centerTitle: true,
        // 4. Lock the Dark Mode AppBar font
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22, 
          fontWeight: FontWeight.w900, 
          letterSpacing: 1.5, 
          color: pokemonRed
        ),
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
    );
  }
}