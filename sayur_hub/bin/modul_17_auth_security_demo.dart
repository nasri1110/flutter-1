import 'dart:convert';

void main() {
  print('================================================================');
  print('       SAYURHUB MODUL 17: JWT AUTH & SECURITY SIMULATION        ');
  print('================================================================');

  print('\n[1] ANATOMI STRUKTUR JSON WEB TOKEN (JWT)');
  // Contoh token JWT 3-bagian: Header.Payload.Signature
  const String sampleJwt =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJVU1ItMDAxIiwibmFtZSI6IlNpdGkgTnVyaGFsaXphIiwiZW1haWwiOiJzaXRpQHNta3JwbC5zY2guaWQiLCJyb2xlIjoiY3VzdG9tZXIiLCJleHAiOjE4MDAwMDAwMDB9.sEcUrE_SiGnAtUrE_sAyUrHuB_2026';

  final List<String> parts = sampleJwt.split('.');
  print('Panjang total token: ${sampleJwt.length} karakter');
  print('Bagian 1 (Header Base64Url):    ${parts[0]}');
  print('Bagian 2 (Payload Claims):      ${parts[1]}');
  print('Bagian 3 (Digital Signature):   ${parts[2]}');

  print('\n[2] DEKODING PAYLOAD CLAIMS JWT');
  String normalizedPayload = base64Url.normalize(parts[1]);
  final String decodedJsonString = utf8.decode(base64Url.decode(normalizedPayload));
  final Map<String, dynamic> claims = jsonDecode(decodedJsonString) as Map<String, dynamic>;

  print('Klaim Identitas Terbaca:');
  claims.forEach((k, v) => print('  - $k: $v'));

  assert(claims['sub'] == 'USR-001');
  assert(claims['email'] == 'siti@smkrpl.sch.id');
  assert(claims['role'] == 'customer');

  print('\n[3] SIMULASI PENYIMPANAN AMAN (FLUTTER_SECURE_STORAGE)');
  final Map<String, String> simulatedKeystore = {};
  simulatedKeystore['jwt_access_token'] = sampleJwt;
  simulatedKeystore['user_id'] = claims['sub'] as String;
  simulatedKeystore['user_email'] = claims['email'] as String;

  print('Data dalam Hardware Keystore (Terenkripsi):');
  simulatedKeystore.forEach((k, v) {
    final preview = v.length > 25 ? '${v.substring(0, 25)}...' : v;
    print('  - [$k] => $preview');
  });

  print('\n[4] SIMULASI ROUTE GUARD GOROUTER (LOGIKA PROTEKSI RUTE)');
  bool testRouteGuard({required bool isLoggedIn, required String targetRoute}) {
    final bool isProtected = targetRoute == '/checkout' || targetRoute.startsWith('/profile');
    if (isProtected && !isLoggedIn) {
      print('  🚫 Akses ke "$targetRoute" DITOLAK! Pengguna belum login -> Redirect ke /login?redirect=$targetRoute');
      return false;
    } else {
      print('  ✅ Akses ke "$targetRoute" DIIZINKAN (Status login: $isLoggedIn).');
      return true;
    }
  }

  print('\nSkenario A: Tamu (Guest) mencoba membuka Checkout');
  testRouteGuard(isLoggedIn: false, targetRoute: '/checkout');

  print('\nSkenario B: Pengguna Terotentikasi membuka Checkout');
  testRouteGuard(isLoggedIn: true, targetRoute: '/checkout');

  print('\n[5] SIMULASI AUTH INTERCEPTOR PADA DIO CLIENT');
  final Map<String, dynamic> mockHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  final String? activeToken = simulatedKeystore['jwt_access_token'];
  if (activeToken != null) {
    mockHeaders['Authorization'] = 'Bearer $activeToken';
    print('Header HTTP siap dikirim:');
    print('  Authorization: ${mockHeaders['Authorization'].substring(0, 30)}...');
  }

  print('\n================================================================');
  print('  SEMUA VALIDASI KEAMANAN & AUTENTIKASI (MODUL 17) BERHASIL 100%! ');
  print('================================================================');
}
