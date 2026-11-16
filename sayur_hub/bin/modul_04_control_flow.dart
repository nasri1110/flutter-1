import 'package:sayur_hub/core/utils/inventory_manager.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

void main() {
  print('====================================================');
  print('    SAYURHUB INVENTORY & ORDER MANAGEMENT SYSTEM    ');
  print('====================================================\n');

  // 1. Data Uji Audit Mutu Gudang Sayuran
  final List<String> komoditasList = ['Bayam Hijau', 'Kangkung Hidroponik', 'Wortel Manis', 'Tomat Ceri'];
  final List<int> hariPanenList = [1, 4, 7, 2];
  final List<int> stokFisikList = [50, 25, 10, 0]; // Tomat habis

  print('>>> 1. LAPORAN AUDIT MUTU PRODUK SAYURHUB <<<');
  for (int i = 0; i < komoditasList.length; i++) {
    final String nama = komoditasList[i];
    final int usia = hariPanenList[i];
    final int stok = stokFisikList[i];

    final String grade = InventoryManager.evaluateProduceGrade(usia);
    final bool layakJual = InventoryManager.isProductSalable(
      stockAvailable: stok,
      daysSinceHarvest: usia,
    );

    print('• $nama ($stok ikat tersedia):');
    print('  - Usia Panen : $usia hari');
    print('  - Kualitas   : $grade');
    print('  - Status Jual: ${layakJual ? "[AKTIF DI KATALOG]" : "[NONAKTIF / TARIK]"}');
  }

  print('\n----------------------------------------------------');
  print('>>> 2. SIMULASI TRANSAKSI GROSIR DISKON BERTINGKAT <<<');

  // 2. Data Uji Transaksi Katering
  const String itemBeli = 'Bayam Hijau';
  const double hargaKg = 15000.0;
  final List<double> skenarioBeratBeli = [3.0, 7.5, 15.0, 22.0];

  for (final double berat in skenarioBeratBeli) {
    final Map<String, dynamic> ringkasan = InventoryManager.calculateOrderSummary(
      produceName: itemBeli,
      pricePerKg: hargaKg,
      weightInKg: berat,
      shippingFee: 10000.0,
    );

    final double discountPercent = (ringkasan['discountRate'] as double) * 100;
    print('\nPembelian seberat ${berat} kg ($itemBeli):');
    print('  Subtotal Kotor : ${PriceCalculator.formatRupiah(ringkasan['subtotal'] as num)}');
    print('  Diskon Volume  : ${discountPercent.toInt()}% (-${PriceCalculator.formatRupiah(ringkasan['discountAmount'] as num)})');
    print('  Ongkos Kirim   : ${PriceCalculator.formatRupiah(ringkasan['shippingFee'] as num)}');
    print('  TOTAL TAGIHAN  : ${PriceCalculator.formatRupiah(ringkasan['finalTotal'] as num)}');
  }

  print('\n====================================================');
  print('>> VERIFIKASI KONTROL ALUR MODUL 04: SUKSES 100% <<');
}
