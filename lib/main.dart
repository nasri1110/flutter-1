import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sayur_hub/core/network/api_client.dart';
import 'package:sayur_hub/core/providers/auth_provider.dart';
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
/// Mengelola sinkronisasi data lokal (SQLite), data daring (REST API), dan Route Guards Auth
class SayurHubRootApp extends StatefulWidget {
  const SayurHubRootApp({super.key});

  @override
  State<SayurHubRootApp> createState() => _SayurHubRootAppState();
}

class _SayurHubRootAppState extends State<SayurHubRootApp> {
  late final AuthProvider _authProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider()..checkAuthStatus();
    _router = AppRouter.createRouter(_authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
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
        routerConfig: _router,
      ),
    );
  }
}
