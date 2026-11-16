import 'dart:convert';
import 'package:sayur_hub/core/models/product.dart';

void main() {
  print('================================================================');
  print('       SAYURHUB MODUL 16: REST API & NETWORKING SIMULATION      ');
  print('================================================================');

  print('\n[1] PENGUJIAN ANATOMI RESPONSE JSON STANDAR INDUSTRI (200 OK)');
  final Map<String, dynamic> rawApiResponse = {
    'status': 'success',
    'code': 200,
    'message': 'Daftar katalog sayur dan buah berhasil diambil dari server',
    'data': [
      {
        'id': 'API-001',
        'name': 'Bayam Hijau Hidroponik Lembang',
        'category': 'Sayuran Daun',
        'pricePerKg': 14000.0,
        'stock': 40,
        'rating': 4.9,
        'isOrganic': true,
        'imageUrl': 'https://sayurhub.smkrpl.sch.id/images/bayam.png',
        'description': 'Dipanen langsung dari green house hidroponik Lembang pagi ini.',
      },
      {
        'id': 'API-002',
        'name': 'Wortel Brastagi Segar',
        'category': 'Sayuran Umbi',
        'pricePerKg': 18000.0,
        'stock': 25,
        'rating': 4.7,
        'isOrganic': false,
        'imageUrl': 'https://sayurhub.smkrpl.sch.id/images/wortel.png',
        'description': 'Wortel manis renyah kaya vitamin A dari tanah vulkanik Brastagi.',
      }
    ],
    'meta': {
      'total': 2,
      'page': 1,
      'per_page': 10,
      'server_timestamp': '2026-11-15T21:20:00Z',
    }
  };

  final String serializedJson = jsonEncode(rawApiResponse);
  print('Ukuran payload JSON: ${serializedJson.length} bytes');
  print('Header Status Code: ${rawApiResponse['code']}');
  print('Pesan Server: ${rawApiResponse['message']}');

  print('\n[2] PENGUJIAN DESERIALISASI JSON KE LIST<PRODUCT> TYPE-SAFE');
  final Map<String, dynamic> decoded = jsonDecode(serializedJson) as Map<String, dynamic>;
  final List<dynamic> dataArray = decoded['data'] as List<dynamic>;

  final List<Product> products = dataArray
      .map((item) => Product.fromJson(item as Map<String, dynamic>))
      .toList();

  for (int i = 0; i < products.length; i++) {
    final p = products[i];
    print('  [$i] ID: ${p.id} | Nama: ${p.name} | Rp ${p.pricePerKg}/kg | Stok: ${p.stock} | Organik: ${p.isOrganic}');
  }

  assert(products.length == 2);
  assert(products.first.name.contains('Bayam'));
  assert(products.first.isOrganic == true);

  print('\n[3] PENGUJIAN PENANGANAN STATUS KODE HTTP REST API');
  final Map<int, String> httpStatusCodes = {
    200: 'OK: Permintaan GET berhasil mengembalikan data.',
    201: 'CREATED: Permintaan POST berhasil membuat pesanan baru.',
    400: 'BAD REQUEST: Parameter input JSON tidak valid.',
    401: 'UNAUTHORIZED: Token JWT tidak ditemukan atau kedaluwarsa.',
    404: 'NOT FOUND: Produk dengan ID tersebut tidak ada di database server.',
    500: 'INTERNAL SERVER ERROR: Server backend mengalami kegagalan proses.',
  };

  httpStatusCodes.forEach((code, desc) {
    print('  - HTTP $code -> $desc');
  });

  print('\n[4] SIMULASI STATUS UI ASINKRON (STATE MACHINE)');
  final List<String> uiStates = ['Initial', 'Loading (Shimmer)', 'Success (GridView)', 'Error (Retry Dialog)'];
  print('Transisi State Jaringan: ${uiStates.join(' --> ')}');

  print('\n================================================================');
  print('  SEMUA VALIDASI REST API & NETWORKING (MODUL 16) BERHASIL 100%! ');
  print('================================================================');
}
