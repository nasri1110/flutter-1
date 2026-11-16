import 'package:sayur_hub/features/catalog/domain/entities/product_entity.dart';
import 'package:sayur_hub/features/catalog/domain/repositories/product_repository.dart';

/// Kasus Penggunaan (Use Case): Mengambil rincian informasi spesifik satu produk komoditas.
class GetProductDetailUseCase {
  final ProductRepository _repository;

  const GetProductDetailUseCase(this._repository);

  Future<ProductEntity> call(String productId) async {
    return await _repository.getProductById(productId);
  }
}
