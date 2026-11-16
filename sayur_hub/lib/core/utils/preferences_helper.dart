import 'package:shared_preferences/shared_preferences.dart';

/// Utilitas pembungkus SharedPreferences (Key-Value Store) resmi aplikasi SayurHub.
/// Digunakan untuk menyimpan konfigurasi ringan, status onboarding, dan preferensi pengguna.
class PreferencesHelper {
  PreferencesHelper._();

  // Kunci identifikasi penyimpanan lokal
  static const String _keyOnboardingDone = 'has_completed_onboarding';
  static const String _keyCourierPreference = 'preferred_courier';
  static const String _keyFreshInsuranceDefault = 'default_fresh_insurance';
  static const String _keyNotificationActive = 'is_notification_active';

  /// Memeriksa apakah pengguna telah menyelesaikan layar onboarding
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  /// Menandai bahwa pengguna telah menyelesaikan orientasi aplikasi
  static Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingDone, value);
  }

  /// Mengambil opsi kurir favorit yang tersimpan (default: INSTANT)
  static Future<String> getPreferredCourier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCourierPreference) ?? 'INSTANT';
  }

  /// Menyimpan preferensi kurir pengguna
  static Future<void> setPreferredCourier(String courierCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCourierPreference, courierCode);
  }

  /// Mengambil preferensi apakah proteksi garansi kesegaran aktif otomatis
  static Future<bool> isFreshInsuranceDefault() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFreshInsuranceDefault) ?? true;
  }

  /// Menyimpan preferensi garansi kesegaran
  static Future<void> setFreshInsuranceDefault(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFreshInsuranceDefault, isEnabled);
  }

  /// Menghapus seluruh data konfigurasi lokal (misal saat logout pengguna)
  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
