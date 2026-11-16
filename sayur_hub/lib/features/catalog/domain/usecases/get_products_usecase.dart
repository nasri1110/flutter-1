import 'package:sayur_hub/features/catalog/domain/entities/product_entity.dart';
import 'package:sayur_hub/features/catalog/domain/repositories/product_repository.dart';

/// Kasus Penggunaan (Use Case): Mengambil daftar produk komoditas sayur dan buah.
/// Mengikuti prinsip Single Responsibility Principle (SRP):
/// Satu kelas Use Case hanya bertanggung jawab untuk satu tindakan bisnis spesifik.
class GetProductsUseCase {
  final ProductRepository _repository;

  const GetProductsUseCase(this._repository);

  /// Menjalankan use case dengan parameter filter kategori dan kata kunci pencarian
  Future<List<ProductEntity>> call({
    String? category,
    String? search,
  }) async {
    return await _repository.getProducts(
      category: category,
      search: search,
    );
  }
}
