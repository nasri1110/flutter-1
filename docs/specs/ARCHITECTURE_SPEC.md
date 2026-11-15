# SPESIFIKASI ARSITEKTUR SISTEM APLIKASI SAYURHUB (VERSI 1.0)

## 1. DESKRIPSI PRODUK
SayurHub adalah aplikasi mobile e-commerce grocery on-demand yang berfokus pada penjualan komoditas sayuran hijau, buah-buahan segar, dan rempah bumbu dapur langsung dari petani lokal ke konsumen perkotaan.

## 2. TARGET PLATFORM
- Sistem Operasi Utama: Android (Minimum SDK: Android 6.0 Marshmallow / API Level 23)
- Target SDK: Android 14 / API Level 34
- Kompatibilitas Masa Depan: iOS 13+

## 3. IDENTITAS BRAND & PANDUAN VISUAL AWAL
- Warna Primer (Brand Color): Fresh Forest Green (`#2E7D32`) - Melambangkan kesegaran alam, organik, dan kesehatan.
- Warna Sekunder: Fresh Orange Sunlight (`#FF9800`) - Digunakan untuk badge diskon dan promo panen.
- Warna Latar Belakang (Surface): Soft Light Mint (`#F8FAF8`).
- Tipografi: Poppins (Google Fonts) - Memberikan kesan ramah, modern, dan mudah dibaca oleh semua kalangan usia.

## 4. DAFTAR MODUL FITUR UTAMA (ROADMAP PENGEMBANGAN)
1. Modul 02: Inisialisasi Framework & Toolchain Setup.
2. Modul 03-07: Logika Bisnis Dart (Kalkulasi Diskon, Model Entitas Sayur, Service Async).
3. Modul 08-12: Komponen Antarmuka Pengguna & Navigasi Antarhalaman.
4. Modul 13-17: Formulir Pesanan, Keranjang Belanja, Database SQLite, & REST API.
5. Modul 18-22: Arsitektur Skala Besar, Fitur Kamera, QA Testing, & Rilis APK.

## 5. DIAGRAM STRUKTUR ARSITEKTUR DIREKTORI (TARGET MODUL 18)
```
sayur_hub/
├── android/
├── ios/
├── assets/
│   ├── icons/
│   ├── images/
│   └── fonts/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── network/
│   │   ├── theme/
│   │   └── utils/
│   ├── features/
│   │   ├── auth/
│   │   ├── cart/
│   │   ├── catalog/
│   │   ├── checkout/
│   │   ├── orders/
│   │   └── profile/
│   └── main.dart
└── pubspec.yaml
```
