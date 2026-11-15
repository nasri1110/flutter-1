import 'package:go_router/go_router.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/features/cart/cart_screen.dart';
import 'package:sayur_hub/features/catalog/product_detail_screen.dart';
import 'package:sayur_hub/features/checkout/checkout_screen.dart';
import 'package:sayur_hub/features/main_navigation_shell.dart';
import 'package:sayur_hub/shared/widgets/not_found_screen.dart';

/// Konfigurasi routing deklaratif resmi aplikasi SayurHub menggunakan GoRouter
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => NotFoundScreen(uri: state.uri.toString()),
    routes: [
      // Rute Utama: Shell Navigation 4 Tab
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainNavigationShell(),
        routes: [
          // Rute Detail Produk Dinamis: /product/:id
          GoRoute(
            path: 'product/:id',
            name: 'product-detail',
            builder: (context, state) {
              final String id = state.pathParameters['id'] ?? '';
              final Product? product = state.extra as Product?;
              return ProductDetailScreen(
                productId: id,
                initialProduct: product,
              );
            },
          ),
          // Rute Keranjang Belanja: /cart
          GoRoute(
            path: 'cart',
            name: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
          // Rute Formulir Checkout Pengiriman: /checkout
          GoRoute(
            path: 'checkout',
            name: 'checkout',
            builder: (context, state) => const CheckoutScreen(),
          ),
        ],
      ),
    ],
  );
}
