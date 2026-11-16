import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/providers/wishlist_provider.dart';
import 'package:sayur_hub/shared/widgets/product_card.dart';

void main() {
  group('ProductCard Widget Tests (Komponen Kartu Produk SayurHub)', () {
    const Product testOrganicProduct = Product(
      id: 'TEST-01',
      name: 'Bayam Merah Organik',
      category: 'Sayuran Daun',
      pricePerKg: 16000.0,
      stock: 15,
      rating: 4.9,
      isOrganic: true,
    );

    testWidgets('Merender informasi produk dan badge Organik dengan benar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
          child: MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testOrganicProduct,
                onAddToCart: () {},
              ),
            ),
          ),
        ),
      );

      // Verifikasi nama dan kategori tampil
      expect(find.text('Bayam Merah Organik'), findsOneWidget);
      expect(find.text('SAYURAN DAUN'), findsOneWidget);

      // Verifikasi format harga Rupiah
      expect(find.text('Rp 16.000 / kg'), findsOneWidget);

      // Verifikasi badge ORGANIK tampil karena isOrganic = true
      expect(find.text('ORGANIK'), findsOneWidget);

      // Verifikasi sisa stok
      expect(find.text('Sisa: 15 kg'), findsOneWidget);
    });

    testWidgets('Mengetuk tombol keranjang memicu callback onAddToCart', (WidgetTester tester) async {
      bool onAddToCartCalled = false;

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
          child: MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testOrganicProduct,
                onAddToCart: () {
                  onAddToCartCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      // Aksi: Ketuk tombol beli belanjaan
      await tester.tap(find.byIcon(Icons.add_shopping_cart_rounded));
      await tester.pump();

      // Verifikasi callback terpicu
      expect(onAddToCartCalled, isTrue);
    });

    testWidgets('Mengetuk ikon hati memicu perubahan status wishlist reaktif', (WidgetTester tester) async {
      final WishlistProvider wishlist = WishlistProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: wishlist,
          child: MaterialApp(
            home: Scaffold(
              body: ProductCard(
                product: testOrganicProduct,
                onAddToCart: () {},
              ),
            ),
          ),
        ),
      );

      // Awalnya produk belum difavoritkan
      expect(wishlist.isFavorite(testOrganicProduct.id), isFalse);
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

      // Aksi: Ketuk tombol favorit
      await tester.tap(find.byIcon(Icons.favorite_border_rounded));
      await tester.pump();

      // Status wishlist sekarang menjadi favorit (ikon hati penuh merah)
      expect(wishlist.isFavorite(testOrganicProduct.id), isTrue);
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    });
  });
}
