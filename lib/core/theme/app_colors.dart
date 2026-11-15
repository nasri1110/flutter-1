import 'package:flutter/material.dart';

/// Kelas penyedia palet warna resmi aplikasi SayurHub
/// Menjamin seluruh tampilan memiliki warna yang konsisten sesuai standar UI/UX
class AppColors {
  // Mencegah instansiasi kelas utility
  AppColors._();

  /// Warna Primer: Hijau Daun Organik Segar
  static const Color primaryGreen = Color(0xFF2E7D32);

  /// Warna Sekunder: Oranye Sinar Matahari untuk badge promo & diskon
  static const Color accentOrange = Color(0xFFFF9800);

  /// Warna Latar Belakang: Putih Mint Lembut
  static const Color backgroundLight = Color(0xFFF8FAF8);

  /// Warna Teks Utama: Abu-abu Gelap Pekat (Keterbacaan tinggi)
  static const Color textDark = Color(0xFF1E293B);

  /// Warna Teks Sekunder: Abu-abu Netral
  static const Color textMuted = Color(0xFF64748B);
}
