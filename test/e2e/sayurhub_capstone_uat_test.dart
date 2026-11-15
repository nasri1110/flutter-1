import 'package:flutter_test/flutter_test.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/models/cart_item.dart';
import 'package:sayur_hub/core/models/user.dart';
import 'package:sayur_hub/core/models/order_status.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';
import 'package:sayur_hub/core/utils/inventory_manager.dart';
import 'package:sayur_hub/core/services/mock_product_service.dart';

/// ============================================================================
/// MODUL 22: CAPSTONE USER ACCEPTANCE TESTING (UAT) SUITE
/// ============================================================================
/// Menguji skenario hulu-ke-hilir (End-to-End User Journey) dari 20 Fitur SayurHub:
/// 1. Autentikasi Pengguna & Profil
/// 2. Katalog Produk, Algoritma Diskon & Audit Mutu
/// 3. Siklus Keranjang Belanja & Kalkulasi Subtotal
/// 4. Asynchronous Order Processing & Stream Tracking
/// ============================================================================

void main() {
  group('Capstone UAT Skenario 1: Autentikasi & Model Pengguna', () {
    test('UAT 1.1: Pembuatan User dan validasi sesi login aktif', () {
      final user = User(
        id: 'usr_001',
        name: 'Budi Santoso',
        email: 'budi.santoso@smkrpl.sch.id',
        phoneNumber: '081234567890',
        address: 'Jl. Merdeka No. 45, Jakarta',
        avatarUrl: 'https://cdn.sayurhub.id/avatars/budi.jpg',
        token: 'jwt_mock_token_secret_xyz123',
      );

      expect(user.id, equals('usr_001'));
      expect(user.name, equals('Budi Santoso'));
      expect(user.email, contains('@smkrpl.sch.id'));
      expect(user.token, isNotNull);
      expect(user.token!.isNotEmpty, isTrue);
    });

    test('UAT 1.2: Serialisasi User to Map dan from Map', () {
      final user = User(
        id: 'usr_002',
        name: 'Siti Rahma',
        email: 'siti@smkrpl.sch.id',
        phoneNumber: '089876543210',
      );

      final map = user.toMap();
      expect(map['name'], equals('Siti Rahma'));
      expect(map['email'], equals('siti@smkrpl.sch.id'));

      final reconstructedUser = User.fromMap(map);
      expect(reconstructedUser.id, equals('usr_002'));
      expect(reconstructedUser.name, equals('Siti Rahma'));
    });
  });

  group('Capstone UAT Skenario 2: Logika Bisnis Katalog & Mutu Sayur', () {
    late Product sampleSpinach;
    late Product sampleBroccoli;

    setUp(() {
      sampleSpinach = Product(
        id: 'p1',
        name: 'Bayam Organik Segar',
        category: 'Sayuran Hijau',
        price: 5000,
        stock: 50,
        unit: 'ikat',
        rating: 4.8,
        imageUrl: 'assets/images/bayam.png',
        description: 'Bayam hijau segar langsung dari petani lokal.',
      );

      sampleBroccoli = Product(
        id: 'p2',
        name: 'Brokoli Segar',
        category: 'Sayuran Hijau',
        price: 15000,
        stock: 20,
        unit: 'kg',
        rating: 4.9,
        imageUrl: 'assets/images/brokoli.png',
        description: 'Brokoli segar kaya antioksidan.',
      );
    });

    test('UAT 2.1: Perhitungan Subtotal dan Diskon Tier Kuantitas', () {
      // Pembelian 5 ikat bayam @ Rp 5.000 = Rp 25.000
      final subtotal = PriceCalculator.calculateSubtotal(
        unitPrice: sampleSpinach.price,
        quantity: 5,
      );
      expect(subtotal, equals(25000));

      // Diskon 5 ikat (tier diskon kuantitas)
      final discountPercent = InventoryManager.getTierDiscountPercent(5);
      expect(discountPercent, greaterThanOrEqualTo(5.0));

      final finalPrice = PriceCalculator.applyDiscount(
        price: subtotal,
        discountPercent: discountPercent,
      );
      expect(finalPrice, lessThan(subtotal));
    });

    test('UAT 2.2: Audit Kesegaran & Kelayakan Mutu Produk Sayur', () {
      final daysHarvested = 2;
      final isFresh = InventoryManager.isProduceFresh(
        category: sampleSpinach.category,
        daysSinceHarvest: daysHarvested,
      );
      expect(isFresh, isTrue);

      final spoiledDays = 8;
      final isSpoiled = InventoryManager.isProduceFresh(
        category: sampleSpinach.category,
        daysSinceHarvest: spoiledDays,
      );
      expect(isSpoiled, isFalse);
    });
  });

  group('Capstone UAT Skenario 3: Transaksi Keranjang & Order Stream', () {
    test('UAT 3.1: Siklus penambahan dan penghapusan item keranjang', () {
      final spinach = Product(
        id: 'p1',
        name: 'Bayam Organik',
        category: 'Sayuran Hijau',
        price: 5000,
        stock: 30,
        unit: 'ikat',
        imageUrl: 'assets/images/bayam.png',
      );

      final item = CartItem(
        product: spinach,
        quantity: 3,
      );

      expect(item.subtotal, equals(15000));

      item.quantity += 2;
      expect(item.quantity, equals(5));
      expect(item.subtotal, equals(25000));
    });

    test('UAT 3.2: Asynchronous Live Stream Pelacakan Status Pesanan', () async {
      final service = MockProductService();
      final stream = service.trackOrderStatus('ORD-CAPSTONE-2026');

      final statuses = <OrderStatus>[];
      await for (final status in stream) {
        statuses.add(status);
      }

      expect(statuses, contains(OrderStatus.pending));
      expect(statuses, contains(OrderStatus.confirmed));
      expect(statuses, contains(OrderStatus.shipped));
      expect(statuses, contains(OrderStatus.delivered));
      expect(statuses.last, equals(OrderStatus.delivered));
    });
  });
}
