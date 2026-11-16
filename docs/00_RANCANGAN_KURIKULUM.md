# DOKUMEN MASTER KURIKULUM & SILABUS PEMBELAJARAN FLUTTER
## PENGEMBANGAN APLIKASI MOBILE MULTIPLATFORM DARI DASAR HINGGA PRODUKSI
### KELAS KONSENTRASI KEAHLIAN REKAYASA PERANGKAT LUNAK (SMK RPL)

---

## I. IDENTITAS PROGRAM PEMBELAJARAN
- **Mata Pelajaran**: Pemrograman Perangkat Bergerak (Mobile Application Development)
- **Target Peserta**: Siswa SMK Jurusan Rekayasa Perangkat Lunak (Kelas XI / XII)
- **Prasyarat**: Logika Algoritma Dasar, Dasar Pemrograman Web/Desktop, Pemahaman Dasar Basis Data
- **Model Pembelajaran**: *Project-Based Learning (PjBL)*, *Incremental Learning*, *Problem-Based Learning*
- **Aplikasi Project Utama**: **"SayurHub"** — Aplikasi E-Commerce Penjualan Sayur dan Buah Segar Berbasis Flutter & REST API Laravel
- **Total Alokasi Waktu**: 22 Modul (Total: 132 Jam Pelajaran @ 45 Menit)

---

## II. MATRIKS SILABUS DAN URUTAN MODUL

### BAGIAN 1: PENGENALAN FLUTTER DAN PERSIAPAN LINGKUNGAN PENGEMBANGAN

#### Modul 01: Pengenalan Pemrograman Mobile dan Ekosistem Flutter
- **Tingkat Kesulitan**: Pemula
- **Estimasi Waktu**: 4 JP (180 Menit)
- **Prasyarat**: Tidak ada (Materi Pengantar)
- **Kompetensi**:
  1. Siswa mampu membedakan arsitektur aplikasi Native, Hybrid, dan Cross-Platform beserta trade-off performanya.
  2. Siswa memahami cara kerja rendering engine Flutter (Skia / Impeller) dan perbedaannya dengan WebView/Bridge.
  3. Siswa mampu mengidentifikasi use case aplikasi Flutter di industri.
- **Materi Utama**:
  - Konsep dasar mobile development (Android & iOS).
  - Native vs Hybrid vs Cross-Platform (React Native vs Flutter vs Native Kotlin/Swift).
  - Sejarah, filosofi arsitektur, dan ekosistem Flutter.
  - Mengapa Dart dipilih oleh tim Google Flutter.
  - Kelebihan & tantangan pengembangan dengan Flutter.
- **Project Integrasi "SayurHub"**:
  - Analisis kebutuhan sistem aplikasi SayurHub.
  - Pembuatan *Software Requirements Specification* (SRS) sederhana, diagram use case, dan sketsa wireframe awal antarmuka e-commerce.
- **Hubungan Antar-Modul**: Fondasi wawasan industri sebelum masuk ke konfigurasi teknis lingkungan pengembangan pada Modul 2.

---

#### Modul 02: Instalasi, Konfigurasi Lingkungan Pengembangan, dan Flutter Toolchain
- **Tingkat Kesulitan**: Pemula
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 01
- **Kompetensi**:
  1. Siswa mampu memasang dan mengonfigurasi Flutter SDK dan Android SDK pada sistem operasi.
  2. Siswa terampil menggunakan command line interface `flutter doctor` dan menganalisis serta mengatasi pesan peringatan/error.
  3. Siswa mampu menyiapkan emulator Android dan konfigurasi USB Debugging pada perangkat fisik Android.
- **Materi Utama**:
  - Download & ekstraksi Flutter SDK, konfigurasi `PATH` Environment Variable.
  - Instalasi Android Studio, Android SDK Command-line Tools, Android Emulator.
  - Instalasi VS Code, ekstensi resmi Flutter & Dart.
  - Analisis output `flutter doctor -v` dan lisensi Android (`flutter doctor --android-licenses`).
  - Troubleshooting instalasi (masalah JAVA_HOME, ADB unverified, GPU emulation issues).
- **Project Integrasi "SayurHub"**:
  - Inisialisasi repository Git dan template project Flutter awal `sayur_hub`.
  - Menjalankan build perdana aplikasi kosong di emulator dan perangkat fisik siswa.
- **Hubungan Antar-Modul**: Kesiapan alat kerja mutlak sebelum mempelajari sintaks bahasa Dart pada Bagian 2.

---

### BAGIAN 2: DASAR BAHASA PEMROGRAMAN DART

#### Modul 03: Dasar Bahasa Dart, Tipe Data, Operator, dan Sound Null Safety
- **Tingkat Kesulitan**: Pemula
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 02
- **Kompetensi**:
  1. Siswa memahami struktur eksekusi fungsi `main()` pada Dart.
  2. Siswa terampil mendeklarasikan variabel statis, dinamis, konstanta (`var`, `final`, `const`), serta tipe data primitif.
  3. Siswa menguasai konsep Sound Null Safety (`?`, `!`, `late`, `??`) untuk mencegah crash aplikasi `NullPointerException`.
- **Materi Utama**:
  - Struktur dasar program Dart dan fungsi entry point `main()`.
  - Tipe data bawaan: `int`, `double`, `num`, `String`, `bool`.
  - `var` vs `final` vs `const` dan prinsip imutabilitas memori.
  - Operator aritmatika, penugasan, pembanding, dan logika.
  - Sound Null Safety: nullable type (`Type?`), null assertion (`!`), null-aware operator (`??`, `?.`), kata kunci `late`.
