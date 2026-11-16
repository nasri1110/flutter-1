# MODUL 17: AUTENTIKASI PENGGUNA, TOKEN JWT, DAN KEAMANAN DATA APLIKASI (FLUTTER_SECURE_STORAGE, AUTH INTERCEPTOR, & ROUTE GUARDS)

---

## A. IDENTITAS MODUL
* **Mata Pelajaran**: Pemrograman Perangkat Bergerak (*Mobile Application Development*)
* **Kelas / Semester**: XI / XII SMK Kompetensi Keahlian Rekayasa Perangkat Lunak (RPL)
* **Alokasi Waktu**: 8 Jam Pelajaran (@ 45 Menit) / 2 Pertemuan Praktikum Terbimbing
* **Judul Modul**: Keamanan Siber Perangkat Bergerak: Autentikasi Berbasis Token JWT, Enkripsi Hardware Keystore, Auth Interceptor, dan Proteksi Rute (Route Guards) pada Proyek SayurHub
* **Model Pembelajaran**: *Project-Based Learning* (PjBL), *Security Defense Modeling*, dan *Hands-on Token Inspection*
* **Prasyarat**: 
  - [Modul 06: Object-Oriented Programming & Data Modeling](file:///home/arif/flutter-1/docs/modul/06_OBJECT_ORIENTED_PROGRAMMING_DART.md)
  - [Modul 12: Navigasi Antarhalaman & GoRouter Deklaratif](file:///home/arif/flutter-1/docs/modul/12_NAVIGASI_ANTARHALAMAN_DAN_GOROUTER.md)
  - [Modul 13: Input Form & Validasi Checkout](file:///home/arif/flutter-1/docs/modul/13_INPUT_FORM_DAN_VALIDASI.md)
  - [Modul 14: State Management dengan Provider](file:///home/arif/flutter-1/docs/modul/14_STATE_MANAGEMENT_PROVIDER.md)
  - [Modul 16: Integrasi REST API dan Komunikasi Jaringan Dio](file:///home/arif/flutter-1/docs/modul/16_INTEGRASI_REST_API_DAN_NETWORKING.md)

---

## B. PETA KONSEP & CAPAIAN PEMBELAJARAN

### B.1 Peta Konsep Arsitektur Autentikasi & Keamanan Data

```mermaid
flowchart TD
    subgraph Client_App ["Aplikasi Mobile SayurHub"]
        LoginUI["LoginScreen\n(Validasi Email & Password)"]
        CartUI["CartScreen\n('Lanjut ke Checkout')"]
        ProtectedCheckout["CheckoutScreen\n(Rute Terproteksi)"]
        ProfileUI["ProfileScreen\n(Data Profil & Tombol Logout)"]
        
        subgraph Security_State ["Lapisan Keamanan & State"]
            AuthProv["AuthProvider (ChangeNotifier)\n- currentUser: User?\n- token: String?\n- isAuthenticated: bool\n- login(), register(), logout()"]
            SecureStore["SecureStorageService\n(FlutterSecureStorage)\n- Android KeyStore / iOS Keychain\n- Encrypted Token Storage"]
        end

        subgraph Routing_Protection ["Proteksi Navigasi (Route Guards)"]
            RouterGuard["GoRouter redirect: (context, state)\n- refreshListenable: AuthProvider\n- Belum Login -> Redirect ke /login\n- Sudah Login -> Lolos ke /checkout"]
        end

        subgraph Network_Interceptor ["Pencegat Jaringan (Dio Interceptor)"]
            AuthInterceptor["Auth Interceptor\n- onRequest: Sisipkan Header 'Authorization: Bearer <token>'\n- onError: Tangkap HTTP 401 Unauthorized -> Auto-Logout"]
        end
    end

    subgraph Backend_Server ["Peladen REST API SayurHub"]
        AuthEndpoint["POST /api/v1/auth/login\n(Kembalikan Token JWT)"]
        OrderEndpoint["POST /api/v1/orders\n(Mewajibkan Header Bearer JWT)"]
    end

    CartUI -->|"Tekan Checkout"| RouterGuard
    RouterGuard -->|"Cek: !isAuthenticated"| LoginUI
    LoginUI -->|"Input Kredensial"| AuthProv
    AuthProv -->|"Kirim Kredensial"| AuthEndpoint
    AuthEndpoint -- "HTTP 200: JWT Payload" --> AuthProv
    AuthProv -->|"Enkripsi & Simpan Token"| SecureStore
    AuthProv -- "notifyListeners()" --> RouterGuard
    RouterGuard -->|"Cek: isAuthenticated == true"| ProtectedCheckout

    ProtectedCheckout -->|"Kirim Pesanan"| Network_Interceptor
    Network_Interceptor -->|"Sematkan Bearer Token"| OrderEndpoint
    ProfileUI -->|"Tekan Logout"| AuthProv
    AuthProv -->|"Hapus Token dari Keystore"| SecureStore
```

### B.2 Capaian Pembelajaran Elemen (CP)
Pada akhir modul ini, peserta didik kompetensi keahlian RPL mampu:
1. Memahami perbedaan fundamental arsitektur autentikasi berbasis sesi (*Session-based*) dengan autentikasi berbasis token (*Token-based / Stateless JWT*).
2. Menguraikan anatomi tiga bagian JSON Web Token (**Header**, **Payload/Claims**, dan **Digital Signature**) serta masa kedaluwarsanya (*expiration timestamp*).
3. Mengidentifikasi kelemahan kritis `SharedPreferences` dalam menyimpan data rahasia dan menerapkan brankas terenkripsi perangkat keras (**Hardware Keystore / Keychain**) menggunakan `flutter_secure_storage`.
4. Merancang dan menyematkan **Auth Interceptor** pada klien jaringan `Dio` untuk mengotomatiskan penyisipan header `Authorization: Bearer <token>` pada setiap transaksi daring.
5. Menangani skenario token kedaluwarsa secara otomatis melalui penangkapan kode status **HTTP 401 Unauthorized** (*Graceful Auto-Logout*).
6. Mengimplementasikan **Route Guards** deklaratif pada `GoRouter` untuk melindungi rute sensitif (*Protected Routes*) dan mengalihkan pengguna ke layar Login dengan parameter *Redirect Callback*.
7. Membangun antarmuka masuk akun (**LoginScreen**) yang memikat, aman, tervalidasi dengan regex email, serta terhubung dengan sesi pengguna di **ProfileScreen**.

### B.3 Tujuan Pembelajaran Khusus (TP)
* **Kognitif**:
  - Siswa mampu menjelaskan mengapa token JWT tidak boleh didekripsi sembarangan untuk menyimpan informasi kata sandi mentah.
  - Siswa memahami peran `refreshListenable` pada GoRouter yang secara reaktif mendengarkan `AuthProvider`.
* **Psikomotorik**:
  - Siswa terampil mengonfigurasi `FlutterSecureStorage` dengan opsi `encryptedSharedPreferences: true` pada Android.
  - Siswa mampu menulis logika proteksi rute di dalam parameter `redirect` pada [app_router.dart](file:///home/arif/flutter-1/sayur_hub/lib/core/routes/app_router.dart).
* **Afektif**:
  - Menanamkan kesadaran etika profesi rekayasa perangkat lunak mengenai pentingnya menjaga kerahasiaan data pribadi (*Data Privacy & Cyber Security*) milik konsumen e-commerce.

---

## C. MATERI TEORI KOMPREHENSIF

### C.1 Otentikasi Sesi vs Otentikasi Token (JWT)
Dalam pengembangan aplikasi mobile, kita tidak menggunakan sistem sesi berbasis *Cookie* tradisional karena aplikasi mobile tidak berjalan di dalam peramban web (*browser*).

```
┌─────────────────────────────────┬─────────────────────────────────┐
│ Sesi Tradisional (Cookie-Based) │ Token Modern (JWT-Based)        │
├─────────────────────────────────┼─────────────────────────────────┤
│ Server menyimpan memori sesi di │ Server bersifat Stateless       │
│ RAM/Database untuk setiap user. │ (tidak menyimpan data sesi).    │
│ Sulit diskalakan (*scale out*)  │ Sangat mudah diskalakan ke      │
│ ke banyak server terdistribusi. │ ribuan server mikrosains/cloud. │
│ Membutuhkan manajemen session ID│ Token memuat identitas terenkripsi│
│ yang rentan serangan CSRF.      │ yang divalidasi via Signature.  │
└─────────────────────────────────┴─────────────────────────────────┘
```

---

### C.2 Anatomi JSON Web Token (JWT)
JSON Web Token adalah standar terbuka industri (**RFC 7519**) untuk mentransmisikan klaim identitas antara klien dan server secara aman dan kompak. Sebuah string JWT selalu dipisahkan oleh dua titik (`.`) menjadi tiga segmen utama:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJVU1ItMDAxIiwiZW1haWwiOiJzaXRpQHNta3JwbC5zY2guaWQiLCJleHAiOjE4MDAwMDAwMDB9.sEcUrE_SiGnAtUrE_sAyUrHuB_2026
 └──────────────┬──────────────────┘ └──────────────────────────────┬──────────────────────────────┘ └──────────────┬──────────────────┘
         BAGIAN 1: HEADER                                   BAGIAN 2: PAYLOAD                                 BAGIAN 3: SIGNATURE
```

1. **Header**: Memuat tipe token (`JWT`) dan algoritma penandatanganan kriptografi (misal: `HMAC SHA-256` atau `RSA`).
2. **Payload (Claims)**: Memuat pernyataan identitas pengguna yang dikodekan dalam Base64URL. Terbagi atas:
   - *Registered Claims*: `sub` (Subject / ID Pengguna), `exp` (Expiration Time / Waktu Kedaluwarsa), `iat` (Issued At).
   - *Custom Claims*: `name`, `email`, `role` (misal: `customer` atau `admin`).
3. **Digital Signature (Tanda Tangan Digital)**:
   Dihasilkan dari gabungan Header dan Payload yang di-*hash* menggunakan kunci rahasia (*Secret Key*) milik backend peladen. Menjamin bahwa token tidak pernah dipalsukan atau diubah di tengah jalan oleh peretas.

> [!WARNING]
> **PERINGATAN KEAMANAN KRUSIAL:**
> Payload JWT hanya dikodekan (*encoded*) dalam format Base64URL, **BUKAN DIENKRIPSI** (*NOT ENCRYPTED*). Siapa pun dapat mendekode payload tersebut menjadi teks JSON biasa. Oleh karena itu, **DILARANG KERAS** menyimpan informasi rahasia sensitif seperti kata sandi (*password*), PIN ATM, atau nomor kartu kredit di dalam Payload JWT!

---

### C.3 Mengapa SharedPreferences Berbahaya untuk Menyimpan Token?
Pada [Modul 15](file:///home/arif/flutter-1/docs/modul/15_PENYIMPANAN_DATA_LOKAL_SQLITE.md), kita telah mempelajari bahwa `shared_preferences` menyimpan data dalam berkas XML teks biasa (*plain-text*) di penyimpanan internal.
- Jika pengguna menginstal aplikasi berbahaya di smartphone Android mereka, atau perangkat dalam kondisi *rooted / jailbroken*, berkas XML tersebut dapat dicuri menggunakan perangkat lunak *malware*.
- Jika token JWT dicuri (*Token Hijacking*), peretas dapat bertransaksi atas nama korban tanpa perlu mengetahui kata sandinya!

#### Solusi Standar Industri: Hardware Keystore
Pustaka **`flutter_secure_storage`** memanfaatkan modul keamanan fisik bawaan prosesor perangkat:
- Pada **Android**: Memanfaatkan **Android KeyStore Provider** yang mengamankan kunci enkripsi di dalam lingkungan perangkat keras terisolasi (*Trusted Execution Environment / TEE*).
- Pada **iOS**: Menggunakan **iOS Keychain Services** yang dilindungi oleh prosesor keamanan khusus (*Apple Secure Enclave*).

Data yang disimpan dijamin terenkripsi dengan algoritma **AES-256-GCM** tingkat militer, sehingga aman bahkan jika perangkat diekstraksi secara fisik.

---

### C.4 Arsitektur Auth Interceptor pada Klien Dio
Alih-alih menyalin dan menempelkan (*copy-paste*) kode penyisipan token di setiap fungsi pemanggilan API, kita menggunakan **Interceptor** pada pustaka `dio`:

```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      // 1. Ambil token JWT dari brankas Hardware Keystore
      final token = await SecureStorageService.instance.getToken();
      if (token != null) {
        // 2. Sisipkan otomatis ke header standar HTTP
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (DioException error, handler) async {
      // 3. Deteksi otomatis jika token telah kedaluwarsa di server
      if (error.response?.statusCode == 401) {
        // Bersihkan sesi dan arahkan pengguna keluar
        await SecureStorageService.instance.clearAuth();
      }
      return handler.next(error);
    },
  ),
);
```

---

### C.5 Mekanisme Route Guards pada GoRouter Deklaratif
Pada aplikasi e-commerce profesional, pengguna anonim (tamu) bebas menjelajahi katalog produk dan memasukkan barang ke keranjang belanja. Namun, saat mereka menekan tombol **"Lanjutkan ke Checkout Alamat"**, sistem keamanan harus mengadang (*guard*) dan mengarahkan mereka ke layar masuk (*login*).

GoRouter menyediakan parameter **`redirect`** yang dipadukan dengan **`refreshListenable`**:

```dart
GoRouter(
  refreshListenable: authProvider, // Memicu evaluasi ulang rute seketika saat login/logout
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = authProvider.isAuthenticated;
    final bool isCheckoutRoute = state.matchedLocation == '/checkout';

    if (isCheckoutRoute && !loggedIn) {
      // Pengguna belum login mencoba akses checkout:
      // Simpan URL asal di parameter query agar setelah login bisa kembali ke sini!
      return '/login?redirect=${Uri.encodeComponent(state.matchedLocation)}';
    }

    return null; // Lolos verifikasi
  },
  ...
);
```

---

## D. PEMBAHASAN KODE MENDALAM (CODE WALKTHROUGH)

### D.1 Brankas Kredensial Terenkripsi: `SecureStorageService`
Mari bedah berkas [secure_storage_service.dart](file:///home/arif/flutter-1/sayur_hub/lib/core/services/secure_storage_service.dart):

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  // Konfigurasi opsi keamanan hardware platform
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _keyToken = 'jwt_access_token';
  static const String _keyUserName = 'auth_user_name';
  static const String _keyUserEmail = 'auth_user_email';

  Future<void> saveUserSession({
    required String token,
    required String id,
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyUserName, value: name);
    await _storage.write(key: _keyUserEmail, value: email);
    // Simpan identitas profil lainnya...
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> clearAuth() async {
    await _storage.deleteAll(); // Menghapus seluruh kredensial saat logout
  }
}
```

*Analisis Kunci*:
- **`encryptedSharedPreferences: true`**: Mengaktifkan modul MasterKey AndroidX Security Crypto yang mengenkripsi kunci dan nilai secara independen di level sistem operasi.
- **`KeychainAccessibility.first_unlock`**: Pada iOS, menjamin kredensial hanya dapat diakses setelah pengguna membuka kunci layar smartphone mereka pertama kali setelah reboot.

---

### D.2 Pengelola Sesi Autentikasi: `AuthProvider`
Mari amati berkas [auth_provider.dart](file:///home/arif/flutter-1/sayur_hub/lib/core/providers/auth_provider.dart):

```dart
class AuthProvider extends ChangeNotifier {
  final SecureStorageService _storageService;

  AuthProvider({SecureStorageService? storageService})
      : _storageService = storageService ?? SecureStorageService.instance;

  User? _currentUser;
  String? _token;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  String? get token => _token;

  /// Auto-Login: Diperiksa saat aplikasi pertama kali dinyalakan (Cold Start)
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final session = await _storageService.getUserSession();
      final token = session['token'];

      if (token != null && token.isNotEmpty) {
        _token = token;
        _currentUser = User(
          id: session['id'] ?? 'USR-001',
          fullName: session['name'] ?? 'Siti Nurhaliza',
          phoneNumber: session['phone'] ?? '081234567890',
          email: session['email'] ?? 'siti@smkrpl.sch.id',
          address: session['address'] ?? 'Jl. Merdeka No. 45, Bandung Barat',
        );
        _isAuthenticated = true;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Masuk Akun: Memvalidasi kredensial dan menerbitkan token JWT
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200)); // Simulasi latensi jaringan

    // 1. Kredensial Administrator Gudang & Toko
    if (email.trim().toLowerCase() == 'admin@sayurhub.id' && password == 'admin123') {
      const String mockJwtToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBRE0tMDAxIiwibmFtZSI6IkFkbWluIFNheXVySHViIiwicm9sZSI6ImFkbWluIn0...';

      final user = User(
        id: 'ADM-001',
        fullName: 'Budi Santoso (Admin Gudang)',
        phoneNumber: '081198765432',
        email: 'admin@sayurhub.id',
        address: 'Sentra Distribusi SayurHub Lembang, Bandung',
        role: 'admin',
      );

      await _storageService.saveUserSession(
        token: mockJwtToken,
        id: user.id,
        name: user.fullName,
        email: user.email!,
        phone: user.phoneNumber,
        address: user.address,
      );

      _token = mockJwtToken;
      _currentUser = user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    // 2. Kredensial Konsumen (Customer)
    else if (email.trim().toLowerCase() == 'siti@smkrpl.sch.id' && password == 'password123') {
      const String mockJwtToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJVU1ItMDAxIiwibmFtZSI6IlNpdGkgTnVyaGFsaXphIiwicm9sZSI6ImN1c3RvbWVyIn0...';

      final user = User(
        id: 'USR-001',
        fullName: 'Siti Nurhaliza',
        phoneNumber: '081234567890',
        email: email.trim(),
        address: 'Jl. Merdeka No. 45, Bandung Barat',
        role: 'customer',
      );

      await _storageService.saveUserSession(
        token: mockJwtToken,
        id: user.id,
        name: user.fullName,
        email: user.email!,
        phone: user.phoneNumber,
        address: user.address,
      );

      _token = mockJwtToken;
      _currentUser = user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners(); // Memicu Route Guard GoRouter secara otomatis!
      return true;
    } else {
      _isLoading = false;
      _errorMessage = 'Email/Password salah! Demo: siti@smkrpl.sch.id atau admin@sayurhub.id';
      notifyListeners();
      return false;
    }
  }

  /// Sesi Logout: Membersihkan seluruh token hardware
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _storageService.clearAuth();
    _token = null;
    _currentUser = null;
    _isAuthenticated = false;
    _isLoading = false;
    notifyListeners();
  }
}
```

*Analisis Kunci*:
- Mengapa `notifyListeners()` di `login()` dan `logout()` begitu sakti? Karena di `AppRouter`, kita mendaftarkan `refreshListenable: authProvider`. Setiap kali status autentikasi berubah, GoRouter secara otomatis mengevaluasi ulang fungsi `redirect()` tanpa perlu navigasi imperatif manual!

---

### D.3 Layar Masuk Akun: `LoginScreen`
Mari amati berkas [login_screen.dart](file:///home/arif/flutter-1/sayur_hub/lib/features/auth/login_screen.dart):

```dart
class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final bool success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Kembali ke halaman yang sebelumnya ingin dituju (misal /checkout)
      final target = widget.redirectUri != null && widget.redirectUri!.isNotEmpty
          ? widget.redirectUri!
          : '/';
      context.go(target);
    }
  }
}
```

*Analisis Kunci*:
- Parameter `redirectUri`: Jika pengguna tadinya sedang berada di keranjang belanja dan ingin menuju `/checkout`, sistem membawa parameter `?redirect=/checkout`. Begitu tombol "Masuk Sekarang" berhasil ditekan, pengguna langsung diantarkan mulus ke halaman Checkout tanpa harus mengulang navigasi dari Beranda.

---

## E. PERSIAPAN PRAKTIKUM & SETUP DEPENDENSI

### E.1 Dependensi `pubspec.yaml`
Pastikan paket `flutter_secure_storage: ^9.0.0` telah terdaftar pada seksi `dependencies` di berkas [pubspec.yaml](file:///home/arif/flutter-1/sayur_hub/pubspec.yaml):

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^6.1.0
  go_router: ^14.0.0
  provider: ^6.1.2
  shared_preferences: ^2.2.2
  sqflite: ^2.3.2
  path: ^1.9.0
  dio: ^5.4.3+1
  shimmer: ^3.0.0
  flutter_secure_storage: ^9.0.0  # Penyimpanan Hardware Keystore Terenkripsi
```

Jalankan perintah sinkronisasi paket:
```bash
flutter pub get
```

### E.2 Konfigurasi MinSdkVersion Android
Pustaka `flutter_secure_storage` membutuhkan minimal **API Level 21 (Android 5.0 Lollipop)** untuk mendukung enkripsi standar. Buka berkas `android/app/build.gradle` dan pastikan konfigurasi berikut terpenuhi:

```groovy
android {
    defaultConfig {
        minSdkVersion 21 // Minimal Android API 21
        targetSdkVersion 34
    }
}
```

---

## F. LANGKAH DEMI LANGKAH PRAKTIKUM (STEP-BY-STEP TUTORIAL)

### Langkah 1: Membangun `SecureStorageService`
1. Buka direktori `lib/core/services/`.
2. Buat berkas `secure_storage_service.dart`.
3. Inisialisasi `FlutterSecureStorage` dengan opsi `encryptedSharedPreferences: true`.
4. Definisikan metode `saveUserSession()`, `getToken()`, `getUserSession()`, dan `clearAuth()`.

### Langkah 2: Mengembangkan `AuthProvider`
1. Buka direktori `lib/core/providers/`.
2. Buat berkas `auth_provider.dart` yang mewarisi `ChangeNotifier`.
3. Implementasikan fungsi `checkAuthStatus()`, `login()`, `register()`, dan `logout()`.

### Langkah 3: Mengaitkan Auth Interceptor pada `ApiClient`
1. Buka [api_client.dart](file:///home/arif/flutter-1/sayur_hub/lib/core/network/api_client.dart).
2. Pada bagian `onRequest`, ambil token JWT dari `SecureStorageService.instance.getToken()`.
3. Jika token ada, tambahkan header `options.headers['Authorization'] = 'Bearer $token'`.
4. Pada bagian `onError`, periksa jika `statusCode == 401`, eksekusi `SecureStorageService.instance.clearAuth()`.

### Langkah 4: Membangun Layar Masuk Akun `LoginScreen`
1. Buat folder baru `lib/features/auth/`.
2. Buat berkas `login_screen.dart`.
3. Bangun formulir login dengan validasi regex email dan toggle visibilitas kata sandi (`obscureText`).
4. Hubungkan tombol masuk dengan `context.read<AuthProvider>().login()`.

### Langkah 5: Memasang Route Guard Proteksi Rute di `AppRouter`
1. Buka [app_router.dart](file:///home/arif/flutter-1/sayur_hub/lib/core/routes/app_router.dart).
2. Daftarkan rute `/login`.
3. Pasang parameter `refreshListenable: authProvider`.
4. Definisikan aturan `redirect`:
   - Jika pengguna belum login dan mencoba membuka rute `/checkout`, belokkan (*redirect*) ke `/login?redirect=/checkout`.
   - Jika pengguna sudah login dan mencoba membuka `/login`, belokkan kembali ke beranda `/`.

### Langkah 6: Mengintegrasikan Layar Profil `ProfileScreen`
1. Buka [profile_screen.dart](file:///home/arif/flutter-1/sayur_hub/lib/features/profile/profile_screen.dart).
2. Gunakan `context.watch<AuthProvider>()`.
3. Jika pengguna belum login, tampilkan tombol ajakan masuk akun.
4. Jika sudah login, tampilkan data pengguna riil, badge token JWT aktif, dan tombol keluar akun (*Logout*) disertai dialog konfirmasi.

### Langkah 7: Pengujian Menyeluruh Skenario Route Guard & Multi-Role
1. Buka aplikasi, masukkan bayam ke keranjang belanja, lalu buka `CartScreen`.
2. Tekan tombol **"Lanjutkan ke Checkout Alamat"**.
3. Amati bagaimana Route Guard secara otomatis menghadang dan mengalihkan Anda ke halaman `LoginScreen`!
4. Di halaman `LoginScreen`, siswa dapat menguji dua skenario peran (*role*):
   - **Peran Konsumen (Customer)**: Tekan tombol bantuan *"Demo Customer"* (`siti@smkrpl.sch.id` / `password123`), lalu klik *"Masuk Sekarang"*. Amati bagaimana aplikasi secara cerdas langsung mengantarkan Anda kembali ke halaman `CheckoutScreen` untuk menyelesaikan pesanan!
   - **Peran Administrator Gudang**: Tekan tombol bantuan *"Demo Admin"* (`admin@sayurhub.id` / `admin123`), lalu klik *"Masuk Sekarang"*. Buka menu **Profil** di pojok kanan bawah, dan amati munculnya badge emas `ROLE: ADMINISTRATOR` serta **Panel Kontrol Gudang & Toko** untuk memantau stok komoditas dan status API!

---

## G. ANALISIS & PEMAHAMAN MENDALAM

### G.1 Mengapa Header Bernama "Authorization: Bearer <token>"?
Format `Bearer <token>` adalah spesifikasi resmi **OAuth 2.0 (RFC 6750)**:
- Kata **Bearer** berarti *"siapa pun yang memegang token ini berhak atas hak akses yang melekat padanya"*.
- Peladen backend tidak perlu memeriksa basis data untuk mengetahui apakah email dan password pengguna benar pada setiap request; peladen cukup memverifikasi stempel digital (*Signature*) pada token JWT. Hal ini sangat menghemat beban komputasi server.

---

### G.2 Mengapa `refreshListenable` Sangat Penting di GoRouter?
Jika Anda tidak menyematkan `refreshListenable: authProvider` pada konfigurasi `GoRouter`:
- Saat pengguna berhasil login, variabel `isAuthenticated` di `AuthProvider` bernilai `true`.
- Namun, GoRouter tidak mengetahui bahwa state telah berubah.
- Akibatnya, pengguna tetap tertahan di halaman login atau aplikasi harus di-restart manual.
- Dengan `refreshListenable`, setiap kali `notifyListeners()` dipanggil di dalam `AuthProvider`, GoRouter secara otomatis mengeksekusi ulang seluruh pohon rute dan mengevaluasi fungsi `redirect()` secara instan!

---

## H. LATIHAN MANDIRI & TANTANGAN TERSTRUKTUR

### H.1 Latihan Teori (5 Soal Pilihan Ganda & Analisis)

1. **Soal**: Manakah dari informasi berikut yang TIDAK PERNAH boleh disimpan di dalam Payload JSON Web Token (JWT)?
   - A. ID unik pengguna (`sub: "USR-001"`).
   - B. Waktu kedaluwarsa token (`exp: 1800000000`).
   - C. Kata sandi mentah pengguna (`password: "rahasia123"`).
   - D. Peran otorisasi pengguna (`role: "customer"`).
   *Kunci Jawaban*: **C**. Payload JWT tidak dienkripsi melainkan hanya di-encode dalam Base64URL, sehingga data rahasia seperti kata sandi tidak boleh disertakan.

2. **Soal**: Mengapa kita menggunakan pustaka `flutter_secure_storage` dan bukan `shared_preferences` untuk menyimpan token JWT?
   - A. `flutter_secure_storage` membuat ukuran file APK lebih kecil.
   - B. `flutter_secure_storage` mengenkripsi data di tingkat perangkat keras menggunakan Android KeyStore dan iOS Keychain Services.
   - C. `shared_preferences` tidak mendukung tipe data String.
   - D. `shared_preferences` hanya bisa berjalan jika ada koneksi internet.
   *Kunci Jawaban*: **B**. Keamanan tingkat perangkat keras (*Hardware-backed security*) melindungi token dari pencurian data pada perangkat yang di-*root*.

3. **Soal**: Apa fungsi utama parameter `redirect` pada konfigurasi deklaratif `GoRouter`?
   - A. Menutup aplikasi secara paksa jika terjadi error.
   - B. Menerapkan *Route Guards* untuk mengarahkan pengguna ke rute lain berdasarkan kondisi tertentu (misal: belum terotentikasi).
   - C. Mempercepat proses rendering animasi transisi halaman.
   - D. Mengompresi gambar sayuran sebelum diunggah ke server.
   *Kunci Jawaban*: **B**. `redirect` bertindak sebagai penjaga gerbang navigasi aplikasi.

4. **Soal**: Kode status HTTP berapakah yang secara universal mengindikasikan bahwa token JWT yang dikirimkan telah kedaluwarsa atau tidak sah?
   - A. HTTP 200 OK
   - B. HTTP 400 Bad Request
   - C. HTTP 401 Unauthorized
   - D. HTTP 500 Internal Server Error
   *Kunci Jawaban*: **C**. HTTP 401 secara spesifik menandakan kegagalan otentikasi identitas klien.

5. **Soal**: Di dalam format JWT, tanda titik (`.`) berfungsi sebagai:
   - A. Karakter penutup kalimat.
   - B. Tanda pemisah antara Header, Payload, dan Digital Signature.
   - C. Operator perkalian dalam matematika.
   - D. Pengganti spasi pada URL.
   *Kunci Jawaban*: **B**. Tanda titik membagi string JWT menjadi tiga segmen komponen utama.

---

### H.2 Latihan Praktik (3 Soal Coding Hands-On)

1. **Praktik 1: Validasi Kata Sandi Kuat (Strong Password Regex)**
   - *Tugas*: Pada form `LoginScreen`, tambahkan validator kata sandi yang mewajibkan minimal 8 karakter, memuat minimal 1 huruf besar, 1 huruf kecil, dan 1 angka. Tampilkan pesan kesalahan yang mendidik jika kriteria belum terpenuhi.
2. **Praktik 2: Fitur Tampilkan/Sembunyikan Cuplikan Token JWT**
   - *Tugas*: Pada layar profil `ProfileScreen`, buat tombol kecil berbentuk mata di samping badge JWT. Jika ditekan, tampilkan dialog yang memperlihatkan 3 segmen token JWT dengan pewarnaan berbeda (Header warna merah, Payload warna ungu, Signature warna biru).
3. **Praktik 3: Dialog Konfirmasi Pembatalan Checkout Saat Redirect**
   - *Tugas*: Saat pengguna diarahkan ke layar Login dari halaman Checkout, tambahkan tombol "Batalkan & Kembali Belanja" yang mengantarkan pengguna kembali ke keranjang tanpa harus masuk akun.

---

### H.3 Tantangan Pemrograman (2 Tantangan Studi Kasus Lanjutan)

1. **Tantangan 1: Alur Pembaruan Token Otomatis (Silent Token Refresh via Refresh Token)**
   - *Skenario*: Token akses (*Access Token*) memiliki masa kedaluwarsa pendek (misal: 15 menit), sedangkan *Refresh Token* memiliki masa aktif 30 hari.
   - *Instruksi*: Modifikasi `AuthInterceptor` pada Dio. Ketika menerima balasan HTTP 401, jangan langsung me-logout pengguna. Kirimkan permintaan latar belakang `POST /api/v1/auth/refresh` membawa *refresh token*. Jika berhasil, simpan access token baru ke secure storage dan ulangi permintaan yang sempat gagal tadi secara otomatis tanpa disadari oleh pengguna!
2. **Tantangan 2: Autentikasi Biometrik (Fingerprint / Face ID)**
   - *Skenario*: Pengguna ingin masuk ke SayurHub menggunakan sidik jari tanpa perlu mengetik kata sandi setiap kali membuka aplikasi.
   - *Instruksi*: Rancang diagram alur arsitektur bagaimana pustaka `local_auth` dapat diintegrasikan dengan `SecureStorageService` untuk membuka kunci token JWT.

---

### H.4 Studi Kasus Riil Industri (1 Kasus Nyata)
* **Kasus**: Skenario Token Expired di Tengah Proses Pembayaran SayurHub.
* **Kebutuhan Lapangan**:
  Seorang pengguna memilih 5 kg sayur, mengisi formulir pengiriman, dan siap menekan tombol bayar. Namun, karena ia sempat menerima telepon selama 20 menit, token sesi JWT kedaluwarsa tepat saat tombol bayar ditekan.
* **Tantangan**:
  Bagaimana arsitektur SayurHub menangani situasi ini agar:
  1. Data belanjaan yang sudah diisi di formulir checkout **TIDAK HILANG**.
  2. Pengguna cukup diminta memasukkan kata sandi / biometrik di dialog kecil *pop-up*.
  3. Setelah terverifikasi, transaksi pembayaran langsung dilanjutkan secara otomatis.

---

## I. TROUBLESHOOTING & SOLUSI PRAKTIS

### Error 1: `PlatformException(SecurityException, W/KeyStore: KeyStore exception ...)` pada Emulator
* **Gejala**: Aplikasi crash saat pertama kali memanggil `_storage.write()` di Android Emulator lama.
* **Penyebab**: Perangkat emulator tidak memiliki kunci layar (*Screen Lock PIN/Pattern*) aktif atau menggunakan image Android tanpa Google Play Services yang mendukung hardware keystore.
* **Solusi**:
  1. Pasang PIN atau Pola kunci layar pada menu Pengaturan (*Settings -> Security -> Screen Lock*) di emulator.
  2. Pastikan `AndroidOptions(encryptedSharedPreferences: true)` telah diaktifkan pada kode inisialisasi.

### Error 2: Terjadi Perulangan Tanpa Henti (*Infinite Redirect Loop*) pada GoRouter
* **Gejala**: Aplikasi freeze atau layar berkedip cepat tanpa henti antara halaman Login dan Beranda.
* **Penyebab**: Logika `redirect` mengarahkan pengguna ke `/login`, namun di dalam halaman `/login`, kondisi redirect kembali terpenuhi dan mengarahkan ke `/login` lagi.
* **Solusi**: Pastikan selalu menyertakan pengecekan:
  ```dart
  final bool isLoggingIn = state.matchedLocation == '/login';
  if (isCheckoutRoute && !loggedIn) {
    return isLoggingIn ? null : '/login';
  }
  ```

### Error 3: Token Bearer Tidak Ikut Terkirim pada Panggilan API Tertentu
* **Gejala**: Server backend selalu membalas HTTP 401 meskipun pengguna sudah login.
* **Penyebab**: Pemanggilan API menggunakan instansi `Dio()` baru yang dibuat secara lokal, bukan menggunakan singleton `ApiClient.instance.dio` yang telah dipasangi Interceptor.
* **Solusi**: Selalu gunakan `ApiClient.instance.dio` sebagai penyedia klien HTTP utama di seluruh *service layer*.

---

## J. PRAKTIKUM INTEGRASI ANTAR-MODUL

Berikut adalah peta integrasi alur keamanan identitas pada ekosistem SayurHub:

```text
[Modul 13: Checkout Form] ──(Tekan Bayar)──> [Modul 17: GoRouter Route Guard]
                                                     │
                                       (Belum Login? Redirect!)
                                                     ▼
[Modul 17: SecureStorage] <──(Simpan Token)── [Modul 17: LoginScreen]
          │
          ▼ (Sematkan Bearer Token)
[Modul 16: Dio ApiClient] ──(Kirim Pesanan)──> [Peladen Backend Server]
```

### Verifikasi Validasi Keamanan via Skrip CLI (`modul_17_auth_security_demo.dart`)
Jalankan berkas [modul_17_auth_security_demo.dart](file:///home/arif/flutter-1/sayur_hub/bin/modul_17_auth_security_demo.dart) di terminal untuk memvalidasi pemodelan JWT dan logika proteksi rute:

```bash
dart run bin/modul_17_auth_security_demo.dart
```

*Keluaran Pengujian yang Diharapkan*:
```text
================================================================
       SAYURHUB MODUL 17: JWT AUTH & SECURITY SIMULATION        
================================================================

[1] ANATOMI STRUKTUR JSON WEB TOKEN (JWT)
Panjang total token: 235 karakter
Bagian 1 (Header Base64Url):    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
Bagian 2 (Payload Claims):      eyJzdWIiOiJVU1ItMDAxIiwibmFtZSI6IlNpdGkgTnVyaGFsaXphIiwiZW1haWwiOiJzaXRpQHNta3JwbC5zY2guaWQiLCJyb2xlIjoiY3VzdG9tZXIiLCJleHAiOjE4MDAwMDAwMDB9
Bagian 3 (Digital Signature):   sEcUrE_SiGnAtUrE_sAyUrHuB_2026

[2] DEKODING PAYLOAD CLAIMS JWT
Klaim Identitas Terbaca:
  - sub: USR-001
  - name: Siti Nurhaliza
  - email: siti@smkrpl.sch.id
  - role: customer
  - exp: 1800000000

[3] SIMULASI PENYIMPANAN AMAN (FLUTTER_SECURE_STORAGE)
Data dalam Hardware Keystore (Terenkripsi):
  - [jwt_access_token] => eyJhbGciOiJIUzI1NiIsInR5...
  - [user_id] => USR-001
  - [user_email] => siti@smkrpl.sch.id

[4] SIMULASI ROUTE GUARD GOROUTER (LOGIKA PROTEKSI RUTE)

Skenario A: Tamu (Guest) mencoba membuka Checkout
  🚫 Akses ke "/checkout" DITOLAK! Pengguna belum login -> Redirect ke /login?redirect=/checkout

Skenario B: Pengguna Terotentikasi membuka Checkout
  ✅ Akses ke "/checkout" DIIZINKAN (Status login: true).

[5] SIMULASI AUTH INTERCEPTOR PADA DIO CLIENT
Header HTTP siap dikirim:
  Authorization: Bearer eyJhbGciOiJIUzI1NiIsIn...

================================================================
  SEMUA VALIDASI KEAMANAN & AUTENTIKASI (MODUL 17) BERHASIL 100%! 
================================================================
```

---

## K. EVALUASI MODUL & RUBRIK PENILAIAN

### K.1 Format Rubrik Penilaian Portofolio Siswa (Skala 1 - 4)

| Kriteria Penilaian | Skor 1 (Perlu Bimbingan) | Skor 2 (Cukup) | Skor 3 (Baik) | Skor 4 (Sangat Memuaskan / Profesional) |
| :--- | :--- | :--- | :--- | :--- |
| **Arsitektur Keamanan Kredensial** | Masih menyimpan token JWT di SharedPreferences teks biasa. | Menggunakan `flutter_secure_storage` namun opsi enkripsi AndroidKeyStore belum diaktifkan. | Menyimpan token dan data sesi menggunakan hardware keystore secara aman dan terisolasi. | Arsitektur brankas sangat tangguh, mendukung pembersihan sesi menyeluruh saat logout, dan siap enkripsi biometrik. |
| **Penerapan Auth Interceptor** | Token disisipkan secara manual di setiap fungsi HTTP terpisah. | Menggunakan interceptor namun belum menangani kondisi token kosong atau galat 401. | Interceptor otomatis menyematkan header `Authorization: Bearer` dan menangkap status 401. | Interceptor sangat rapi, logging informatif di konsol, dan dilengkapi mekanisme auto-logout terpadu. |
| **Implementasi Route Guards** | Tidak ada proteksi rute; siapa pun bisa mengakses form checkout tanpa login. | Proteksi rute menggunakan navigasi imperatif manual yang rentan bocor (*bypassable*). | Menggunakan parameter `redirect` deklaratif pada GoRouter terhubung `refreshListenable`. | Route Guard sempurna, menangani URL callback redirect dinamis pasca-login, bebas *infinite redirect loop*. |
| **Desain Antarmuka Login & UX** | Form login tidak memiliki validasi format email atau tombol sembunyikan password. | Form tervalidasi namun tidak memberikan pesan kesalahan yang jelas saat autentikasi gagal. | Tampilan login Material 3 rapi, validasi regex email kuat, toggle obscure password mulus. | Dilengkapi tombol demo praktikum, penanganan status loading halus, transisi mulus, dan terintegrasi profil. |

---

### K.2 Lembar Refleksi Diri Siswa
1. Apa bahaya terbesar yang dapat terjadi jika sebuah aplikasi e-commerce menyimpan token JWT di SharedPreferences biasa?
2. Mengapa mekanisme *Redirect Callback* (kembali ke halaman asal setelah login) sangat disenangi oleh pengguna aplikasi?
3. Ceritakan bagaimana perasaan Anda ketika melihat Route Guard berhasil menghadang Anda saat mencoba checkout tanpa login!

---

## L. KESIMPULAN & JEMBATAN KE MODUL BERIKUTNYA

### L.1 Rangkuman Modul 17
Sebuah tonggak pencapaian monumental! Aplikasi SayurHub Anda kini telah dipersenjatai dengan sistem pertahanan siber berstandar industri perbankan:
1. **Identitas Terverifikasi**: Alur autentikasi berbasis JSON Web Token (JWT) menjamin setiap transaksi belanja terlacak kepada pemilik akun yang sah.
2. **Kerahasiaan Tingkat Militer**: Kredensial token tersimpan aman di dalam brankas hardware (*Android Keystore & iOS Keychain*) melalui `flutter_secure_storage`.
3. **Otomatisasi Jaringan**: Melalui *Auth Interceptor* pada Dio, setiap permintaan ke server secara otomatis membawa identitas pengguna tanpa membebani kode antarmuka.
4. **Proteksi Gerbang Rute**: *Route Guards* pada GoRouter memastikan area sensitif seperti Checkout dan Pengaturan Akun terlindungi rapat dari akses tanpa izin.

### L.2 Menuju Modul 18: Arsitektur Feature-First / Clean Architecture
Saat ini, aplikasi SayurHub telah memiliki belasan fitur hebat: keranjang belanja, SQLite offline, REST API Dio, Shimmer loading, dan Autentikasi JWT. Namun, perhatikan struktur proyek kita:
- Logika pemanggilan API, query database, manipulasi model data, dan penyajian antarmuka mulai tersebar di banyak folder yang berpotensi saling tumpang tindih seiring bertambahnya fitur.
- Di industri skala besar (seperti Gojek, Tokopedia, atau Shopee), puluhan pengembang bekerja bersamaan pada satu proyek. Tanpa arsitektur modular yang baku, kode akan mengalami konflik (*merge conflict*) dan sulit diuji (*unit testing*).

Oleh karena itu, pada **Modul 18: Arsitektur Feature-First dan Clean Architecture**, kita akan mempelajari:
- Membedah prinsip **Clean Architecture** ala Robert C. Martin (Uncle Bob): Pemisahan menjadi **3 Lapisan Utama (Domain Layer, Data Layer, Presentation Layer)**.
- Menerapkan modularisasi **Feature-First**: Mengelompokkan kode berdasarkan modul fitur (Auth, Catalog, Cart, Order, Profile).
- Menerapkan **Pola Repositori (Repository Pattern)**: Mengisolasi sumber data (*Remote Data Source* vs *Local Data Source*) dari logika bisnis inti (*Use Cases*).

Persiapkan diri Anda untuk menata ulang SayurHub menjadi mahakarya arsitektur perangkat lunak skala enterprise!
