import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/providers/auth_provider.dart';
import 'package:sayur_hub/features/auth/login_screen.dart';
import 'package:sayur_hub/features/cart/cart_screen.dart';
import 'package:sayur_hub/features/catalog/product_detail_screen.dart';
import 'package:sayur_hub/features/checkout/checkout_screen.dart';
import 'package:sayur_hub/features/main_navigation_shell.dart';
import 'package:sayur_hub/shared/widgets/not_found_screen.dart';

/// Konfigurasi routing deklaratif resmi aplikasi SayurHub menggunakan GoRouter
/// Dilengkapi dengan Route Guards proteksi autentikasi JWT
class AppRouter {
  AppRouter._();

  static final AuthProvider _defaultAuth = AuthProvider()..checkAuthStatus();

  /// Default router instance untuk kompatibilitas
  static final GoRouter router = createRouter(_defaultAuth);

  /// Membuat router dengan injeksi AuthProvider dan Route Guard terintegrasi
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: authProvider,
      errorBuilder: (context, state) =>
          NotFoundScreen(uri: state.uri.toString()),
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authProvider.isAuthenticated;
        final bool isLoggingIn = state.matchedLocation == '/login';

        // Route Guard: Lindungi rute checkout untuk mewajibkan login
        final bool isCheckoutRoute = state.matchedLocation == '/checkout';

        if (isCheckoutRoute && !loggedIn) {
          final fromUri = state.matchedLocation;
          return '/login?redirect=${Uri.encodeComponent(fromUri)}';
        }

        // Jika sudah login dan mencoba ke halaman login, redirect ke tujuan atau home
        if (isLoggingIn && loggedIn) {
          final redirectUri = state.uri.queryParameters['redirect'];
          return (redirectUri != null && redirectUri.isNotEmpty)
              ? redirectUri
              : '/';
        }

        return null; // Bebas lewat
      },
      routes: [
        // Rute Masuk / Autentikasi
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            final redirectUri = state.uri.queryParameters['redirect'];
            return LoginScreen(redirectUri: redirectUri);
          },
        ),

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
            // Rute Formulir Checkout Pengiriman: /checkout (Terproteksi Route Guard)
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
}