- **Project Integrasi "SayurHub"**:
  - Script kalkulasi transaksi: variabel nama produk, harga dasar (double), persentase diskon, penanganan deskripsi produk yang bernilai `null` dengan aman.
- **Hubungan Antar-Modul**: Menjadi fondasi logika nilai sebelum menyusun percabangan dan perulangan pada Modul 04.

---

#### Modul 04: Kontrol Alur Eksekusi — Percabangan dan Perulangan Algoritmik
- **Tingkat Kesulitan**: Pemula
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 03
- **Kompetensi**:
  1. Siswa mampu menyusun logika keputusan berlapis menggunakan `if`, `else if`, `else`, dan `switch-case` (termasuk pattern matching Dart 3).
  2. Siswa terampil mengimplementasikan perulangan `for`, `while`, dan `do-while` untuk iterasi data.
  3. Siswa mampu mengontrol alur looping menggunakan `break` dan `continue`.
- **Materi Utama**:
  - Kondisional: `if-else`, ternary operator, `switch-case` dengan exhaustive pattern matching Dart 3.
  - Perulangan: `for` klasik, `for-in`, `while`, `do-while`.
  - Algoritma pencarian dasar (linear search) dan filtering nilai.
  - Praktik clean code dalam menghindari *arrow anti-pattern* (deeply nested ifs).
- **Project Integrasi "SayurHub"**:
  - Logika hitung diskon tier kuantitas sayur (misal: beli >= 5 ikat diskon 10%, >= 10 ikat diskon 20%).
  - Algoritma pengecekan stok opname produk dan seleksi sayur kadaluarsa berdasarkan sisa hari penyimpanan.
- **Hubungan Antar-Modul**: Logika kontrol alur ini akan digunakan di dalam fungsi dan pengolahan koleksi data pada Modul 05.

---

#### Modul 05: Function, Koleksi Data (Collection), dan Higher-Order Functions
- **Tingkat Kesulitan**: Pemula ke Menengah
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 04
- **Kompetensi**:
  1. Siswa mampu membuat fungsi modular dengan positional, optional, dan named parameters.
  2. Siswa terampil memanipulasi struktur data `List`, `Set`, dan `Map`.
  3. Siswa menguasai functional programming sederhana menggunakan higher-order functions (`map`, `where`, `reduce`, `fold`).
- **Materi Utama**:
  - Deklarasi fungsi, return value, arrow syntax (`=>`).
  - Parameter types: Positional, Named parameter dengan `required` & default value.
  - Koleksi: `List<T>`, `Set<T>`, `Map<K, V>`.
  - Spread operator (`...`, `...?`) dan collection `if` / collection `for`.
  - Higher-order methods: `.map()`, `.where()`, `.forEach()`, `.reduce()`, `.any()`, `.every()`.
- **Project Integrasi "SayurHub"**:
  - Pembuatan kumpulan data mock katalog SayurHub (daftar Map sayur & buah).
  - Fungsi kalkulasi subtotal keranjang belanja, filtering produk berdasarkan kategori ("Sayuran Hijau", "Buah Tropis"), dan sorting produk termurah.
- **Hubungan Antar-Modul**: Menjadi jembatan krusial sebelum data diubah dari Map mentah menjadi class berbasis objek (OOP) di Modul 06.

---

#### Modul 06: Object-Oriented Programming (OOP) Lanjutan pada Dart
- **Tingkat Kesulitan**: Menengah
- **Estimasi Waktu**: 8 JP (360 Menit)
- **Prasyarat**: Modul 05
- **Kompetensi**:
  1. Siswa mampu merancang Class, Object, Constructor (Generative, Named, Const Constructor).
  2. Siswa memahami dan menerapkan prinsip 4 pilar OOP: Encapsulation, Inheritance, Polymorphism, Abstraction.
  3. Siswa terampil memanfaatkan `mixin`, `enum`, dan penanganan error `try-catch-finally` serta Custom Exception.
- **Materi Utama**:
  - Blueprint Class: properti, getter/setter, private field (`_`).
  - Constructor: Initializing formal parameters, named constructor, factory constructor, `const` constructor untuk efisiensi memori.
  - Pewarisan (`extends`), overriding (`@override`), super keyword.
  - Abstract class sebagai kontrak/interface (`implements`).
  - Reusable code dengan `mixin` (`with`).
  - Dart Enum (Enhanced Enums dengan properti dan method).
  - Exception handling: `try`, `on`, `catch`, `finally`, `throw`, membuat Custom Exception.
- **Project Integrasi "SayurHub"**:
  - Pembuatan Domain Model kelas: `Product`, `Category`, `CartItem`, `User`, `Order`.
  - Penerapan factory constructor `Product.fromJson(Map<String, dynamic> json)` dan method `toJson()` untuk serialisasi data.
- **Hubungan Antar-Modul**: Class model data yang dibuat di sini akan menjadi struktur data utama saat membangun UI Flutter dan integrasi API.

---

#### Modul 07: Asynchronous Programming Dart — Future, Async-Await, dan Streams
- **Tingkat Kesulitan**: Menengah
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 06
- **Kompetensi**:
  1. Siswa memahami perbedaan arsitektur Synchronous vs Asynchronous (Event Loop & Microtask Queue).
  2. Siswa terampil menggunakan `Future`, `async`, dan `await` untuk operasi I/O non-blocking.
  3. Siswa mampu menangani error asynchronous menggunakan blok `try-catch`.
  4. Siswa mengenal konsep `Stream` untuk data streaming reaktif.
