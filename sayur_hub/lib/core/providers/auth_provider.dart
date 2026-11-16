import 'package:flutter/foundation.dart';
import 'package:sayur_hub/core/models/user.dart';
import 'package:sayur_hub/core/services/profile_photo_service.dart';
import 'package:sayur_hub/core/services/secure_storage_service.dart';

/// Provider pengelola status autentikasi, sesi login, dan token JWT SayurHub.
/// Mengontrol Route Guard GoRouter melalui pemanggilan notifyListeners().
class AuthProvider extends ChangeNotifier {
  final SecureStorageService _storageService;

  AuthProvider({SecureStorageService? storageService})
      : _storageService = storageService ?? SecureStorageService.instance;

  User? _currentUser;
  String? _token;
  String? _profilePhotoUrl;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters publik
  User? get currentUser => _currentUser;
  String? get token => _token;
  String? get profilePhotoUrl => _profilePhotoUrl;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Memeriksa apakah token JWT sudah ada di dalam FlutterSecureStorage saat aplikasi dibuka
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
      } else {
        _isAuthenticated = false;
        _currentUser = null;
        _token = null;
      }
    } catch (e) {
      debugPrint('Galat memeriksa sesi auth: $e');
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Masuk ke akun pengguna dengan email dan kata sandi
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulasi latensi verifikasi kredensial ke endpoint POST /api/v1/auth/login
    await Future.delayed(const Duration(milliseconds: 1200));

    try {
      // Validasi kredensial (Contoh kredensial demo untuk praktikum siswa)
      if (email.trim().toLowerCase() == 'siti@smkrpl.sch.id' && password == 'password123') {
        const String mockJwtToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJVU1ItMDAxIiwibmFtZSI6IlNpdGkgTnVyaGFsaXphIiwiZW1haWwiOiJzaXRpQHNta3JwbC5zY2guaWQiLCJyb2xlIjoiY3VzdG9tZXIiLCJleHAiOjE4MDAwMDAwMDB9.sEcUrE_SiGnAtUrE_sAyUrHuB_2026';

        final user = User(
          id: 'USR-001',
          fullName: 'Siti Nurhaliza',
          phoneNumber: '081234567890',
          email: email.trim(),
          address: 'Jl. Merdeka No. 45, Bandung Barat',
        );

        // Simpan token dan profil ke hardware keystore
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
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email atau kata sandi tidak valid. Coba: siti@smkrpl.sch.id / password123';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Pendaftaran akun konsumen baru
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    try {
      const String mockJwtToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJVU1ItTkVXIiwibmFtZSI6IkJhcnUiLCJleHAiOjE4MDAwMDAwMDB9.nEwUsEr_sAyUrHuB_2026';

      final user = User(
        id: 'USR-${DateTime.now().millisecondsSinceEpoch}',
        fullName: name,
        phoneNumber: phone,
        email: email,
        address: address,
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
    } catch (e) {
      _errorMessage = 'Gagal mendaftar: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Memperbarui foto profil akun pengguna via multipart upload
  Future<bool> updateProfilePhoto(
    String filePath, {
    void Function(int sent, int total)? onProgress,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final String? newUrl = await ProfilePhotoService.instance.uploadProfilePhoto(
        filePath: filePath,
        onProgress: onProgress,
      );

      if (newUrl != null) {
        _profilePhotoUrl = newUrl;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Galat memperbarui foto profil: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Keluar dari sesi dan membersihkan token dari hardware keystore
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _storageService.clearAuth();
    _token = null;
    _currentUser = null;
    _profilePhotoUrl = null;
    _isAuthenticated = false;
    _isLoading = false;
    notifyListeners();
  }
}
