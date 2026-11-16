import 'package:flutter/foundation.dart';
import 'package:sayur_hub/core/database/database_helper.dart';
import 'package:sayur_hub/core/models/cart_item.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

/// Provider pengelola state keranjang belanja terpusat (App State) SayurHub.
/// Terintegrasi dengan SQLite DatabaseHelper untuk persistensi offline permanen.
class CartProvider extends ChangeNotifier {
  // Map internal berpasangan: Map<ProductId, CartItem>
  final Map<String, CartItem> _items = {};
  bool _isLoading = true;

  /// Status apakah data keranjang sedang dimuat dari basis data SQLite
  bool get isLoading => _isLoading;

  /// Mengambil daftar item keranjang dalam bentuk List read-only
  List<CartItem> get items => _items.values.toList();

  /// Menghitung total seluruh kuantitas item (dalam satuan kilogram)
  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity.toInt());

  /// Menghitung total varian produk yang ada di dalam keranjang
  int get uniqueItemCount => _items.length;

  /// Mengecek apakah keranjang kosong
  bool get isEmpty => _items.isEmpty;

  /// Menghitung subtotal kotor sebelum diskon dan ongkos kirim
  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.subtotal);

  /// Menghitung diskon promo otomatis: 10% jika subtotal >= Rp 50.000
  double get discountAmount {
    if (subtotal >= 50000.0) {
      return PriceCalculator.calculateDiscountAmount(
        subtotal: subtotal,
        discountPercentage: 10.0,
      );
    }
    return 0.0;
  }

  /// Menghitung grand total final setelah dikurangi diskon promo
  double get grandTotal => subtotal - discountAmount;

  /// Memeriksa apakah produk tertentu sudah berada di dalam keranjang
  bool isInCart(String productId) => _items.containsKey(productId);

  /// Mengambil kuantitas produk tertentu dalam keranjang
  double getProductQuantity(String productId) =>
      _items[productId]?.quantity ?? 0.0;

  /// Sinkronisasi awal: Memuat keranjang belanja dari SQLite lokal saat aplikasi dimulai
  Future<void> initializeFromDatabase() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<CartItem> persistedItems =
          await DatabaseHelper.instance.getAllCartItems();
      _items.clear();
      for (final item in persistedItems) {
        _items[item.product.id] = item;
      }
    } catch (e) {
      debugPrint('Galat memuat data keranjang dari SQLite: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menambahkan produk ke keranjang belanja & menyimpan ke SQLite
  Future<void> addItem(Product product, [double quantity = 1.0]) async {
    if (_items.containsKey(product.id)) {
      final CartItem current = _items[product.id]!;
      final CartItem updated = current.copyWith(
        quantity: current.quantity + quantity,
      );
      _items[product.id] = updated;
      notifyListeners();
      await DatabaseHelper.instance.insertOrUpdateCartItem(updated);
    } else {
      final CartItem newItem = CartItem(
        product: product,
        quantity: quantity,
      );
      _items[product.id] = newItem;
      notifyListeners();
      await DatabaseHelper.instance.insertOrUpdateCartItem(newItem);
    }
  }

  /// Mengurangi 1 kuantitas produk & sinkronisasi ke SQLite
  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) return;

    final CartItem current = _items[productId]!;
    if (current.quantity > 1.0) {
      final CartItem updated = current.copyWith(
        quantity: current.quantity - 1.0,
      );
      _items[productId] = updated;
      notifyListeners();
      await DatabaseHelper.instance.updateCartItemQuantity(productId, updated.quantity);
    } else {
      _items.remove(productId);
      notifyListeners();
      await DatabaseHelper.instance.deleteCartItem(productId);
    }
  }

  /// Menghapus produk secara permanen dari keranjang dan SQLite
  Future<void> removeItem(String productId) async {
    if (_items.remove(productId) != null) {
      notifyListeners();
      await DatabaseHelper.instance.deleteCartItem(productId);
    }
  }

  /// Memperbarui kuantitas secara langsung (misal via input teks)
  Future<void> updateQuantity(String productId, double quantity) async {
    if (!_items.containsKey(productId)) return;

    if (quantity <= 0) {
      await removeItem(productId);
    } else {
      final CartItem updated =
          _items[productId]!.copyWith(quantity: quantity);
      _items[productId] = updated;
      notifyListeners();
      await DatabaseHelper.instance.updateCartItemQuantity(productId, quantity);
    }
  }

  /// Mengosongkan seluruh isi keranjang dari memori RAM dan SQLite
  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();
    await DatabaseHelper.instance.clearAllCartItems();
  }
}