- **Materi Utama**:
  - Konsep Single-threaded Event Loop pada Dart.
  - Apa itu `Future<T>` (status: uncompleted, completed with data, completed with error).
  - Sintaks modern: `async` dan `await`.
  - Penanganan kegagalan asinkron: `try-catch` vs `.catchError()`.
  - Simulasi network latency menggunakan `Future.delayed()`.
  - Konsep pengantar `Stream<T>` (Listen, Sink, StreamController).
  - HTTP protocol dasar (Request-Response cycle, status code 200, 400, 401, 500).
- **Project Integrasi "SayurHub"**:
  - Membuat class `MockProductService` yang menyimulasikan delay server 2 detik untuk mengambil daftar sayur/buah secara asinkron.
  - Menangani simulasi kegagalan koneksi (*network timeout*) dan *data not found*.
- **Hubungan Antar-Modul**: Menutup Bagian 2 (Dart). Keterampilan async ini esensial saat Flutter merender data lewat FutureBuilder dan REST API.

---

### BAGIAN 3: DASAR PENGEMBANGAN FLUTTER

#### Modul 08: Anatomi Struktur Project Flutter dan Siklus Hidup Eksekusi
- **Tingkat Kesulitan**: Pemula ke Menengah
- **Estimasi Waktu**: 4 JP (180 Menit)
- **Prasyarat**: Modul 02, Modul 06
- **Kompetensi**:
  1. Siswa memahami struktur direktori project Flutter (`android/`, `ios/`, `lib/`, `test/`, `pubspec.yaml`).
  2. Siswa mengerti alur eksekusi aplikasi dari `main()` -> `runApp()` -> `MaterialApp` -> `Scaffold`.
  3. Siswa menguasai manajemen aset (gambar, icon) dan konfigurasi font kustom di `pubspec.yaml`.
  4. Siswa memahami perbedaan Hot Reload vs Hot Restart.
- **Materi Utama**:
  - File `pubspec.yaml`: dependencies, dev_dependencies, assets, fonts.
  - Peran `main.dart` dan konsep `BuildContext`.
  - Widget akar: `MaterialApp` dan kanvas layar `Scaffold` (appBar, body, floatingActionButton).
  - Mekanisme Hot Reload (state preserved) vs Hot Restart (state reset).
- **Project Integrasi "SayurHub"**:
  - Konfigurasi struktur folder standar industri pada `lib/` (`core/`, `features/`, `shared/`).
  - Penambahan aset gambar ilustrasi sayur & buah, logo aplikasi SayurHub, dan integrasi Google Fonts (Poppins).
- **Hubungan Antar-Modul**: Memberikan fondasi konfigurasi sebelum menyusun widget visual pada Modul 09.

---

#### Modul 09: Widget Fundamental — StatelessWidget vs StatefulWidget dan Widget Pohon (Tree)
- **Tingkat Kesulitan**: Menengah
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 08
- **Kompetensi**:
  1. Siswa memahami konsep "Everything is a Widget" serta perbedaan mendasar `StatelessWidget` vs `StatefulWidget`.
  2. Siswa memahami Lifecycle `StatefulWidget` (`initState`, `build`, `didUpdateWidget`, `dispose`).
  3. Siswa terampil menyusun widget visual dasar (`Text`, `Image`, `Icon`, `Container`, `SizedBox`, `Padding`, `Card`).
- **Materi Utama**:
  - Konsep Komposisi Widget dan Widget Tree.
  - `StatelessWidget`: imutabilitas dan render ulang.
  - `StatefulWidget`: State object dan siklus hidupnya.
  - Styling dasar: `TextStyle`, `BoxDecoration`, `BorderRadius`, `BoxShadow`.
  - Interaksi sederhana: `GestureDetector` dan `InkWell` dengan ripple effect.
- **Project Integrasi "SayurHub"**:
  - Pembuatan komponen mandiri: `ProductCard` (menampilkan gambar sayur, badge harga per kg, label rating) dan `QuantityCounterWidget` (tombol tambah/kurang jumlah kg berbasis StatefulWidget).
- **Hubungan Antar-Modul**: Komponen widget individu ini akan diatur susunannya dalam tata letak (layout) responsif pada Modul 10.

---

#### Modul 10: Tata Letak Multidimensi (Layout) dan Desain Responsif
- **Tingkat Kesulitan**: Menengah
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 09
- **Kompetensi**:
  1. Siswa mampu menyusun layout linier dan tumpuk menggunakan `Row`, `Column`, dan `Stack`.
  2. Siswa mampu mencegah error `RenderFlex overflowed` menggunakan `SingleChildScrollView`, `Expanded`, dan `Flexible`.
  3. Siswa terampil membuat daftar scrollable performan tinggi dengan `ListView.builder` dan `GridView.builder`.
  4. Siswa menguasai adaptasi ukuran layar dengan `MediaQuery` dan `LayoutBuilder`.
- **Materi Utama**:
  - `Row` & `Column`: `mainAxisAlignment`, `crossAxisAlignment`.
  - Fleksibilitas: `Expanded` vs `Flexible`.
  - Menghindari render overflow issue ("Yellow-Black Stripes").
  - Menumpuk elemen dengan `Stack` dan `Positioned` (misal: badge diskon di atas gambar).
  - Tampilan berulang: `ListView.builder`, `GridView.builder` (SliverGridDelegateWithFixedCrossAxisCount).
  - Responsive layout: Breakpoint layar menggunakan `MediaQuery` dan `LayoutBuilder`.
- **Project Integrasi "SayurHub"**:
  - Halaman Beranda (*Home Page*): Carousel banner promosi di atas, horizontal list kategori sayur/buah, dan 2-column responsif GridView untuk katalog produk sayur.
- **Hubungan Antar-Modul**: Halaman beranda yang tertata rapi akan dipoles secara visual dengan Material Design 3 pada Modul 11.

