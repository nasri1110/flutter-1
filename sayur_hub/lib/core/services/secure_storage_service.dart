import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Layanan penyimpanan kredensial dan token JWT terenkripsi tingkat perangkat keras (Hardware Keystore / Keychain).
class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  // Konfigurasi enkripsi hardware untuk Android Keystore dan iOS Keychain
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _keyToken = 'jwt_access_token';
  static const String _keyRefreshToken = 'jwt_refresh_token';
  static const String _keyUserId = 'auth_user_id';
  static const String _keyUserName = 'auth_user_name';
  static const String _keyUserEmail = 'auth_user_email';
  static const String _keyUserPhone = 'auth_user_phone';
  static const String _keyUserAddress = 'auth_user_address';

  /// Menyimpan token akses JWT
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Membaca token akses JWT
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Menyimpan data sesi pengguna lengkap
  Future<void> saveUserSession({
    required String token,
    required String id,
    required String name,
    required String email,
    required String phone,
    required String address,
    String? refreshToken,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyUserId, value: id);
    await _storage.write(key: _keyUserName, value: name);
    await _storage.write(key: _keyUserEmail, value: email);
    await _storage.write(key: _keyUserPhone, value: phone);
    await _storage.write(key: _keyUserAddress, value: address);
    if (refreshToken != null) {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
    }
  }

  /// Membaca data profil pengguna dari secure storage
  Future<Map<String, String?>> getUserSession() async {
    final token = await _storage.read(key: _keyToken);
    final id = await _storage.read(key: _keyUserId);
    final name = await _storage.read(key: _keyUserName);
    final email = await _storage.read(key: _keyUserEmail);
    final phone = await _storage.read(key: _keyUserPhone);
    final address = await _storage.read(key: _keyUserAddress);

    return {
      'token': token,
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  /// Menghapus seluruh token dan sesi saat logout
  Future<void> clearAuth() async {
    await _storage.deleteAll();
  }
}
