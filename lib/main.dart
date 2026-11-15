import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayur_hub/core/network/api_client.dart';
import 'package:sayur_hub/core/providers/cart_provider.dart';
import 'package:sayur_hub/core/providers/product_catalog_provider.dart';
import 'package:sayur_hub/core/providers/wishlist_provider.dart';
import 'package:sayur_hub/core/routes/app_router.dart';
import 'package:sayur_hub/core/theme/app_theme.dart';

void main() {
  // Memastikan binding Flutter siap sebelum inisialisasi basis data dan preferensi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Klien Jaringan HTTP Dio
  ApiClient.instance.initialize();

  runApp(const SayurHubRootApp());
}

/// Root Widget aplikasi SayurHub yang diinjeksi dengan MultiProvider
/// Mengelola sinkronisasi data lokal (SQLite) dan data daring (REST API)
class SayurHubRootApp extends StatelessWidget {
  const SayurHubRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider()..initializeFromDatabase(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider()..initializeFromDatabase(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductCatalogProvider()..fetchCatalog(),
        ),
      ],
      child: MaterialApp.router(
        title: 'SayurHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