---

#### Modul 11: Desain Antarmuka Modern dengan Material Design 3 dan Reusable Theme
- **Tingkat Kesulitan**: Menengah
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 10
- **Kompetensi**:
  1. Siswa mampu menerapkan panduan Material Design 3 (M3).
  2. Siswa terampil menyusun `ThemeData` global (ColorScheme, TextTheme, Component Themes) untuk konsistensi UI.
  3. Siswa mampu mengimplementasikan struktur navigasi utama: `NavigationBar` (M3 bottom nav), `AppBar`, dan `Drawer`.
  4. Siswa mampu membuat komponen UI modular yang dapat digunakan kembali (*reusable components*).
- **Materi Utama**:
  - Material 3: `useMaterial3: true`, dynamic color palette.
  - Konfigurasi `ThemeData`: `ColorScheme.fromSeed(seedColor: Colors.green)`.
  - Kustomisasi Typography dan button styles global (`ElevatedButtonTheme`, `InputDecorationTheme`).
  - Shell Navigasi: `NavigationBar` dengan item Beranda, Kategori, Riwayat, Profil.
  - Abstraksi Reusable Widget: `CustomButton`, `CustomAppBar`, `SectionHeader`.
- **Project Integrasi "SayurHub"**:
  - Standardisasi desain SayurHub dengan tema warna hijau daun organik (`#2E7D32`), styling typography Poppins seragam, dan kerangka Shell Navigation 4 tab.
- **Hubungan Antar-Modul**: Antarmuka yang terstandarisasi siap dihubungkan antarhalaman dengan sistem routing pada Modul 12.

---

#### Modul 12: Navigasi Antarhalaman dan Routing Terstruktur (GoRouter)
- **Tingkat Kesulitan**: Menengah
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 11
- **Kompetensi**:
  1. Siswa memahami cara kerja Navigator stack (`Navigator.push`, `Navigator.pop`).
  2. Siswa menguasai routing deklaratif modern menggunakan package resmi `go_router`.
  3. Siswa mampu mengirim parameter data (Path parameter & Query parameter / Extra Object) antarhalaman dan mengembalikan data hasil.
- **Materi Utama**:
  - Konsep Navigasi Imperatif (Navigator 1.0) vs Deklaratif (Navigator 2.0).
  - Instalasi dan konfigurasi package `go_router`.
  - Mendefinisikan rute bersarang (*nested routes*) dan rute utama.
  - Mengirim data: `context.goNamed()`, `context.push()`, passing model object via `extra`.
  - Mengembalikan nilai dari halaman tujuan (`context.pop(result)`).
  - Menangani halaman 404 (Route Not Found Page).
- **Project Integrasi "SayurHub"**:
  - Mengaktifkan navigasi dari Kartu Produk di Beranda menuju Halaman Detail Produk (`/product/:id`), serta navigasi ke Halaman Keranjang (`/cart`).
- **Hubungan Antar-Modul**: Navigasi yang aktif memungkinkan penambahan alur transaksi formulir input pada Bagian 4 (Modul 13).

---

### BAGIAN 4: INTERAKSI PENGGUNA DAN PENGELOLAAN DATA

#### Modul 13: Input Pengguna, Form Handling, dan Validasi Terpadu
- **Tingkat Kesulitan**: Menengah
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 12
- **Kompetensi**:
  1. Siswa mampu mengontrol input teks menggunakan `TextEditingController` dan `FocusNode`.
  2. Siswa menguasai `Form` dan `GlobalKey<FormState>` untuk validasi data otomatis.
  3. Siswa terampil mengimplementasikan beragam kontrol input: `DropdownButtonFormField`, `CheckboxListTile`, `RadioListTile`, `SwitchListTile`, dan `showDatePicker()`.
- **Materi Utama**:
  - `TextField` vs `TextFormField`.
  - Siklus memori controller: inisialisasi dan kewajiban `controller.dispose()`.
  - Validasi: RegEx validasi format email, nomor WhatsApp Indonesia (`+62` / `08`), minimal karakter password.
  - Kontrol input seleksi: Dropdown kurir pengiriman (JNE, SiCepat, Instant Sayur), switch aktivasi asuransi, datepicker jadwal pengiriman pagi/sore.
- **Project Integrasi "SayurHub"**:
  - Pembuatan Halaman Form Registrasi Pengguna Baru dan Halaman Form Checkout Alamat Pengiriman sayur lengkap dengan validasi komprehensif.
- **Hubungan Antar-Modul**: Data formulir yang tervalidasi harus disimpan dalam state aplikasi terpusat pada Modul 14.

---

#### Modul 14: State Management Terstruktur Menggunakan Provider dan ChangeNotifier
- **Tingkat Kesulitan**: Menengah ke Lanjutan
- **Estimasi Waktu**: 8 JP (360 Menit)
- **Prasyarat**: Modul 09, Modul 13
- **Kompetensi**:
  1. Siswa memahami masalah *prop drilling* pada `setState()` lokal.
  2. Siswa menguasai arsitektur Observer pattern dengan `ChangeNotifier`.
  3. Siswa terampil mengelola state bersama (*shared state*) menggunakan package `provider` (`ChangeNotifierProvider`, `Consumer`, `context.watch()`, `context.read()`).
  4. Siswa mampu memisahkan logika bisnis (*business logic*) sepenuhnya dari tampilan antarmuka (UI).
