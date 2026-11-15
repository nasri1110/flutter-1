import 'package:flutter/foundation.dart';

/// Provider pengelola state daftar favorit / wishlist produk terpusat SayurHub.
class WishlistProvider extends ChangeNotifier {
  // Set penyimpan ID produk yang difavoritkan (mencegah duplikasi ID)
  final Set<String> _favoriteProductIds = {};

  /// Mengambil Set ID produk favorit dalam format unmodifiable
  Set<String> get favoriteProductIds => Set.unmodifiable(_favoriteProductIds);

  /// Menghitung total produk favorit
  int get count => _favoriteProductIds.length;

  /// Mengecek apakah produk dengan ID tertentu difavoritkan
  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  /// Toggle status favorit (tambah jika belum ada, hapus jika sudah ada)
  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  /// Menghapus produk dari wishlist
  void removeFavorite(String productId) {
    if (_favoriteProductIds.remove(productId)) {
      notifyListeners();
    }
  }

  /// Mengosongkan seluruh daftar favorit
  void clearWishlist() {
    _favoriteProductIds.clear();
    notifyListeners();
  }
}
