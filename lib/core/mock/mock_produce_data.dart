/// Kumpulan data tiruan resmi katalog SayurHub (Mock Data)
/// Mewakili respon JSON yang kelak akan diterima dari REST API Backend
class MockProduceData {
  MockProduceData._();

  static final List<Map<String, dynamic>> rawProducts = [
    {
      'id': 'PROD-001',
      'name': 'Bayam Hijau Hidroponik',
      'category': 'Sayuran Daun',
      'pricePerKg': 14000.0,
      'stock': 35,
      'rating': 4.8,
      'isOrganic': true,
    },
    {
      'id': 'PROD-002',
      'name': 'Kangkung Segar Kebun',
      'category': 'Sayuran Daun',
      'pricePerKg': 9000.0,
      'stock': 50,
      'rating': 4.6,
      'isOrganic': false,
    },
    {
      'id': 'PROD-003',
      'name': 'Alpukat Mentega Super',
      'category': 'Buah Segar',
      'pricePerKg': 32000.0,
      'stock': 20,
      'rating': 4.9,
      'isOrganic': true,
    },
    {
      'id': 'PROD-004',
      'name': 'Wortel Manis Berastagi',
      'category': 'Umbi-umbian',
      'pricePerKg': 18000.0,
      'stock': 0, // Stok kosong (Habis)
      'rating': 4.5,
      'isOrganic': false,
    },
    {
      'id': 'PROD-005',
      'name': 'Pisang Sunpride Cavendish',
      'category': 'Buah Segar',
      'pricePerKg': 24000.0,
      'stock': 18,
      'rating': 4.7,
      'isOrganic': false,
    },
    {
      'id': 'PROD-006',
      'name': 'Bawang Merah Brebes',
      'category': 'Bumbu Dapur',
      'pricePerKg': 38000.0,
      'stock': 15,
      'rating': 4.8,
      'isOrganic': false,
    },
  ];
}