- **Materi Utama**:
  - Ephemeral State (Lokal) vs App State (Global).
  - Mekanisme kerja `ChangeNotifier` dan `notifyListeners()`.
  - Pemasangan `MultiProvider` di root aplikasi.
  - Konsumsi data reaktif: `Consumer<T>` vs `context.watch<T>()` vs `context.select()`.
  - Memanggil fungsi aksi tanpa trigger re-render: `context.read<T>()`.
- **Project Integrasi "SayurHub"**:
  - Pembuatan `CartProvider`: logika state keranjang belanja (tambah kuantitas sayur, kurang kuantitas, hitung total belanja secara otomatis, hapus produk).
  - Pembuatan `WishlistProvider`: toggle favorit sayur dan buah yang otomatis memperbarui icon hati di kartu katalog secara instan.
- **Hubungan Antar-Modul**: State aplikasi yang aktif saat ini masih tersimpan di RAM (hilang jika aplikasi di-restart). Diperlukan persistensi lokal di Modul 15.

---

#### Modul 15: Penyimpanan Data Lokal — SharedPreferences dan Basis Data Relasional SQLite (Sqflite)
- **Tingkat Kesulitan**: Lanjutan
- **Estimasi Waktu**: 8 JP (360 Menit)
- **Prasyarat**: Modul 06, Modul 14
- **Kompetensi**:
  1. Siswa mampu menyimpan dan membaca data konfigurasi ringan menggunakan `shared_preferences`.
  2. Siswa mampu merancang dan mengelola basis data relasional offline menggunakan package `sqflite`.
  3. Siswa menguasai operasi CRUD (*Create, Read, Update, Delete*) pada database lokal dengan transaksi aman.
- **Materi Utama**:
  - Key-Value Store: `SharedPreferences` (tipe string, int, bool, double).
  - Konsep persistensi relasional lokal SQLite di Android & iOS.
  - Inisialisasi Database Helper (Singleton pattern, migrasi versi skema, `onCreate`, `onUpgrade`).
  - Pembuatan tabel database: `cart_items` dan `favorite_products`.
  - Eksekusi query SQLite: `insert`, `query`, `update`, `delete` menggunakan mapping objek Dart.
- **Project Integrasi "SayurHub"**:
  - Menyimpan status onboarding & preferensi aplikasi di SharedPreferences.
  - Memigrasikan penyimpanan item keranjang belanja SayurHub ke basis data lokal SQLite sehingga produk belanjaan tetap tersimpan saat aplikasi ditutup (*offline persistence*).
- **Hubungan Antar-Modul**: Persistensi lokal offline akan digabungkan dengan sinkronisasi data online melalui REST API pada Modul 16.

---

#### Modul 16: Integrasi REST API dan Komunikasi Jaringan Backend
- **Tingkat Kesulitan**: Lanjutan
- **Estimasi Waktu**: 8 JP (360 Menit)
- **Prasyarat**: Modul 07, Modul 14
- **Kompetensi**:
  1. Siswa memahami komunikasi Client-Server melalui protokol HTTP/HTTPS.
  2. Siswa terampil menggunakan HTTP client (`http` / `dio`) untuk melakukan request `GET`, `POST`, `PUT`, `DELETE`.
  3. Siswa mampu mem-parsing JSON response bersarang menjadi model objek Dart secara type-safe.
  4. Siswa menguasai penanganan status jaringan: Loading State (shimmer/spinner), Success State, Error State (no internet, server down).
- **Materi Utama**:
  - Arsitektur RESTful API: Endpoint, Headers, Body, HTTP Status Codes.
  - Library networking: Dio / http package, timeout configuration.
  - Serialisasi data JSON: `jsonDecode()`, `jsonEncode()`, penanganan list JSON bersarang.
  - Pengelolaan state UI asinkron: Loading skeleton (shimmer effect), Empty state, Error retry mechanism.
  - Integrasi dengan backend API (Laravel/MockAPI).
- **Project Integrasi "SayurHub"**:
  - Mengganti mock data katalog sayur/buah dengan data riil dari REST API (`GET /api/v1/products`).
  - Implementasi Pull-to-Refresh dan mekanisme *Retry* jika koneksi internet siswa terputus.
- **Hubungan Antar-Modul**: Katalog publik kini dinamis. Langkah berikutnya adalah mengamankan endpoint pemesanan dengan autentikasi pengguna pada Modul 17.

---

#### Modul 17: Autentikasi Pengguna, Token JWT, dan Keamanan Data Aplikasi
- **Tingkat Kesulitan**: Lanjutan
- **Estimasi Waktu**: 8 JP (360 Menit)
- **Prasyarat**: Modul 15, Modul 16
- **Kompetensi**:
  1. Siswa memahami alur autentikasi berbasis Token (JSON Web Token - JWT).
  2. Siswa terampil menyimpan kredensial token secara terenkripsi menggunakan `flutter_secure_storage`.
  3. Siswa mampu mengimplementasikan Interceptor HTTP untuk otomatis menyematkan header `Authorization: Bearer <token>`.
  4. Siswa mampu membuat *Route Guards* pada GoRouter untuk melindungi halaman sensitif dari akses tanpa login.
- **Materi Utama**:
  - Alur otentikasi mobile: Login -> Return JWT Token -> Secure Storage -> Authenticated Request.
  - Kelemahan SharedPreferences untuk data rahasia vs Keunggulan Hardware Keystore / Keyring pada `flutter_secure_storage`.
  - Auth Interceptor: menyisipkan header token otomatis dan menangani token expired (HTTP 401 Unauthorized -> auto logout).
  - Proteksi Rute: Redirect pengguna belum login jika mencoba membuka halaman Checkout atau Profil.
- **Project Integrasi "SayurHub"**:
  - Pembuatan fitur Login & Registrasi pengguna yang terhubung ke REST API.
  - Manajemen sesi login yang persisten (pengguna tidak perlu login ulang saat membuka aplikasi) dan alur Logout aman yang membersihkan token.
