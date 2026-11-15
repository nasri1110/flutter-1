import 'package:flutter/foundation.dart';
import 'package:sayur_hub/core/database/database_helper.dart';

/// Provider pengelola state daftar favorit / wishlist produk terpusat SayurHub.
/// Terintegrasi dengan SQLite DatabaseHelper untuk persistensi offline permanen.
class WishlistProvider extends ChangeNotifier {
  // Set penyimpan ID produk yang difavoritkan (mencegah duplikasi ID)
  final Set<String> _favoriteProductIds = {};
  bool _isLoading = true;

  /// Status apakah data wishlist sedang dimuat dari SQLite
  bool get isLoading => _isLoading;

  /// Mengambil Set ID produk favorit dalam format unmodifiable
  Set<String> get favoriteProductIds => Set.unmodifiable(_favoriteProductIds);

  /// Menghitung total produk favorit
  int get count => _favoriteProductIds.length;

  /// Mengecek apakah produk dengan ID tertentu difavoritkan
  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  /// Sinkronisasi awal: Memuat daftar produk favorit dari basis data SQLite lokal
  Future<void> initializeFromDatabase() async {
    _isLoading = true;
    notifyListeners();

    try {
      final Set<String> persistedFavorites =
          await DatabaseHelper.instance.getAllFavoriteIds();
      _favoriteProductIds.clear();
      _favoriteProductIds.addAll(persistedFavorites);
    } catch (e) {
      debugPrint('Galat memuat data favorit dari SQLite: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle status favorit (tambah jika belum ada, hapus jika sudah ada) & simpan ke SQLite
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
      notifyListeners();
      await DatabaseHelper.instance.removeFavorite(productId);
    } else {
      _favoriteProductIds.add(productId);
      notifyListeners();
      await DatabaseHelper.instance.addFavorite(productId);
    }
  }

  /// Menghapus produk dari wishlist dan SQLite
  Future<void> removeFavorite(String productId) async {
    if (_favoriteProductIds.remove(productId)) {
      notifyListeners();
      await DatabaseHelper.instance.removeFavorite(productId);
    }
  }

  /// Mengosongkan seluruh daftar favorit
  Future<void> clearWishlist() async {
    _favoriteProductIds.clear();
    notifyListeners();
    await DatabaseHelper.instance.clearAllFavorites();
  }
}
