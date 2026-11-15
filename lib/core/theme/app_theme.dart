import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';

/// Konfigurasi global tema tampilan antarmuka aplikasi SayurHub
/// Menstandarisasi palet warna, tipografi Poppins, dan bentuk komponen Material 3
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentOrange,
        surface: AppColors.backgroundLight,
      ),
      // Menerapkan Tipografi Poppins Resmi ke Seluruh Aplikasi
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        bodyMedium: const TextStyle(
          color: AppColors.textDark,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentOrange,
        foregroundColor: Colors.white,
      ),
    );
  }
}