- **Hubungan Antar-Modul**: Menutup Bagian 4. Seluruh fitur fungsional kini siap dirapikan strukturnya dengan arsitektur profesional pada Bagian 5.

---

### BAGIAN 5: ARSITEKTUR, FITUR LANJUTAN, TESTING, DAN DEPLOYMENT

#### Modul 18: Arsitektur Aplikasi Skala Besar dan Clean Code (Feature-First Architecture)
- **Tingkat Kesulitan**: Lanjutan
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 14, Modul 16, Modul 17
- **Kompetensi**:
  1. Siswa mampu menerapkan prinsip *Separation of Concerns* (SoC) dan Clean Architecture yang disederhanakan (*Feature-First*).
  2. Siswa menguasai pembagian layer: Presentation Layer (UI & State), Domain Layer (Entities/Models), Data Layer (Data Sources & Repositories).
  3. Siswa terampil mengimplementasikan *Repository Pattern* untuk mengabstraksi sumber data (antara Local Database SQLite dan Remote REST API).
- **Materi Utama**:
  - Masalah "God Class" dan spaghetti code pada project mobile.
  - Struktur Feature-First: `features/product/`, `features/cart/`, `features/auth/`.
  - Desain 3 Layer: Data (Remote/Local Data Source) -> Domain/Repository -> Presentation (Provider + Screen).
  - Penerapan Dependency Injection sederhana (Service Locator dengan `get_it` atau Provider Injection).
  - Refactoring kode lama ke standar Clean Code (penamaan yang bersih, single responsibility principle).
- **Project Integrasi "SayurHub"**:
  - Refactoring total struktur folder project `sayur_hub` menjadi arsitektur Feature-First dengan `ProductRepository` yang menangani caching offline otomatis (ambil dari SQLite jika offline, fetch API jika online).
- **Hubungan Antar-Modul**: Fondasi arsitektur bersih ini mempermudah penambahan fitur-fitur perangkat keras mobile pada Modul 19.

---

#### Modul 19: Fitur Mobile Lanjutan — Kamera, Galeri Gambar, Upload File, dan Infinite Scroll
- **Tingkat Kesulitan**: Lanjutan
- **Estimasi Waktu**: 8 JP (360 Menit)
- **Prasyarat**: Modul 18
- **Kompetensi**:
  1. Siswa menguasai penanganan permission hardware pada Android (`AndroidManifest.xml`) menggunakan `permission_handler`.
  2. Siswa terampil mengambil gambar dari Kamera dan Galeri foto menggunakan package `image_picker`.
  3. Siswa mampu mengunggah file gambar multipart form-data ke REST API server.
  4. Siswa mampu mengimplementasikan pagination tak terbatas (*Infinite Scrolling Pagination*) pada katalog data.
- **Materi Utama**:
  - Konfigurasi runtime permission Android 13+ (Camera, Read External Storage / Media Images).
  - Menggunakan `image_picker` (ImageSource.camera, ImageSource.gallery, image quality compression).
  - Pengiriman file multipart dengan Dio / http (`MultipartFile.fromFile`).
  - Mengelola `ScrollController` untuk mendeteksi scroll akhir layar (*scroll-to-bottom*) dan memicu request pagination berikutnya.
  - Search & Debouncing: mencegah spam request API saat pengguna mengetik nama sayur.
- **Project Integrasi "SayurHub"**:
  - Fitur upload foto profil pengguna dan upload foto bukti transfer pembayaran di SayurHub.
  - Infinite scroll katalog produk sayur (load 10 data berikutnya per scroll) dan fitur pencarian produk *live search* dengan debouncing 500ms.
- **Hubungan Antar-Modul**: Kode aplikasi yang kaya fitur ini harus diverifikasi kestabilannya melalui proses testing pada Modul 20.

---

#### Modul 20: Debugging Mendalam, DevTools Profiling, dan Strategi Testing Aplikasi
- **Tingkat Kesulitan**: Lanjutan
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 18, Modul 19
- **Kompetensi**:
  1. Siswa terampil menggunakan Flutter DevTools (Flutter Inspector, CPU Profiler, Memory Leak Detector, Network Monitor).
  2. Siswa mampu menulis Unit Test untuk menguji logika bisnis (perhitungan diskon, format mata uang, repository).
  3. Siswa mampu menulis Widget Test untuk memverifikasi fungsionalitas UI komponen tanpa menjalankan emulator.
  4. Siswa mengenal Integration Test untuk pengujian alur pengguna secara menyeluruh (*end-to-end*).
- **Materi Utama**:
  - Debugging teknik: Breakpoint, Conditional Breakpoint, Call Stack inspection, logging terstruktur.
  - Flutter DevTools: Deteksi jank frame (FPS drop), alokasi memori yang tidak di-dispose.
  - Dasar Unit Testing: file `test/`, `test()`, `group()`, `expect()`, mock data.
  - Widget Testing: `testWidgets()`, `WidgetTester`, `find.byType()`, `find.text()`, `tester.pumpAndSettle()`.
- **Project Integrasi "SayurHub"**:
  - Penulisan Unit Test untuk kelas perhitungan total transaksi dan diskon keranjang di `CartProvider`.
  - Penulisan Widget Test untuk memvalidasi interaksi penambahan kuantitas pada `ProductCard` dan validasi form checkout.
- **Hubungan Antar-Modul**: Setelah seluruh kode teruji dan bebas bug, aplikasi siap dipaketkan untuk distribusi ke publik pada Modul 21.

---

