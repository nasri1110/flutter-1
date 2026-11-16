import 'package:flutter/material.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';

/// Halaman pembuka perdana aplikasi SayurHub
/// Memverifikasi bahwa antarmuka berhasil di-render oleh Flutter Engine
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'SayurHub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ikon Branding Utama
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    size: 54,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 24),

                // Judul Aplikasi
                const Text(
                  'Sayur & Buah Segar Tiap Hari',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Deskripsi Singkat
                const Text(
                  'Langsung dipetik dari petani mitra lokal. Belanja pangan sehat kini lebih mudah dan higienis.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Badge Indikator Status Kesiapan Lingkungan
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primaryGreen,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Toolchain & Engine Siap (Modul 02 Selesai)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
