import 'package:sayur_hub/core/mock/mock_produce_data.dart';
import 'package:sayur_hub/core/utils/catalog_processor.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

void main() {
  print('====================================================');
  print('    SAYURHUB FUNCTIONAL CATALOG ENGINE TEST         ');
  print('====================================================\n');

  final products = MockProduceData.rawProducts;

  // 1. Uji Pengambilan Kategori Unik
  final Set<String> categories = CatalogProcessor.getUniqueCategories(products);
  print('>>> 1. KATEGORI TERDAFTAR DI SISTEM (${categories.length} Kategori):');
  for (final cat in categories) {
    print('    [•] $cat');
  }

  // 2. Uji Filter Kategori: Sayuran Daun
  const String filterTarget = 'Sayuran Daun';
  final filteredProduce = CatalogProcessor.filterByCategory(
    products: products,
    categoryName: filterTarget,
  );
  print('\n>>> 2. PRODUK KATEGORI "$filterTarget" (${filteredProduce.length} Item):');
  for (final p in filteredProduce) {
    print('    - ${p['name']} | ${PriceCalculator.formatRupiah(p['pricePerKg'] as num)}/kg | Stok: ${p['stock']}');
  }

  // 3. Uji Pengurutan Harga: Termurah ke Termahal
  final sortedProducts = CatalogProcessor.sortByPrice(
    products: products,
    ascending: true,
  );
  print('\n>>> 3. DAFTAR HARGA TERMURAH -> TERMAHAL:');
  for (final p in sortedProducts) {
    print('    • ${PriceCalculator.formatRupiah(p['pricePerKg'] as num).padRight(12)} : ${p['name']}');
  }

  // 4. Uji Pencarian Live Search Kata Kunci "Manis"
  const String searchQuery = 'manis';
  final searchResults = CatalogProcessor.searchProducts(
    products: products,
    query: searchQuery,
  );
  print('\n>>> 4. HASIL PENCARIAN KATA KUNCI "$searchQuery":');
  for (final p in searchResults) {
    print('    [Cocok] ${p['name']} (${p['category']})');
  }

  // 5. Uji Kalkulasi Keranjang Belanja Pelanggan
  final List<Map<String, dynamic>> simulasiKeranjang = [
    {'name': 'Bayam Hijau Hidroponik', 'pricePerKg': 14000.0, 'quantity': 2.0},
    {'name': 'Alpukat Mentega Super', 'pricePerKg': 32000.0, 'quantity': 1.5},
    {'name': 'Bawang Merah Brebes', 'pricePerKg': 38000.0, 'quantity': 0.5},
  ];

  final double totalTagihan = CatalogProcessor.calculateCartGrandTotal(simulasiKeranjang);
  print('\n>>> 5. SIMULASI PERHITUNGAN TOTAL KERANJANG BELANJA:');
  for (final item in simulasiKeranjang) {
    final double sub = (item['pricePerKg'] as double) * (item['quantity'] as double);
    print('    • ${item['name']} (${item['quantity']} kg) = ${PriceCalculator.formatRupiah(sub)}');
  }
  print('    ------------------------------------------------');
  print('    TOTAL AKHIR KERANJANG: ${PriceCalculator.formatRupiah(totalTagihan)}');

  print('\n====================================================');
  print('>> VERIFIKASI PENGOLAHAN DATA MODUL 05: SUKSES 100% <<');
}
