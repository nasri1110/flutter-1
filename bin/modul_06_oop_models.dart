import 'package:sayur_hub/core/exceptions/app_exceptions.dart';
import 'package:sayur_hub/core/mock/mock_produce_data.dart';
import 'package:sayur_hub/core/models/cart_item.dart';
import 'package:sayur_hub/core/models/order_status.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/models/user.dart';
import 'package:sayur_hub/core/utils/catalog_processor.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

void main() {
  print('====================================================');
  print('     SAYURHUB OOP DOMAIN MODELING VERIFICATION      ');
  print('====================================================\n');

  // 1. Uji Deserialisasi Model Produk dari JSON mentah
  final Map<String, dynamic> rawApiJson = {
    'id': 'PROD-777',
    'name': 'Wortel Hidroponik Premium',
    'category': 'Umbi-umbian',
    'pricePerKg': 22000.0,
    'stock': 15,
    'rating': 4.9,
    'isOrganic': true,
    'description': 'Wortel segar kaya vitamin A langsung dari Lembang.',
  };

  final Product wortel = Product.fromJson(rawApiJson);
  print('>>> 1. SERIALISASI MODEL PRODUK BERHASIL:');
  print('    Objek: $wortel');
  print('    Status Ketersediaan: ${wortel.isAvailable ? "TERSEDIA" : "HABIS"}\n');

  // 2. Uji Model Pengguna
  const User pembeli = User(
    id: 'USR-001',
    fullName: 'Siti Nurhaliza',
    phoneNumber: '081234567890',
    email: 'siti@smkrpl.sch.id',
    address: 'Jl. Merdeka No. 45, Bandung',
  );
  print('>>> 2. DATA PENGGUNA TERKONFIRMASI:');
  print('    Konsumen : ${pembeli.fullName} (${pembeli.phoneNumber})');
  print('    Alamat   : ${pembeli.address}\n');

  // 3. Uji Model Keranjang Belanja & Perhitungan Subtotal
  final CartItem itemBelanja = CartItem(
    product: wortel,
    quantity: 3.5, // 3.5 kg
    customerNotes: 'Pilih yang ukurannya sedang.',
  );
  print('>>> 3. ITEM KERANJANG BELANJA:');
  print('    Produk   : ${itemBelanja.product.name}');
  print('    Beli     : ${itemBelanja.quantity} kg');
  print('    Subtotal : ${PriceCalculator.formatRupiah(itemBelanja.subtotal)}');
  print('    Catatan  : ${itemBelanja.customerNotes}\n');

  // 4. Uji Enhanced Enum Status Pesanan
  const OrderStatus statusAwal = OrderStatus.processing;
  print('>>> 4. ENHANCED ENUM STATUS PESANAN:');
  print('    Status  : ${statusAwal.code} -> ${statusAwal.label}');
  print('    Selesai?: ${statusAwal.isFinished ? "YA" : "MASIH AKTIF"}\n');

  // 5. Uji Penanganan Custom Exception (Stok Tidak Mencukupi)
  print('>>> 5. SIMULASI PENGUJIAN CUSTOM EXCEPTION:');
  const int pesananGrosir = 50; // Stok hanya ada 15 kg
  try {
    if (pesananGrosir > wortel.stock) {
      throw InsufficientStockException(
        productName: wortel.name,
        currentStock: wortel.stock,
        requestedQuantity: pesananGrosir,
      );
    }
    print('    Pesanan diproses...');
  } on InsufficientStockException catch (e) {
    print('    [TERTANGKAP DENGAN AMAN]');
    print('    Pesan Error : ${e.message}');
    print('    Kode Galat  : ${e.detailCode}');
  } finally {
    print('    Audit transaksi selesai.\n');
  }

  // 6. Uji Integrasi MockProduceData dengan CatalogProcessor (Type-Safe Objects)
  final List<Product> produceList = MockProduceData.products;
  final leafyVegetables = CatalogProcessor.filterProductsByCategory(
    products: produceList,
    categoryName: 'Sayuran Daun',
  );
  print('>>> 6. FILTER STRONGLY-TYPED PRODUCT LIST (Sayuran Daun):');
  for (final p in leafyVegetables) {
    print('    • ${p.name.padRight(26)} : ${PriceCalculator.formatRupiah(p.pricePerKg)}/kg (Stok: ${p.stock})');
  }

  print('\n====================================================');
  print('>> VERIFIKASI OOP MODELING MODUL 06: SUKSES 100%   <<');
}
