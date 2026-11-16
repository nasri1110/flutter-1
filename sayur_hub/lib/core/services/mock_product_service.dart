import 'dart:async';
import 'package:sayur_hub/core/exceptions/app_exceptions.dart';
import 'package:sayur_hub/core/mock/mock_produce_data.dart';
import 'package:sayur_hub/core/models/order_status.dart';
import 'package:sayur_hub/core/models/product.dart';

/// Layanan resmi pemrosesan data asinkron SayurHub
/// Menyimulasikan panggilan REST API backend dan aliran data Stream pelacak pesanan
class MockProductService {
  /// Mengambil daftar seluruh produk katalog dengan simulasi latensi jaringan
  Future<List<Product>> fetchCatalog({
    int latencySeconds = 2,
    bool forceError = false,
  }) async {
    // 1. Simulasi jeda pengiriman data jaringan (Non-blocking)
    await Future.delayed(Duration(seconds: latencySeconds));

    // 2. Simulasi penanganan kegagalan koneksi
    if (forceError) {
      throw AppException(
        'Koneksi ke server SayurHub terputus. Silakan periksa jaringan internet Anda.',
        'HTTP_ERR_CONNECTION_FAILED',
      );
    }

    // 3. Mengembalikan data produk dalam bentuk entitas kuat
    return MockProduceData.products;
  }

  /// Mengambil detail satu produk spesifik berdasarkan ID
  Future<Product?> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      return MockProduceData.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null; // Produk tidak ditemukan
    }
  }

  /// Menyimulasikan pembaruan status pengiriman pesanan secara reaktif via Stream
  /// Mengirimkan status baru setiap 1 detik
  Stream<OrderStatus> trackOrderDelivery(String orderId) async* {
    yield OrderStatus.confirmed;
    await Future.delayed(const Duration(seconds: 1));

    yield OrderStatus.processing;
    await Future.delayed(const Duration(seconds: 1));

    yield OrderStatus.delivering;
    await Future.delayed(const Duration(seconds: 1));

    yield OrderStatus.completed;
  }
}
