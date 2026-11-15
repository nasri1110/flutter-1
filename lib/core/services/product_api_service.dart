import 'package:dio/dio.dart';
import 'package:sayur_hub/core/exceptions/app_exceptions.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/network/api_client.dart';

/// Layanan jaringan resmi untuk mengakses data katalog sayur dan buah dari endpoint REST API
class ProductApiService {
  final Dio _dio;

  ProductApiService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  /// Mengambil daftar seluruh produk dari endpoint GET /products
  /// Mendukung filter kategori opsional dan kata kunci pencarian
  Future<List<Product>> getProducts({
    String? category,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (category != null && category.isNotEmpty && category != 'Semua') {
        queryParams['category'] = category;
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      // Simulasi latensi jaringan nyata (1 detik) untuk mendemonstrasikan Shimmer loading
      await Future.delayed(const Duration(milliseconds: 1000));

      final response = await _dio.get(
        '/products',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : {'data': response.data};

        final List<dynamic> dataList = body['data'] as List<dynamic>? ?? [];

        List<Product> products = dataList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();

        // Penyaringan di level klien jika mock API mengembalikan seluruh data
        if (category != null && category.isNotEmpty && category != 'Semua') {
          products = products.where((p) => p.category == category).toList();
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = search.trim().toLowerCase();
          products = products
              .where((p) => p.name.toLowerCase().contains(query))
              .toList();
        }

        return products;
      } else {
        throw NetworkException(
          'Gagal memuat produk dari server. Kode respon: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Koneksi internet lambat (Timeout). Silakan periksa jaringan Anda.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('Tidak ada koneksi internet. Pastikan perangkat terhubung.');
      } else {
        throw NetworkException('Terjadi kesalahan jaringan: ${e.message}');
      }
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Terjadi kesalahan sistem yang tidak diharapkan: $e');
    }
  }

  /// Mengambil detail satu produk komoditas berdasarkan ID
  Future<Product> getProductById(String id) async {
    try {
      final response = await _dio.get('/products/$id');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
        return Product.fromJson(data);
      } else {
        throw ProductNotFoundException(id);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ProductNotFoundException(id);
      }
      throw NetworkException('Gagal mengambil data produk: ${e.message}');
    }
  }
}
