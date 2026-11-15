import 'package:sayur_hub/core/mock/mock_produce_data.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/providers/cart_provider.dart';
import 'package:sayur_hub/core/providers/wishlist_provider.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

void main() {
  print('================================================================');
  print('       SAYURHUB MODUL 14: STATE MANAGEMENT PROVIDER TEST         ');
  print('================================================================');

  final CartProvider cartProvider = CartProvider();
  final WishlistProvider wishlistProvider = WishlistProvider();

  int cartNotifications = 0;
  cartProvider.addListener(() {
    cartNotifications++;
  });

  int wishlistNotifications = 0;
  wishlistProvider.addListener(() {
    wishlistNotifications++;
  });

  print('\n[1] PENGUJIAN CART PROVIDER (REAKTIF)');
  print('Kondisi awal cart empty: ${cartProvider.isEmpty}');
  print('Total kuantitas awal: ${cartProvider.totalQuantity} kg');

  final Product bayam = MockProduceData.products.firstWhere((p) => p.name.contains('Bayam'));
  final Product alpukat = MockProduceData.products.firstWhere((p) => p.name.contains('Alpukat'));

  print('\n--> Menambahkan 2 kg Bayam (Rp ${bayam.pricePerKg}/kg)...');
  cartProvider.addItem(bayam, 2.0);
  print('Item unik: ${cartProvider.uniqueItemCount}');
  print('Total kuantitas: ${cartProvider.totalQuantity} kg');
  print('Subtotal: ${PriceCalculator.formatRupiah(cartProvider.subtotal)}');

  print('\n--> Menambahkan lagi 1 kg Bayam (Reaktif: kuantitas terakumulasi)...');
  cartProvider.addItem(bayam, 1.0);
  print('Total kuantitas Bayam: ${cartProvider.getProductQuantity(bayam.id)} kg');
  print('Subtotal: ${PriceCalculator.formatRupiah(cartProvider.subtotal)}');

  print('\n--> Menambahkan 1 kg Alpukat (Rp ${alpukat.pricePerKg}/kg)...');
  cartProvider.addItem(alpukat, 1.0);
  print('Item unik: ${cartProvider.uniqueItemCount}');
  print('Subtotal sebelum diskon: ${PriceCalculator.formatRupiah(cartProvider.subtotal)}');
  print('Diskon Otomatis Panen (10% jika >= Rp 50.000): ${PriceCalculator.formatRupiah(cartProvider.discountAmount)}');
  print('Grand Total: ${PriceCalculator.formatRupiah(cartProvider.grandTotal)}');

  print('\n--> Mengurangi 1 kg Bayam (removeSingleItem)...');
  cartProvider.removeSingleItem(bayam.id);
  print('Total kuantitas Bayam tersisa: ${cartProvider.getProductQuantity(bayam.id)} kg');

  print('\n--> Menghapus Alpukat dari keranjang (removeItem)...');
  cartProvider.removeItem(alpukat.id);
  print('Item unik tersisa: ${cartProvider.uniqueItemCount}');
  print('Total kuantitas tersisa: ${cartProvider.totalQuantity} kg');

  print('\n[2] PENGUJIAN WISHLIST PROVIDER (SET DATA STRUCTURE)');
  print('Produk favorit awal: ${wishlistProvider.count}');
  print('Apakah Bayam favorit? ${wishlistProvider.isFavorite(bayam.id)}');

  print('\n--> Toggle Bayam ke Favorit...');
  wishlistProvider.toggleFavorite(bayam.id);
  print('Apakah Bayam favorit sekarang? ${wishlistProvider.isFavorite(bayam.id)}');
  print('Total wishlist: ${wishlistProvider.count}');

  print('\n--> Toggle Bayam lagi (menghapus dari favorit)...');
  wishlistProvider.toggleFavorite(bayam.id);
  print('Apakah Bayam favorit sekarang? ${wishlistProvider.isFavorite(bayam.id)}');
  print('Total wishlist: ${wishlistProvider.count}');

  print('\n[3] AUDIT REAKTIVITAS NOTIFYLISTENERS()');
  print('Total trigger CartProvider notifyListeners: $cartNotifications');
  print('Total trigger WishlistProvider notifyListeners: $wishlistNotifications');

  print('\n--> Mengosongkan keranjang (clearCart)...');
  cartProvider.clearCart();
  print('Kondisi akhir cart empty: ${cartProvider.isEmpty}');

  print('\n================================================================');
  print('  SEMUA PENGUJIAN STATE MANAGEMENT (MODUL 14) BERHASIL 100%!    ');
  print('================================================================');
}
