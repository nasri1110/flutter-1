import 'package:sayur_hub/features/catalog/domain/entities/product_entity.dart';

/// Kontrak Repositori (Repository Interface) pada Domain Layer.
/// Menerapkan prinsip Dependency Inversion Principle (DIP):
/// Lapisan Domain menentukan apa yang dibutuhkan, bukan bagaimana data diambil.
abstract class ProductRepository {
  /// Mengambil daftar komoditas produk dengan filter kategori dan pencarian opsional
  Future<List<ProductEntity>> getProducts({
    String? category,
    String? search,
  });

  /// Mengambil detail satu produk komoditas berdasarkan ID uniknya
  Future<ProductEntity> getProductById(String id);
}