#### Modul 21: Optimasi Produksi, Keamanan Rilis, dan Build Deployment Android (APK & App Bundle)
- **Tingkat Kesulitan**: Lanjutan
- **Estimasi Waktu**: 6 JP (270 Menit)
- **Prasyarat**: Modul 20
- **Kompetensi**:
  1. Siswa mampu mengonfigurasi App Icon adaptif dan Native Splash Screen profesional.
  2. Siswa memahami perbedaan mode eksekusi: Debug, Profile, dan Release.
  3. Siswa terampil membuat Java Keystore (`key.jks`), mengonfigurasi `key.properties`, dan signing APK/AAB di Gradle secara aman.
  4. Siswa mampu melakukan build APK Release dan Android App Bundle (AAB) yang dioptimasi dan ter-obfuscate (ProGuard / R8).
- **Materi Utama**:
  - Ikon aplikasi otomatis dengan `flutter_launcher_icons`.
  - Native Splash Screen tanpa blank screen dengan `flutter_native_splash`.
  - Versioning aplikasi: `version: 1.0.0+1` (Version Name & Version Code) pada `pubspec.yaml`.
  - Keamanan file signing: Menjaga kerahasiaan `key.jks` dan `.gitignore`.
  - Perintah build CLI: `flutter build apk --release --split-per-abi` dan `flutter build appbundle`.
  - Analisis ukuran file APK (App Size Analysis).
  - Prosedur checklist standar rilis Google Play Console.
- **Project Integrasi "SayurHub"**:
  - Konfigurasi icon SayurHub resmi, splash screen logo segar, signing keystore rilis, dan kompilasi final menghasilkan file `sayur_hub_release.apk` dan `app-release.aab` yang siap didistribusikan.
- **Hubungan Antar-Modul**: Mengantarkan siswa ke tahap puncak penggabungan seluruh sistem pada Capstone Final Project Modul 22.

---

### BAGIAN 6: CAPSTONE FINAL PROJECT

#### Modul 22: Capstone Final Project — Penyempurnaan, Integrasi End-to-End, dan Presentasi Aplikasi "SayurHub"
- **Tingkat Kesulitan**: Lanjutan (Komprehensif)
- **Estimasi Waktu**: 10 JP (450 Menit)
- **Prasyarat**: Modul 01 hingga Modul 21
- **Kompetensi**:
  1. Siswa mampu mengintegrasikan seluruh 20 fitur utama SayurHub secara kohesif menjadi aplikasi e-commerce siap pakai.
  2. Siswa terampil melakukan pengujian menyeluruh (UAT - *User Acceptance Testing*) dan perbaikan bug akhir.
  3. Siswa mampu menyusun dokumentasi teknis project (README, panduan instalasi API, diagram arsitektur) dan mempresentasikan produk aplikasi di hadapan penguji/instruktur.
- **Materi Utama & Aktivitas**:
  - Integrasi akhir 20 fitur aplikasi SayurHub:
    1. Splash screen animasi.
    2. Onboarding interaktif 3 slide.
    3. Registrasi pengguna baru dengan validasi form.
    4. Login JWT & auto-login session.
    5. Dashboard beranda dinamis.
    6. Katalog produk sayur & buah lengkap.
    7. Filter kategori dinamis (Sayur Hijau, Umbi, Buah Segar, Herbal).
    8. Halaman detail produk interaktif (galeri foto, deskripsi nutrisi, rating).
    9. Fitur pencarian produk real-time (live search).
    10. Keranjang belanja reaktif dengan Provider.
    11. Manajemen checkout & perhitungan ongkir kurir.
    12. Form alamat pengiriman & pin lokasi.
    13. Riwayat transaksi belanja (Status: Menunggu Pembayaran, Diproses, Dikirim, Selesai).
    14. Detail pesanan belanja & invoice ringkas.
    15. Profil pengguna & ringkasan akun.
    16. Fitur ganti foto profil via kamera/galeri.
    17. Integrasi REST API menyeluruh (Backend Laravel/Mock).
    18. Persistensi lokal offline (SQLite & SharedPreferences).
    19. Indikator loading shimmer, empty state visual, dan dialog error informatif.
    20. UI responsif mendukung smartphone dan tablet.
  - Final QA & Bug Bash (Edge case handling, memory leak check).
  - Penyusunan dokumentasi portofolio GitHub profesional dan video demo aplikasi.
- **Hubungan Antar-Modul**: Puncak kulminasi dari seluruh pembelajaran Modul 01 - Modul 21.

---

## III. TABEL MATRIKS INTEGRASI APLIKASI UTAMA "SAYURHUB"

Berikut adalah peta perkembangan bertahap (*incremental development*) dari aplikasi **SayurHub**:

