import 'package:flutter/foundation.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/features/catalog/data/models/product_model.dart';
import 'package:sayur_hub/features/catalog/data/repositories/product_repository_impl.dart';
import 'package:sayur_hub/features/catalog/domain/entities/product_entity.dart';
import 'package:sayur_hub/features/catalog/domain/usecases/get_products_usecase.dart';

/// Status siklus hidup permintaan jaringan katalog
enum CatalogStatus { initial, loading, success, error }

/// Provider pengelola state katalog produk SayurHub pada Presentation Layer
/// Menggunakan Clean Architecture: Hanya berkomunikasi dengan Domain Layer melalui Use Case.
class ProductCatalogProvider extends ChangeNotifier {
  final GetProductsUseCase _getProductsUseCase;

  ProductCatalogProvider({GetProductsUseCase? getProductsUseCase})
      : _getProductsUseCase = getProductsUseCase ??
            GetProductsUseCase(ProductRepositoryImpl());

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

  /// Memuat katalog produk melalui eksekusi GetProductsUseCase
  Future<void> fetchCatalog({bool isRefresh = false}) async {
    if (!isRefresh) {
      _status = CatalogStatus.loading;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final List<ProductEntity> entities = await _getProductsUseCase.call(
        category: _selectedCategory,
        search: _searchQuery,
      );

      // Konversi domain entities ke Product model yang dipahami UI
      _products = entities.map((e) => ProductModel.fromEntity(e).toProduct()).toList();
      _status = CatalogStatus.success;
      _errorMessage = null;
    } catch (e) {
      _status = CatalogStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }

  /// Mengubah filter kategori dan memuat ulang use case
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
