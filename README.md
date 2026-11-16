# 🥦 Kurikulum Pemrograman Mobile Flutter & Proyek SayurHub (SMK RPL)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x%20Sound%20Null%20Safety-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Design System](https://img.shields.io/badge/Design-Material%203-2E7D32)](https://m3.material.io)
[![State Management](https://img.shields.io/badge/State-Provider%206.x-blue)](https://pub.dev/packages/provider)
[![Architecture](https://img.shields.io/badge/Architecture-Feature--First%20Clean%20Architecture-brightgreen)](#struktur-project)
[![Release](https://img.shields.io/badge/Release-v1.0.0-success.svg)](https://github.com/nasri1110/flutter-1/releases)
[![License](https://img.shields.io/badge/License-MIT-orange.svg)](sayur_hub/LICENSE)

Selamat datang di repositori resmi **Kurikulum Pembelajaran Pemrograman Mobile Berbasis Flutter & Proyek E-Commerce "SayurHub"**. Repositori ini dirancang khusus untuk siswa **SMK Rekayasa Perangkat Lunak (RPL) / Pengembangan Perangkat Lunak dan Gim (PPLG)** kelas XI/XII, mengadopsi pendekatan *Project-Based Learning (PjBL)* dari nol hingga aplikasi siap rilis di Google Play Store.

---

## 📂 Struktur Repositori

```
flutter-1/
├── docs/                           # Dokumentasi kurikulum lengkap (16.000+ baris)
│   ├── 00_RANCANGAN_KURIKULUM.md   # Master plan silabus 22 modul & SKKNI
│   └── modul/                      # 22 Dokumen modul pembelajaran terpadu
│       ├── 01_PENGENALAN_MOBILE_DAN_FLUTTER.md
│       ├── 02_INSTALASI_DAN_KONFIGURASI_FLUTTER.md
│       ├── ...
│       └── 22_CAPSTONE_PROJECT_SAYURHUB_FINAL.md
├── sayur_hub/                      # Proyek aplikasi Flutter SayurHub utuh
│   ├── android/                    # Konfigurasi Gradle, Keystore, & ProGuard
│   ├── assets/                     # Ikon aplikasi, logo splash, dan mock aset
│   ├── bin/                        # Utilitas CLI audit & demonstrasi
│   ├── lib/                        # Kode sumber (Feature-First Clean Architecture)
│   ├── scripts/                    # Skrip otomatisasi build rilis (APK & AAB)
│   ├── test/                       # Unit tests, Widget tests, dan Capstone UAT
│   ├── pubspec.yaml                # Manajemen dependensi
│   └── README.md                   # Dokumentasi teknis aplikasi SayurHub
├── .gitignore                      # Pengecualian build artifacts & prompt.md
└── README.md                       # Dokumentasi repositori utama ini
```

---

## 📚 Daftar 22 Modul Pembelajaran Terpadu

Setiap modul disusun secara sistematis memuat 12 seksi wajib (Identitas, Peta Konsep Mermaid, Teori Komprehensif, Pembahasan Kode, Persiapan, Langkah Praktikum, Analisis Mendalam, Latihan Mandiri 5 Teori + 3 Praktik + 2 Tantangan + 1 Studi Kasus Riil, Troubleshooting, Integrasi Antar-Modul, Rubrik Penilaian 4 Skala, dan Kesimpulan).

| Modul | Pokok Bahasan & Kompetensi | File Dokumentasi |
|:---:|---|---|
| **01** | Pengenalan Pemrograman Mobile & Flutter | [01_PENGENALAN_MOBILE_DAN_FLUTTER.md](docs/modul/01_PENGENALAN_MOBILE_DAN_FLUTTER.md) |
| **02** | Instalasi & Toolchain Lingkungan Flutter | [02_INSTALASI_DAN_KONFIGURASI_FLUTTER.md](docs/modul/02_INSTALASI_DAN_KONFIGURASI_FLUTTER.md) |
| **03** | Dasar Pemrograman Dart & Sound Null Safety | [03_DASAR_PEMROGRAMAN_DART_DAN_NULL_SAFETY.md](docs/modul/03_DASAR_PEMROGRAMAN_DART_DAN_NULL_SAFETY.md) |
| **04** | Percabangan, Perulangan & Algoritma Kontrol Alur | [04_PERCABANGAN_DAN_PERULANGAN_DART.md](docs/modul/04_PERCABANGAN_DAN_PERULANGAN_DART.md) |
| **05** | Function, Collection & Pemrosesan Fungsional | [05_FUNCTION_COLLECTION_DAN_PENGOLAHAN_DATA.md](docs/modul/05_FUNCTION_COLLECTION_DAN_PENGOLAHAN_DATA.md) |
| **06** | Object-Oriented Programming (OOP) & Data Modeling | [06_OBJECT_ORIENTED_PROGRAMMING_DART.md](docs/modul/06_OBJECT_ORIENTED_PROGRAMMING_DART.md) |
| **07** | Asynchronous Programming: Future & Stream Tracking | [07_ASYNCHRONOUS_PROGRAMMING_DART.md](docs/modul/07_ASYNCHRONOUS_PROGRAMMING_DART.md) |
| **08** | Anatomi Project, Aset Gambar, dan Tipografi Poppins | [08_STRUKTUR_PROJECT_FLUTTER_DAN_LIFECYCLE.md](docs/modul/08_STRUKTUR_PROJECT_FLUTTER_DAN_LIFECYCLE.md) |
| **09** | StatelessWidget vs StatefulWidget & Lifecycle State | [09_WIDGET_FUNDAMENTAL_DAN_LIFECYCLE.md](docs/modul/09_WIDGET_FUNDAMENTAL_DAN_LIFECYCLE.md) |
| **10** | Tata Letak Multidimensi & Desain Responsif (Grid 2-Kolom) | [10_TATA_LETAK_LAYOUT_DAN_RESPONSIVE_UI.md](docs/modul/10_TATA_LETAK_LAYOUT_DAN_RESPONSIVE_UI.md) |
| **11** | Material Design 3, Theming `#2E7D32` & Shell Navigasi | [11_DESAIN_ANTARMUKA_MATERIAL3_DAN_THEMING.md](docs/modul/11_DESAIN_ANTARMUKA_MATERIAL3_DAN_THEMING.md) |
| **12** | Navigasi Deklaratif Antarhalaman (GoRouter) | [12_NAVIGASI_ANTARHALAMAN_DAN_GOROUTER.md](docs/modul/12_NAVIGASI_ANTARHALAMAN_DAN_GOROUTER.md) |
| **13** | Input Form, Validasi Regex Handphone/Email & DatePicker | [13_INPUT_FORM_DAN_VALIDASI.md](docs/modul/13_INPUT_FORM_DAN_VALIDASI.md) |
| **14** | State Management Reaktif (Provider Pattern) | [14_STATE_MANAGEMENT_PROVIDER.md](docs/modul/14_STATE_MANAGEMENT_PROVIDER.md) |
| **15** | Penyimpanan Data Lokal Offline (SQLite & SharedPreferences)| [15_PENYIMPANAN_DATA_LOKAL_SQLITE.md](docs/modul/15_PENYIMPANAN_DATA_LOKAL_SQLITE.md) |
| **16** | Integrasi REST API, Dio Client, & Shimmer Loading | [16_INTEGRASI_REST_API_DAN_NETWORKING.md](docs/modul/16_INTEGRASI_REST_API_DAN_NETWORKING.md) |
| **17** | Autentikasi Pengguna, Hardware Keystore JWT & Route Guards| [17_AUTENTIKASI_DAN_KEAMANAN_DATA.md](docs/modul/17_AUTENTIKASI_DAN_KEAMANAN_DATA.md) |
| **18** | Arsitektur Enterprise: Feature-First Clean Architecture | [18_ARSITEKTUR_FEATURE_FIRST_CLEAN_ARCHITECTURE.md](docs/modul/18_ARSITEKTUR_FEATURE_FIRST_CLEAN_ARCHITECTURE.md) |
| **19** | Fitur Hardware Kamera & Infinite Scroll Pagination | [19_FITUR_LANJUTAN_KAMERA_PAGINATION.md](docs/modul/19_FITUR_LANJUTAN_KAMERA_PAGINATION.md) |
| **20** | Debugging, Testing (Unit, Widget, AAA) & DevTools | [20_DEBUGGING_TESTING_DAN_DEVTOOLS.md](docs/modul/20_DEBUGGING_TESTING_DAN_DEVTOOLS.md) |
| **21** | Persiapan Rilis, Branding, Signing Keystore & AAB | [21_BUILD_DAN_DEPLOYMENT_PRODUKSI.md](docs/modul/21_BUILD_DAN_DEPLOYMENT_PRODUKSI.md) |
| **22** | **Capstone Project: SayurHub Final Integration & Portfolio**| [22_CAPSTONE_PROJECT_SAYURHUB_FINAL.md](docs/modul/22_CAPSTONE_PROJECT_SAYURHUB_FINAL.md) |

---

## 🚀 Panduan Memulai Cepat (Quick Start)

### 1. Masuk ke Direktori Proyek SayurHub
```bash
cd sayur_hub
```

### 2. Pasang Dependensi
```bash
flutter pub get
```

### 3. Jalankan Pengujian Kualitas (Testing Suite)
```bash
flutter test
```

### 4. Jalankan Simulasi CLI Capstone 20 Fitur
```bash
dart bin/modul_22_capstone_demo.dart
```

### 5. Jalankan Aplikasi
```bash
flutter run
```

---

## 📄 Lisensi
Seluruh kode sumber aplikasi SayurHub dan materi kurikulum didistribusikan di bawah lisensi terbuka [MIT License](sayur_hub/LICENSE).
Bebas digunakan dan dikembangkan untuk keperluan pendidikan maupun portofolio profesional siswa SMK RPL.
