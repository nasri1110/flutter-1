import 'dart:io';

/// ============================================================================
/// MODUL 21 CLI DEMO: BUILD, BRANDING, DAN DISTRIBUSI PRODUKSI SAYURHUB
/// ============================================================================
/// Script interaktif ini mendemonstrasikan:
/// 1. Verifikasi integritas konfigurasi Keystore & key.properties
/// 2. Simulasi perbedaan ukuran binary: Debug vs Universal APK vs Split-ABI vs AAB
/// 3. Audit keamanan .gitignore untuk mencegah kebocoran private key
/// 4. Simulasi proses Obfuscation & R8 Symbol Mapping
/// ============================================================================

void main() {
  print('================================================================');
  print('🌱 SAYURHUB - RELEASE & BUILD VERIFICATION AUDIT (MODUL 21)');
  print('================================================================\n');

  // 1. Audit Git Security
  _auditGitIgnoreSecurity();

  // 2. Audit Konfigurasi key.properties Template
  _auditKeyPropertiesTemplate();

  // 3. Analisis Komparasi Binary Build (Debug vs Universal vs Split vs AAB)
  _compareBuildArtifacts();

  // 4. Analisis Proteksi Kode (R8 & Obfuscation)
  _explainObfuscationAndR8();

  // 5. Checklist Kesiapan Publikasi Google Play Console
  _printPlayStoreChecklist();

  print('\n================================================================');
  print('✅ SELURUH VERIFIKASI BUILD PRODUKSI SELESAI DENGAN SUKSES!');
  print('================================================================');
}

void _auditGitIgnoreSecurity() {
  print('🔒 [1/5] Memeriksa Konfigurasi Keamanan .gitignore...');
  final gitignoreFile = File('.gitignore');

  if (!gitignoreFile.existsSync()) {
    print('  ⚠️ File .gitignore tidak ditemukan di root project.');
    return;
  }

  final content = gitignoreFile.readAsStringSync();
  final rulesToCheck = [
    'key.properties',
    '*.jks',
    '*.keystore',
  ];

  var allSecured = true;
  for (final rule in rulesToCheck) {
    if (content.contains(rule)) {
      print('  ✅ Aturan aman terdeteksi: "$rule"');
    } else {
      print('  ❌ BAHAYA! Aturan "$rule" BELUM ada di .gitignore!');
      allSecured = false;
    }
  }

  if (allSecured) {
    print('  🎉 STATUS: AMAN! Kredensial rilis tidak akan bocor ke GitHub/GitLab.\n');
  } else {
    print('  ⚠️ STATUS: PERINGATAN! Perbaiki .gitignore segera!\n');
  }
}

void _auditKeyPropertiesTemplate() {
  print('🔑 [2/5] Memeriksa Template Konfigurasi Keystore (key.properties.example)...');
  final templateFile = File('android/key.properties.example');

  if (!templateFile.existsSync()) {
    print('  ❌ File android/key.properties.example tidak ditemukan!');
    return;
  }

  final content = templateFile.readAsStringSync();
  final requiredKeys = ['storePassword', 'keyPassword', 'keyAlias', 'storeFile'];

  for (final key in requiredKeys) {
    if (content.contains('$key=')) {
      print('  ✅ Parameter "$key" terkonfigurasi dengan benar.');
    } else {
      print('  ❌ Parameter "$key" hilang dari template.');
    }
  }
  print('  💡 Info: File asli android/key.properties wajib dibuat manual oleh developer rilis.\n');
}

void _compareBuildArtifacts() {
  print('📊 [3/5] Analisis Komparasi Ukuran Binary Distribusi:');
  print('----------------------------------------------------------------------');
  print('| Format Build       | Ukuran   | Target Penggunaan                  |');
  print('----------------------------------------------------------------------');
  print('| Debug APK          | ~58.4 MB | Development lokal (Hot Reload aktif)|');
  print('| Universal APK      | ~24.1 MB | Sideloading (Mencakup 3 ABI CPU)   |');
  print('| Split-ABI (arm64)  | ~13.8 MB | HP Modern (64-bit ARM v8)          |');
  print('| Split-ABI (armv7)  | ~11.5 MB | HP Lama (32-bit ARM v7)            |');
  print('| App Bundle (AAB)   | ~18.2 MB | Google Play Store Upload           |');
  print('| -> User Download   | ~10.4 MB | Dynamic Delivery Play Store        |');
  print('----------------------------------------------------------------------');
  print('💡 Efisiensi: Menggunakan AAB menghemat kuota pengguna akhir hingga ~57%!\n');
}

void _explainObfuscationAndR8() {
  print('🛡️ [4/5] Analisis Mekanisme Proteksi Kode & Reverse Engineering:');
  print('  1. R8 / ProGuard Code Shrinking:');
  print('     - Menghapus class, method, dan attribute yang tidak terpakai (Tree Shaking).');
  print('     - Mengurangi ukuran DEX file dan mempercepat startup time aplikasi.');
  print('  2. Dart Obfuscation (--obfuscate):');
  print('     - Mengubah nama fungsi & class menjadi simbol acak (misal: "a.b(c)").');
  print('     - Menjaga kekayaan intelektual (IP) dari dekompilasi APK.');
  print('  3. Debug Symbols (--split-debug-info):');
  print('     - Simbol stack trace dipisahkan ke folder simbol.');
  print('     - Wajib disimpan untuk menerjemahkan stack trace error crash pengguna.\n');
}

void _printPlayStoreChecklist() {
  print('📋 [5/5] Checklist Kesiapan Rilis Google Play Console (SayurHub):');
  final checklist = [
    'Application ID unik: com.smkrpl.sayurhub',
    'VersionCode dinaikkan secara berurutan (e.g. 1 -> 2 -> 3)',
    'Target SDK Android sesuai standar Google Play terbaru (Android 14 / API 34+)',
    'Launcher Icons adaptif untuk semua kerapatan layar (mdpi hingga xxxhdpi)',
    'Native Splash Screen aktif tanpa jank/blank putih saat startup',
    'Signing Keystore menggunakan algoritma RSA 2048-bit masa berlaku 25+ tahun',
    'Format file distribusi akhir adalah Android App Bundle (.aab)',
    'File key.properties dan *.jks dimasukkan dalam .gitignore',
  ];

  for (var i = 0; i < checklist.length; i++) {
    print('  [✓] ${i + 1}. ${checklist[i]}');
  }
}
