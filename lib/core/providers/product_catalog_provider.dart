import 'package:flutter/foundation.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/services/product_api_service.dart';

/// Status siklus hidup permintaan jaringan katalog
enum CatalogStatus { initial, loading, success, error }

/// Provider pengelola state katalog produk SayurHub yang bersumber dari REST API
class ProductCatalogProvider extends ChangeNotifier {
  final ProductApiService _apiService;

  ProductCatalogProvider({ProductApiService? apiService})
      : _apiService = apiService ?? ProductApiService();

  List<Product> _products = [];
  CatalogStatus _status = CatalogStatus.initial;
  String? _errorMessage;
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  // Getters publik
  List<Product> get products => List.unmodifiable(_products);
  CatalogStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  bool get isLoading => _status == CatalogStatus.loading;
  bool get isSuccess => _status == CatalogStatus.success;
  bool get isError => _status == CatalogStatus.error;
  bool get isEmpty => _status == CatalogStatus.success && _products.isEmpty;

  /// Memuat katalog produk dari REST API
  Future<void> fetchCatalog({bool isRefresh = false}) async {
    // Jika bukan refresh layar (pull-to-refresh), aktifkan status loading
    if (!isRefresh) {
      _status = CatalogStatus.loading;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final List<Product> result = await _apiService.getProducts(
        category: _selectedCategory,
        search: _searchQuery,
      );

      _products = result;
      _status = CatalogStatus.success;
      _errorMessage = null;
    } catch (e) {
      _status = CatalogStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }

  /// Mengubah filter kategori dan memuat ulang data dari API
  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    fetchCatalog();
  }

  /// Mencari produk berdasarkan kata kunci
  void search(String query) {
    _searchQuery = query;
    fetchCatalog();
  }

  /// Mencoba ulang memuat data saat terjadi error jaringan
  void retry() {
    fetchCatalog();
  }
}
