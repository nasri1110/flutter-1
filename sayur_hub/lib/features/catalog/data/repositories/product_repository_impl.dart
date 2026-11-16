import 'package:flutter/foundation.dart';
import 'package:sayur_hub/core/exceptions/app_exceptions.dart';
import 'package:sayur_hub/features/catalog/data/datasources/product_local_datasource.dart';
import 'package:sayur_hub/features/catalog/data/datasources/product_remote_datasource.dart';
import 'package:sayur_hub/features/catalog/data/models/product_model.dart';
import 'package:sayur_hub/features/catalog/domain/entities/product_entity.dart';
import 'package:sayur_hub/features/catalog/domain/repositories/product_repository.dart';

/// Implementasi Repositori Katalog Produk pada Data Layer.
/// Menerapkan pola Offline-First Cache-Then-Network:
/// Menggabungkan Remote Data Source dan Local Data Source secara transparan bagi UI.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl({
    ProductRemoteDataSource? remoteDataSource,
    ProductLocalDataSource? localDataSource,
  })  : _remoteDataSource = remoteDataSource ?? ProductRemoteDataSourceImpl(),
        _localDataSource = localDataSource ?? ProductLocalDataSourceImpl();

  @override
  Future<List<ProductEntity>> getProducts({
    String? category,
    String? search,
  }) async {
    try {
      // 1. Ambil data segar dari server REST API
      final List<ProductModel> remoteProducts =
          await _remoteDataSource.getProducts(category: category, search: search);

      // 2. Simpan cadangan ke cache SQLite secara asinkron
      try {
        await _localDataSource.cacheProducts(remoteProducts);
      } catch (cacheError) {
        debugPrint('Peringatan: Gagal menyimpan cache lokal: $cacheError');
      }

      return remoteProducts;
    } on NetworkException catch (networkError) {
      debugPrint('Koneksi daring bermasalah: $networkError. Beralih ke cache lokal SQLite...');

      // 3. Mekanisme Fallback Offline: Membaca cache dari SQLite jika jaringan bermasalah
      final List<ProductModel> cachedProducts =
          await _localDataSource.getCachedProducts(category: category, search: search);

      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }

      // Jika cache juga kosong, lempar galat asli
      rethrow;
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    return await _remoteDataSource.getProductById(id);
  }
}
