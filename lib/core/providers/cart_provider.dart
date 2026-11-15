import 'package:flutter/foundation.dart';
import 'package:sayur_hub/core/models/cart_item.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

/// Provider pengelola state keranjang belanja terpusat (App State) SayurHub.
/// Menggunakan ChangeNotifier untuk memicu re-render reaktif pada widget Consumer.
class CartProvider extends ChangeNotifier {
  // Map internal berpasangan: Map<ProductId, CartItem>
  final Map<String, CartItem> _items = {};

  /// Mengambil daftar item keranjang dalam bentuk List read-only
  List<CartItem> get items => _items.values.toList();

  /// Menghitung total seluruh kuantitas item (bukan hanya jumlah varian produk)
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

  /// Menambahkan produk ke keranjang belanja
  /// Jika produk sudah ada, kuantitasnya akan ditambahkan
  void addItem(Product product, [double quantity = 1.0]) {
    if (_items.containsKey(product.id)) {
      final CartItem current = _items[product.id]!;
      _items[product.id] = current.copyWith(
        quantity: current.quantity + quantity,
      );
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  /// Mengurangi 1 kuantitas produk. Jika sisa 1 dan dikurangi, produk dihapus dari keranjang
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    final CartItem current = _items[productId]!;
    if (current.quantity > 1.0) {
      _items[productId] = current.copyWith(
        quantity: current.quantity - 1.0,
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  /// Menghapus seluruh baris produk dari keranjang belanja tanpa peduli jumlah kuantitasnya
  void removeItem(String productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
    }
  }

  /// Memperbarui kuantitas secara absolut (misal dari input textfield atau counter)
  void updateQuantity(String productId, double quantity) {
    if (!_items.containsKey(productId)) return;

    if (quantity <= 0) {
      removeItem(productId);
    } else {
      _items[productId] = _items[productId]!.copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  /// Mengosongkan seluruh isi keranjang belanja (setelah checkout berhasil)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
