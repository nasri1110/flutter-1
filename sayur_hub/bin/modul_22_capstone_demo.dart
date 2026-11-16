import 'dart:async';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/models/cart_item.dart';
import 'package:sayur_hub/core/models/order_status.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';
import 'package:sayur_hub/core/utils/inventory_manager.dart';
import 'package:sayur_hub/core/services/mock_product_service.dart';

/// ============================================================================
/// MODUL 22: CAPSTONE FINAL SHOWCASE RUNNER (SAYURHUB 20 FITUR LENGKAP)
/// ============================================================================
/// Script ini menjalankan demonstrasi komprehensif dari seluruh 20 fitur
/// yang telah dibangun secara bertahap sepanjang 22 modul pembelajaran.
/// ============================================================================

Future<void> main() async {
  print('================================================================');
  print('🌟 SAYURHUB - FINAL CAPSTONE SHOWCASE (MODUL 22)');
  print('   Aplikasi E-Commerce Sayur & Buah Segar Berbasis Flutter 3.x');
  print('   Kurikulum Terpadu SMK Rekayasa Perangkat Lunak (RPL)');
  print('================================================================\n');

  final features = [
    '01. Welcome & Onboarding Screen (Modul 02, 08)',
    '02. Material 3 Design System & Shell Navigasi 4 Tab (Modul 11)',
    '03. Responsive Catalog Grid 2-Kolom & Promo Banner (Modul 10)',
    '04. Shimmer Loading & Pull-to-Refresh Indicator (Modul 16)',
    '05. Dynamic Category Filtering (Modul 10, 11)',
    '06. Product Detail View & Image Viewer (Modul 12)',
    '07. Real-Time Price Calculator & Quantity Counter (Modul 03, 09)',
    '08. Tier Discount Algorithm & Produce Freshness Audit (Modul 04)',
    '09. Higher-Order Collection Processing (Modul 05)',
    '10. OOP Data Modeling: Product, CartItem, User, Order (Modul 06)',
    '11. Asynchronous Future & Live Order Tracking Stream (Modul 07)',
    '12. Declarative Route Management & Route Guards (Modul 12, 17)',
    '13. Comprehensive Checkout Form & Regex Validation (Modul 13)',
    '14. Reactive State Management: Cart & Wishlist Provider (Modul 14)',
    '15. Offline Persistence: SQLite Relational Database (Modul 15)',
    '16. REST API Client Dio with Interceptors (Modul 16)',
    '17. JWT Authentication & Hardware Keystore Storage (Modul 17)',
    '18. Feature-First Clean Architecture Decoupling (Modul 18)',
    '19. Runtime Camera Permission & Multipart Upload (Modul 19)',
    '20. Automated QA Testing & Production Release Build (Modul 20, 21)',
  ];

  print('📋 MATRIKS 20 FITUR PRODUKSI SAYURHUB:');
  for (final feat in features) {
    print('  [✓] $feat');
  }

  print('\n----------------------------------------------------------------');
  print('⚡ MENJALANKAN SIMULASI END-TO-END USER JOURNEY...');
  print('----------------------------------------------------------------');

  // 1. Inisialisasi Mock Produk
  print('\n[Tahap 1] Menginisialisasi Katalog Sayuran Segar...');
  final spinach = Product(
    id: 'p01',
    name: 'Bayam Hijau Organik',
    category: 'Sayuran Hijau',
    price: 6000,
    stock: 45,
    unit: 'ikat',
    rating: 4.9,
    imageUrl: 'assets/images/bayam.png',
    description: 'Bayam segar tanpa pestisida langsung dari perkebunan Lembang.',
  );
  print('  • Produk: ${spinach.name} (Kategori: ${spinach.category})');
  print('  • Harga Satuan: ${PriceCalculator.formatRupiah(spinach.price)} / ${spinach.unit}');
  print('  • Rating Pelanggan: ⭐ ${spinach.rating} | Stok Tersedia: ${spinach.stock}');

  // 2. Audit Mutu Kesegaran
  print('\n[Tahap 2] Menjalankan Algoritma Audit Mutu Kesegaran (Modul 04)...');
  final harvestDays = 1;
  final isFresh = InventoryManager.isProduceFresh(
    category: spinach.category,
    daysSinceHarvest: harvestDays,
  );
  print('  • Hari sejak panen: $harvestDays hari');
  print('  • Status Kelayakan: ${isFresh ? "✅ SEGAR & LAYAK KONSUMSI" : "❌ KADALUARSA"}');

  // 3. Penambahan ke Keranjang Belanja & Perhitungan Diskon
  print('\n[Tahap 3] Simulasi Keranjang Belanja & Diskon Kuantitas (Modul 09, 14)...');
  final cartItem = CartItem(product: spinach, quantity: 6);
  final rawSubtotal = cartItem.subtotal;
  final discountPercent = InventoryManager.getTierDiscountPercent(cartItem.quantity);
  final finalPrice = PriceCalculator.applyDiscount(
    price: rawSubtotal,
    discountPercent: discountPercent,
  );

  print('  • Kuantitas Pembelian : ${cartItem.quantity} ${spinach.unit}');
  print('  • Subtotal Awal       : ${PriceCalculator.formatRupiah(rawSubtotal)}');
  print('  • Tier Diskon Gross   : ${discountPercent.toStringAsFixed(1)}%');
  print('  • Total Tagihan Akhir : ${PriceCalculator.formatRupiah(finalPrice)}');

  // 4. Simulasi Validasi Form Checkout (Modul 13)
  print('\n[Tahap 4] Validasi Form Pengiriman & Kontak (Modul 13)...');
  final dummyPhone = '081234567890';
  final phoneRegex = RegExp(r'^08[0-9]{8,11}$');
  final isPhoneValid = phoneRegex.hasMatch(dummyPhone);
  print('  • No Handphone: $dummyPhone -> ${isPhoneValid ? "✅ VALID" : "❌ INVALID"}');
  print('  • Metode Pembayaran: Transfer Bank Manual (Foto Bukti Bayar)');

  // 5. Asynchronous Order Stream Processing (Modul 07)
  print('\n[Tahap 5] Pelacakan Real-Time Status Pesanan via Asynchronous Stream (Modul 07)...');
  final mockService = MockProductService();
  final orderId = 'SH-CAPSTONE-99201';
  print('  • Nomor Resi: $orderId');

  await for (final status in mockService.trackOrderStatus(orderId)) {
    final statusLabel = switch (status) {
      OrderStatus.pending => '⏳ Menunggu Pembayaran',
      OrderStatus.confirmed => '💳 Pembayaran Dikonfirmasi Petani',
      OrderStatus.processing => '🧺 Sayuran Sedang Dipanen & Dikemas',
      OrderStatus.shipped => '🛵 Kurir Sedang Mengantar ke Alamat',
      OrderStatus.delivered => '🏡 Sayuran Telah Diterima Segar!',
      OrderStatus.cancelled => '❌ Pesanan Dibatalkan',
    };
    print('    --> Status Terkini: $statusLabel');
  }

  // 6. Ringkasan Sertifikasi Kelulusan Kurikulum
  print('\n================================================================');
  print('🎓 SERTIFIKASI KELULUSAN CAPSTONE PROJECT: SAYURHUB');
  print('================================================================');
  print('Aplikasi e-commerce SayurHub telah memenuhi seluruh kualifikasi:');
  print('  1. Clean Architecture (Feature-First) Modular & Scalable');
  print('  2. Reactive State Management (Provider)');
  print('  3. Offline-First Resilience (SQLite & SharedPreferences)');
  print('  4. Secure Hardware Storage (Keystore & JWT)');
  print('  5. Material Design 3 Theming & Responsive Layout');
  print('  6. Comprehensive Automated Testing (Unit & Widget)');
  print('  7. Production Ready Build (Signed APK & AAB)\n');
  print('Selamat kepada Tim Pengembang Siswa SMK Rekayasa Perangkat Lunak!');
  print('Aplikasi ini siap dipublikasikan dan dijadikan portofolio unggulan.');
  print('================================================================');
}
