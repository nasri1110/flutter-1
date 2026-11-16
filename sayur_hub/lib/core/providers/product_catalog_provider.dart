import 'package:flutter/foundation.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/features/catalog/data/models/product_model.dart';
import 'package:sayur_hub/features/catalog/data/repositories/product_repository_impl.dart';
import 'package:sayur_hub/features/catalog/domain/entities/product_entity.dart';
import 'package:sayur_hub/features/catalog/domain/usecases/get_products_usecase.dart';

/// Status siklus hidup permintaan jaringan katalog
enum CatalogStatus { initial, loading, success, error }

/// Provider pengelola state katalog produk SayurHub pada Presentation Layer
/// Mendukung arsitektur Clean Architecture dan Infinite Scroll Pagination
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

  // Properti Pagination Tanpa Batas (Infinite Scroll Pagination)
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // Getters publik
  List<Product> get products => List.unmodifiable(_products);
  CatalogStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  bool get isLoading => _status == CatalogStatus.loading;
  bool get isSuccess => _status == CatalogStatus.success;
  bool get isError => _status == CatalogStatus.error;
  bool get isEmpty => _status == CatalogStatus.success && _products.isEmpty;

  /// Memuat katalog produk awal melalui eksekusi GetProductsUseCase
  Future<void> fetchCatalog({bool isRefresh = false}) async {
    if (!isRefresh) {
      _status = CatalogStatus.loading;
      _errorMessage = null;
      notifyListeners();
    }

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;

    try {
      final List<ProductEntity> entities = await _getProductsUseCase.call(
        category: _selectedCategory,
        search: _searchQuery,
      );

      // Konversi domain entities ke Product model yang dipahami UI
      _products = entities.map((e) => ProductModel.fromEntity(e).toProduct()).toList();
      _status = CatalogStatus.success;
      _errorMessage = null;

      // Jika jumlah produk awal kurang dari 4, tandai tidak ada halaman berikutnya
      if (_products.length < 4) {
        _hasMore = false;
      }
    } catch (e) {
      _status = CatalogStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }

  /// Memuat halaman komoditas berikutnya saat pengguna menggulir ke titik bawah layar
  Future<void> loadMoreProducts() async {
    // Penjaga: Jangan memuat jika sedang memuat, tidak ada lagi data, atau sedang error
    if (_isLoadingMore || !_hasMore || _status == CatalogStatus.loading) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    // Simulasi latensi pemuatan halaman berikutnya (1 detik)
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      // Memuat data tambahan untuk demonstrasi pagination
      final int nextPage = _currentPage + 1;

      // Buat beberapa komoditas batch berikutnya
      final List<Product> nextBatch = [
        Product(
          id: 'PAGE$nextPage-01',
          name: 'Selada Keriting Organik (Batch $nextPage)',
          category: 'Sayuran Daun',
          pricePerKg: 15000.0,
          stock: 30,
          rating: 4.8,
          isOrganic: true,
          description: 'Selada hidroponik renyah segar panen pagi hari.',
        ),
        Product(
          id: 'PAGE$nextPage-02',
          name: 'Jeruk Sunkist Petani Malang (Batch $nextPage)',
          category: 'Buah Segar',
          pricePerKg: 28000.0,
          stock: 20,
          rating: 4.9,
          isOrganic: false,
          description: 'Jeruk manis berair tinggi vitamin C.',
        ),
      ];

      _products.addAll(nextBatch);
      _currentPage = nextPage;

      // Batasi hingga halaman 3 untuk demonstrasi kurikulum praktikum
      if (_currentPage >= 3) {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('Galat memuat halaman berikutnya: $e');
    } finally {
      _isLoadingMore = false;
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