| No Modul | Fitur / Komponen yang Dibangun | Output Nyata pada Project SayurHub |
|---|---|---|
| **Modul 01** | Analisis & Wireframing | Dokumen SRS, User Journey, Wireframe Figma/Sketsa |
| **Modul 02** | Inisialisasi Git & Environment | Project Flutter `sayur_hub` pertama berhasil running |
| **Modul 03** | Dart Logic: Dasar Transaksi | Script kalkulator hitung diskon & total belanja aman dari Null |
| **Modul 04** | Dart Logic: Diskon Bertingkat | Algoritma filter stok sayur dan tier diskon volume |
| **Modul 05** | Dart Collection & Filter | Mock data katalog sayur (List of Map) & filter kategori functional |
| **Modul 06** | Data Modeling (OOP) | Class Entity: `Product`, `Category`, `CartItem`, `User` + parsing JSON |
| **Modul 07** | Asynchronous & Mock Service | `MockProductService` menyimulasikan delay network 2 detik |
| **Modul 08** | Setup Aset & Folder Structure | Setup `assets/images/`, Google Fonts Poppins, struktur folder bersih |
| **Modul 09** | Reusable UI Component | Widget `ProductCard` & `QuantityCounterWidget` |
| **Modul 10** | Beranda & Layout Responsif | Halaman Beranda lengkap: Banner Slider, GridView 2 kolom |
| **Modul 11** | Theming Material 3 | Tema hijau `#2E7D32` konsisten, Shell Navigasi 4 tab bawah |
| **Modul 12** | Navigasi GoRouter | Rute Beranda -> Detail Produk (`/product/:id`) -> Keranjang |
| **Modul 13** | Input & Form Checkout | Form Registrasi & Form Alamat Pengiriman + Regex validation |
| **Modul 14** | State Management Provider | `CartProvider` (tambah/kurang belanja realtime) & `WishlistProvider` |
| **Modul 15** | Database Lokal (SQLite) | Keranjang belanja tersimpan permanen di SQLite (bisa offline) |
| **Modul 16** | Integrasi REST API | Fetch katalog sayur riil via HTTP/Dio, shimmer loading & error state |
| **Modul 17** | Autentikasi JWT | Login, Register, simpan token di Secure Storage, Auth Guard |
| **Modul 18** | Clean Architecture (Feature-First) | Refactoring kode ke 3-Layer (Data, Domain, Presentation) |
| **Modul 19** | Kamera & Infinite Scroll | Upload foto profil pengguna & infinite scroll pagination katalog |
| **Modul 20** | Testing & DevTools | Unit test kalkulasi belanja & Widget test tombol/form |
| **Modul 21** | Build APK & Keystore | Setup icon, native splash, signing keystore, build release APK/AAB |
| **Modul 22** | Final Capstone Assembly | Penyempurnaan 20 fitur utuh, UAT, dokumentasi GitHub & rilis |

---

## IV. EVALUASI DAN ANALISIS KONTINUITAS PEDAGOGIS (TAHAP 2)

Untuk memastikan kurikulum ini optimal bagi siswa SMK RPL tanpa menimbulkan kesenjangan konsep (*cognitive leap*), dilakukan analisis berikut:

### 1. Validasi Transisi Konsep (No Concept Jumping)
- **Transisi Pemula ke Dart (Modul 1-2 ke 3-5)**: Siswa tidak langsung berhadapan dengan kompleksitas UI Flutter sebelum memahami logika pemrograman Dart. Logika dibangun bertahap dari variabel sederhana, kontrol alur, hingga koleksi data.
- **Transisi Dart ke OOP dan Async (Modul 5 ke 6-7)**: Siswa memahami koleksi data terlebih dahulu sebelum mengabstraksikannya ke dalam Class OOP dan model data. Pemahaman Async (Modul 7) diselesaikan sebelum masuk ke Flutter agar siswa tidak bingung saat berhadapan dengan `FutureBuilder` dan async events.
- **Transisi Dasar Flutter ke UI Lanjut (Modul 8-9 ke 10-12)**: Siswa diperkenalkan anatomi project dan komponen visual terkecil (`Text`, `Container`, `Card`) sebelum dituntut menyusun tata letak multi-elemen (`Row`, `Column`, `ListView`, `GridView`).
- **Transisi UI ke State Management (Modul 10-13 ke 14)**: Masalah *prop drilling* dan keterbatasan `setState` diperlihatkan terlebih dahulu pada Modul 9 & 13 sebelum solusi `Provider` diperkenalkan di Modul 14. Hal ini membuat siswa memahami *alasan mengapa* Provider dibutuhkan.
- **Transisi State ke Persistensi dan Networking (Modul 14 ke 15-17)**: State management dikuasai terlebih dahulu sebelum data dihubungkan ke SQLite lokal dan REST API. Siswa belajar menyimpan state ke memori sebelum menyimpannya ke disk (SQLite) dan server (API).
- **Transisi Menuju Arsitektur Skala Besar (Modul 14-17 ke 18)**: Refactoring arsitektur (Feature-First) ditempatkan setelah siswa merasakan sendiri kerumitan menyatukan API, Database, dan State dalam satu file. Dengan demikian, Clean Architecture diapresiasi sebagai solusi nyata, bukan sekadar teori abstrak.

### 2. Standar Best Practices & Relevansi Industri Modern (Tahun 2024-2026)
- **Dart 3.x Ready**: Menggunakan *Sound Null Safety*, *Pattern Matching*, dan *Records*.
- **Flutter 3.x+**: Mengadopsi standar **Material Design 3 (M3)** secara *default* (`useMaterial3: true`).
- **Routing Deklaratif**: Menggunakan **GoRouter** yang merupakan rekomendasi resmi Flutter Team.
- **State Management Standar**: Menggunakan **Provider & ChangeNotifier** yang merupakan state management paling pedagogis dan stabil untuk siswa SMK sebelum mempelajari Bloc/Riverpod.
- **Keamanan Kredensial**: Menggunakan **FlutterSecureStorage** (bukan SharedPreferences) untuk token autentikasi JWT.
- **Arsitektur Modular**: Feature-First structure yang digunakan secara luas di industri startup mobile.

---

## V. KESIMPULAN TAHAP 1 & 2
Rancangan kurikulum 22 modul ini telah dirancang secara komprehensif, terstruktur, berbasis proyek tunggal (*single unified project SayurHub*), dan memenuhi seluruh kriteria pedagogis SMK RPL.

Kurikulum ini siap dijadikan acuan baku dalam penulisan modul detail (dimulai dari Modul 01) setelah disetujui.
