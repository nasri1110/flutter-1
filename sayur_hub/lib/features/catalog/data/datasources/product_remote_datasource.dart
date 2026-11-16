import 'package:dio/dio.dart';
import 'package:sayur_hub/core/exceptions/app_exceptions.dart';
import 'package:sayur_hub/core/network/api_client.dart';
import 'package:sayur_hub/features/catalog/data/models/product_model.dart';

/// Kontrak sumber data jarak jauh (Remote Data Source Interface)
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? category, String? search});
  Future<ProductModel> getProductById(String id);
}

/// Implementasi sumber data jarak jauh menggunakan klien HTTP Dio
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  @override
  Future<List<ProductModel>> getProducts({String? category, String? search}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (category != null && category.isNotEmpty && category != 'Semua') {
        queryParams['category'] = category;
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final response = await _dio.get(
        '/products',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : {'data': response.data};

        final List<dynamic> dataList = body['data'] as List<dynamic>? ?? [];

        return dataList
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw NetworkException('Gagal memuat produk dari server. Kode: ${response.statusCode}');
      }
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Terjadi kendala jaringan: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _dio.get('/products/$id');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
        return ProductModel.fromJson(data);
      } else {
        throw ProductNotFoundException(id);
      }
    } catch (e) {
      throw NetworkException('Gagal mengambil detail produk: $e');
    }
  }
}
