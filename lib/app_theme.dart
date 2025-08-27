// app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'values/values.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.blueSky,
      secondary: AppColors.greenEnergy,
      surface: AppColors.surface,
      error: AppColors.errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
    ),
    textTheme: _textTheme,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.blueSky,
      titleTextStyle: GoogleFonts.orbitron(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      buttonColor: AppColors.yellowEnergy,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.yellowEnergy,
        foregroundColor: Colors.black,
        textStyle: GoogleFonts.rajdhani(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );

  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.orbitron(
      fontSize: 48,
      fontWeight: FontWeight.w900,
      color: AppColors.blueSky,
    ),
    displayMedium: GoogleFonts.orbitron(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.blueSky,
    ),
    headlineMedium: GoogleFonts.rajdhani(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.greenEnergy,
    ),
    bodyLarge: GoogleFonts.rajdhani(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),
    bodyMedium: GoogleFonts.rajdhani(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.grey700,
    ),
    labelLarge: GoogleFonts.bungee(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColors.yellowEnergy,
    ),
  );
}
