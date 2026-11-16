# 🥦 SayurHub - Mobile E-Commerce Sayur & Buah Segar

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x%20Sound%20Null%20Safety-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Design System](https://img.shields.io/badge/Design-Material%203-2E7D32)](https://m3.material.io)
[![State Management](https://img.shields.io/badge/State-Provider%206.x-blue)](https://pub.dev/packages/provider)
[![Architecture](https://img.shields.io/badge/Architecture-Feature--First%20Clean%20Architecture-brightgreen)](#arsitektur-aplikasi)
[![Test Coverage](https://img.shields.io/badge/Tests-Unit%20%7C%20Widget%20%7C%20UAT-success)](https://flutter.dev/docs/testing)
[![License](https://img.shields.io/badge/License-MIT-orange.svg)](LICENSE)

> **Aplikasi Mobile E-Commerce Produksi Kelas Industri** yang dibangun dari nol hingga siap rilis melalui kurikulum terpadu 22 modul pembelajaran berstandar industri untuk siswa **SMK Rekayasa Perangkat Lunak (RPL)**.

---

## 📖 1. Tentang SayurHub

**SayurHub** adalah solusi digital berbasis mobile yang mempertemukan petani lokal dengan konsumen perkotaan secara langsung (*Farm-to-Table*). Melalui SayurHub, pelanggan dapat memesan sayuran hijau organik, buah-buahan segar, rempah-rempah, dan umbi-umbian berkualitas tinggi yang dipanen langsung pada hari pengiriman.

Aplikasi ini dirancang dengan prinsip **Offline-First Resilience**, **Hardware-Backed Security**, dan **Zero Bug Guarantee** menggunakan Sound Null Safety murni serta Feature-First Clean Architecture.

---

## ✨ 2. Matriks 20 Fitur Lengkap SayurHub

| No | Fitur Aplikasi | Modul | Komponen Teknis Utama |
|---|---|---|---|
| **01** | **Welcome & Onboarding Screen** | M02, M08 | `WelcomeScreen`, `AppTheme`, Google Fonts Poppins, Image Asset |
| **02** | **Material 3 Navigation Shell** | M11 | `NavigationBar` 4 tab (Beranda, Kategori, Riwayat, Profil) |
| **03** | **Responsive 2-Column Catalog Grid** | M10 | `GridView.builder`, `PromoBanner`, `LayoutBuilder` |
| **04** | **Shimmer Loading Skeleton** | M16 | `ProductCardShimmer`, `shimmer` package saat request asynchronous |
| **05** | **Dynamic Category Filtering** | M10, M11 | `CategoryPills`, pemfilteran katalog berdasarkan kategori realtime |
| **06** | **Product Detail Interactive View** | M12 | `ProductDetailScreen`, path parameter GoRouter (`/product/:id`) |
| **07** | **Real-Time Price & Quantity Counter**| M03, M09 | `PriceCalculator`, `QuantityCounterWidget`, `StatefulWidget` |
| **08** | **Tier Discount & Freshness Audit** | M04 | `InventoryManager`, algoritma diskon kuantitas & umur simpan |
| **09** | **Functional Collection Processing** | M05 | Higher-order methods: `.where()`, `.map()`, `.reduce()` |
| **10** | **OOP Strongly-Typed Domain Models** | M06 | `Product`, `CartItem`, `User`, `OrderStatus` (Immutability & factory) |
| **11** | **Asynchronous Order Tracking Stream**| M07 | `MockProductService`, `Stream<OrderStatus>`, live status timeline |
| **12** | **Declarative Routing & Route Guards** | M12, M17 | `GoRouter`, nested shell routes, `refreshListenable` auth guard |
| **13** | **Input Form & Regex Validation** | M13 | `TextFormField`, validasi regex HP/Email, DatePicker delivery |
| **14** | **Reactive Centralized Cart & Wishlist**| M14 | `CartProvider`, `WishlistProvider`, `MultiProvider`, `Consumer` |
| **15** | **Offline Relational Persistence** | M15 | `DatabaseHelper` (SQLite CRUD), `PreferencesHelper` |
| **16** | **Production HTTP Client & Interceptor**| M16 | `Dio`, `ApiClient`, base URL, timeout, global error handler |
| **17** | **JWT Authentication & Hardware Keystore**| M17 | `flutter_secure_storage`, `AuthProvider`, Bearer token interceptor |
| **18** | **Feature-First Clean Architecture** | M18 | Pemisahan layer Domain, Data, Presentation per fitur (SoC) |
| **19** | **Camera Hardware & Multipart Upload** | M19 | `image_picker`, upload foto profil & bukti bayar transfer bank |
| **20** | **Automated Testing & Production Build**| M20, M21 | Unit & Widget Tests, Keystore RSA 2048-bit, AAB & Split-ABI APK |

---

## 🏛️ 3. Arsitektur Aplikasi (Feature-First Clean Architecture)

SayurHub mengadopsi standar arsitektur industri **Feature-First Clean Architecture**:

```
sayur_hub/
├── android/                        # Konfigurasi native Android & Keystore
│   ├── app/build.gradle            # Gradle release build, R8 shrinker, splits ABI
│   ├── app/proguard-rules.pro      # Aturan ProGuard untuk SQLite & Keystore
│   └── key.properties.example      # Template kredensial signing
├── assets/                         # Aset gambar, ikon, dan tipografi
│   ├── icons/                      # App launcher icons & native splash logo
│   └── images/                     # Mock gambar katalog produk segar
├── bin/                            # Skrip CLI simulasi & audit interaktif
│   ├── modul_21_build_demo.dart    # Verifikasi kredensial rilis & audit Git
│   └── modul_22_capstone_demo.dart # Showcase 20 fitur interaktif CLI
├── lib/
│   ├── core/                       # Komponen global lintas fitur
│   │   ├── database/               # DatabaseHelper (SQLite CRUD persistence)
│   │   ├── exceptions/             # Custom domain exception classes
│   │   ├── mock/                   # Mock data katalog sayuran lokal
│   │   ├── models/                 # Pure data entities (Product, CartItem, User)
│   │   ├── network/                # ApiClient Dio dengan interceptor auth
│   │   ├── providers/              # CartProvider, WishlistProvider, AuthProvider
│   │   ├── routes/                 # AppRouter (GoRouter declarative & guards)
│   │   ├── services/               # ApiService, MockService, SecureStorage
│   │   ├── theme/                  # AppColors (#2E7D32) & AppTheme Material 3
│   │   └── utils/                  # PriceCalculator, InventoryManager
│   ├── features/                   # Modul terisolasi per fitur bisnis
│   │   ├── auth/                   # LoginScreen & autentikasi pengguna
│   │   ├── cart/                   # CartScreen & manajemen belanja offline
│   │   ├── catalog/                # Feature-First Clean Architecture
│   │   │   ├── data/               # Datasources, models, repository impl
│   │   │   ├── domain/             # Entities, repository interfaces, usecases
│   │   │   └── product_detail_screen.dart
│   │   ├── category/               # CategoriesScreen & pengelompokan produk
│   │   ├── checkout/               # CheckoutScreen & form validasi regex
│   │   ├── home/                   # HomeScreen & WelcomeScreen
│   │   ├── orders/                 # OrderHistoryScreen & pelacakan pesanan
│   │   ├── profile/                # ProfileScreen, ganti foto kamera, logout
│   │   └── main_navigation_shell.dart # M3 NavigationBar shell scaffolding
│   ├── shared/                     # Reusable UI widgets
│   │   └── widgets/                # ProductCard, Shimmer, Counter, Banner, Button
│   └── main.dart                   # Root entry point & MultiProvider initialization
├── scripts/
│   └── build_production.sh         # Pipeline build release otomatis (APK & AAB)
├── test/                           # Automated test suites
│   ├── unit/                       # Pengujian logika PriceCalculator & Inventory
│   ├── widget/                     # Pengujian komponen visual ProductCard & Counter
│   └── e2e/                        # End-to-End Capstone UAT testing suite
└── pubspec.yaml                    # Dependensi, aset, & konfigurasi rilis
```

---

## 🛠️ 4. Spesifikasi Teknologi & Dependensi

| Kategori | Teknologi / Pustaka | Versi | Peran dalam SayurHub |
|---|---|---|---|
| **Framework** | Flutter SDK | `^3.0.0` | UI toolkit cross-platform utama |
| **Language** | Dart SDK | `^3.0.0` | Bahasa pemrograman bertipe kuat dengan Sound Null Safety |
| **Theming** | Google Fonts | `^6.1.0` | Tipografi Poppins yang modern dan bersih |
| **Navigation**| GoRouter | `^14.0.0` | Routing deklaratif, deep-link, dan proteksi rute |
| **State** | Provider | `^6.1.2` | Pengelolaan state terpusat dan reaktif |
| **Database** | Sqflite & Path | `^2.3.2` | Database relasional SQLite offline di memori ponsel |
| **Storage** | SharedPreferences | `^2.2.2` | Penyimpanan key-value preferensi dan sesi onboarding |
| **Security** | FlutterSecureStorage | `^9.0.0` | Enkripsi token JWT berbasis Android Keystore / iOS Keychain |
| **Networking**| Dio | `^5.4.3+1`| Client HTTP tangguh dengan interceptor dan timeout |
| **Skeleton** | Shimmer | `^3.0.0` | Animasi shimmer skeleton saat proses loading katalog |
| **Hardware** | ImagePicker | `^1.1.1` | Akses kamera perangkat keras & galeri foto profil |
| **Branding** | Flutter Launcher Icons | `^0.13.1`| Generator ikon aplikasi otomatis untuk semua densitas layar |
| **Splash** | Flutter Native Splash | `^2.4.0` | Splash screen native untuk mengeliminasi blank startup flash |

---

## 🚀 5. Panduan Menjalankan Project (Getting Started)

### Prasyarat:
- Flutter SDK versi 3.19 ke atas terpasang (`flutter --version`).
- Java Development Kit (JDK 17 atau 11) terpasang (`java -version`).
- Android Studio / VS Code dengan ekstensi Flutter & Dart.

### Langkah Instalasi:

1. **Clone Repositori**:
   ```bash
   git clone https://github.com/smkrpl/sayurhub.git
   cd sayurhub/sayur_hub
   ```

2. **Unduh Dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan Verifikasi Sintaks & Unit Tests**:
   ```bash
   dart analyze
   flutter test
   ```

4. **Jalankan Simulasi CLI Capstone**:
   ```bash
   dart bin/modul_22_capstone_demo.dart
   ```

5. **Jalankan Aplikasi**:
   - Web Server (WSL / Browser): `flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0`
   - Mobile / Emulator: `flutter run`

### 🔑 Kredensial Akun Demo Praktikum:
Aplikasi SayurHub telah dilengkapi dua akun demo bawaan untuk pengujian alur bisnis:
* **Akun Konsumen (Customer)**:
  - Email: `siti@smkrpl.sch.id` | Password: `password123`
  - Akses: Belanja sayur, keranjang, checkout, dan pelacakan pesanan.
* **Akun Administrator (Gudang & Toko)**:
  - Email: `admin@sayurhub.id` | Password: `admin123`
  - Akses: Menu Profil > Panel Kontrol Gudang (Audit Stok 450 kg, Status REST API, Pelacakan Armada Kurir).

---

## 📦 6. Membangun Berkas Distribusi Produksi

Untuk menghasilkan berkas rilis resmi yang siap didistribusikan ke pengguna atau diunggah ke Google Play Console:

1. Salin template kredensial:
   ```bash
   cp android/key.properties.example android/key.properties
   ```
2. Buat keystore rilis menggunakan utilitas `keytool`:
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks \
     -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias sayurhub-key
   ```
3. Jalankan skrip pipeline rilis otomatis:
   ```bash
   ./scripts/build_production.sh
   ```
   *Atau jalankan perintah manual:*
   - **Universal Release APK**: `flutter build apk --release`
   - **Split-per-ABI APK (Hemat Kuota)**: `flutter build apk --split-per-abi --release`
   - **Google Play App Bundle (AAB)**: `flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols`

---

## 🧪 7. Pengujian Kualitas Perangkat Lunak (Automated QA)

Pengujian otomatis SayurHub mencakup pengujian berlapis dengan pola **Arrange-Act-Assert (AAA)**:
- **Unit Testing**: Memverifikasi akurasi matematis `PriceCalculator` dan logika ambang mutu `InventoryManager`.
- **Widget Testing**: Memverifikasi interaktivitas visual `QuantityCounterWidget` dan rendering `ProductCard`.
- **End-to-End UAT Testing**: Memverifikasi skenario bisnis lengkap dari pembuatan user, penambahan keranjang, hingga pelacakan pesanan secara asynchronous di `test/e2e/sayurhub_capstone_uat_test.dart`.

Eksekusi seluruh test suite:
```bash
flutter test --coverage
```

---

## 👥 8. Kontributor & Kredit Akademik

Project ini dikembangkan sebagai bagian dari **Kurikulum Pembelajaran Pemrograman Mobile Berbasis Proyek (Project-Based Learning)**:
- **Institusi**: SMK Rekayasa Perangkat Lunak (RPL) / PPLG
- **Mata Pelajaran**: Pemrograman Perangkat Bergerak (Mobile Application Development)
- **Framework & Standar**: Google Flutter & Material Design 3

---

## 📄 9. Lisensi
Project SayurHub didistribusikan di bawah lisensi terbuka [MIT License](LICENSE). Bebas digunakan, dipelajari, dan dikembangkan untuk keperluan edukasi maupun komersial.
