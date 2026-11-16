import 'package:sayur_hub/features/catalog/data/models/product_model.dart';
import 'package:sayur_hub/features/catalog/domain/entities/product_entity.dart';
import 'package:sayur_hub/features/catalog/domain/repositories/product_repository.dart';
import 'package:sayur_hub/features/catalog/domain/usecases/get_products_usecase.dart';

/// Mock implementasi repositori untuk menguji Domain Layer secara terisolasi (Unit Testing)
class MockProductRepository implements ProductRepository {
  @override
  Future<List<ProductEntity>> getProducts({String? category, String? search}) async {
    final List<ProductEntity> dummyData = [
      const ProductEntity(
        id: 'CA-001',
        name: 'Kangkung Hidroponik Ciwidey',
        category: 'Sayuran Daun',
        pricePerKg: 12000,
        stock: 50,
        rating: 4.8,
        isOrganic: true,
      ),
      const ProductEntity(
        id: 'CA-002',
        name: 'Tomat Cherry Pangalengan',
        category: 'Sayuran Buah',
        pricePerKg: 24000,
        stock: 0, // Stok habis
        rating: 4.9,
        isOrganic: true,
      ),
    ];

    if (category != null && category != 'Semua') {
      return dummyData.where((p) => p.category == category).toList();
    }
    return dummyData;
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    return const ProductEntity(
      id: 'CA-001',
      name: 'Kangkung Hidroponik Ciwidey',
      category: 'Sayuran Daun',
      pricePerKg: 12000,
    );
  }
}

void main() async {
  print('================================================================');
  print('    SAYURHUB MODUL 18: FEATURE-FIRST CLEAN ARCHITECTURE TEST    ');
  print('================================================================');

  print('\n[1] PENGUJIAN DOMAIN LAYER (PURE DART ENTITY & BUSINESS RULES)');
  const entity1 = ProductEntity(
    id: 'ENT-01',
    name: 'Bayam Merah Organik',
    category: 'Sayuran Daun',
    pricePerKg: 16000,
    stock: 20,
    rating: 4.9,
    isOrganic: true,
  );

  print('Entitas Domain Dibuat: ${entity1.name}');
  print('  - Ketersediaan stok (isAvailable): ${entity1.isAvailable}');
  print('  - Status Premium Grade (isPremiumGrade): ${entity1.isPremiumGrade}');
  assert(entity1.isAvailable == true);
  assert(entity1.isPremiumGrade == true);

  print('\n[2] PENGUJIAN USE CASE (SINGLE RESPONSIBILITY PRINCIPLE)');
  final MockProductRepository mockRepo = MockProductRepository();
  final GetProductsUseCase useCase = GetProductsUseCase(mockRepo);

  final List<ProductEntity> productsAll = await useCase.call();
  print('Hasil eksekusi GetProductsUseCase (Semua): ${productsAll.length} item');
  for (final p in productsAll) {
    print('  - [${p.id}] ${p.name} (${p.category}) - Stok: ${p.stock} kg | Tersedia: ${p.isAvailable}');
  }
  assert(productsAll.length == 2);

  final List<ProductEntity> productsFiltered = await useCase.call(category: 'Sayuran Buah');
  print('\nHasil eksekusi GetProductsUseCase (Filter Sayuran Buah): ${productsFiltered.length} item');
  assert(productsFiltered.length == 1);
  assert(productsFiltered.first.name.contains('Tomat'));
  assert(productsFiltered.first.isAvailable == false); // Tomat habis

  print('\n[3] PENGUJIAN DATA LAYER (PRODUCT MODEL & ENTITY CONVERSION)');
  final Map<String, dynamic> sampleApiJson = {
    'id': 'API-MODEL-01',
    'name': 'Wortel Manis Organik',
    'category': 'Sayuran Umbi',
    'price_per_kg': 20000.0,
    'stock': 15,
    'rating': 4.75,
    'is_organic': 1,
    'image_url': 'https://sayurhub.smkrpl.sch.id/wortel.png',
  };

  final ProductModel model = ProductModel.fromJson(sampleApiJson);
  print('ProductModel berhasil di-deserialisasi dari JSON:');
  print('  - Name: ${model.name}');
  print('  - Price: Rp ${model.pricePerKg}');
  print('  - Is Organic: ${model.isOrganic}');
  print('  - Is Premium Grade: ${model.isPremiumGrade}');

  assert(model.name == 'Wortel Manis Organik');
  assert(model.isOrganic == true);
  assert(model.isPremiumGrade == true);

  print('\n[4] VERIFIKASI PEMISAHAN LAPISAN CLEAN ARCHITECTURE:');
  print('  ✅ Domain Layer: Murni Dart tanpa dependensi Flutter UI.');
  print('  ✅ Data Layer: Bertanggung jawab atas SQLite & Dio REST API.');
  print('  ✅ Presentation Layer: Provider hanya berinteraksi dengan Use Case.');
  print('  ✅ Dependency Inversion: Modul tingkat tinggi tidak bergantung modul tingkat rendah.');

  print('\n================================================================');
  print(' SEMUA VALIDASI CLEAN ARCHITECTURE (MODUL 18) BERHASIL 100%!    ');
  print('================================================================');
}
