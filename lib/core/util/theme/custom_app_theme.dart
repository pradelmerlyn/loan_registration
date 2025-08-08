import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(25, 36, 116, 1.0),
        primary: const Color.fromRGBO(25, 36, 116, 1.0),
        primaryContainer: const Color.fromARGB(255, 234, 232, 232), // for background
        secondary: const Color.fromRGBO(47, 67, 218, 1.0), //buttons
        onSecondary: Colors.white,
        tertiary: Colors.black,
        onError: Colors.red,
        outline: const Color.fromRGBO(25, 36, 116, 1.0), //borders
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.oswald(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.poppins(),
        displaySmall: GoogleFonts.inter(),
      ),
      useMaterial3: true,
    );
  }
}
