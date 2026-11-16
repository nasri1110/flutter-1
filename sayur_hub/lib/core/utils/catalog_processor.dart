import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

/// Kelas utilitas fungsional untuk mengolah, menyaring, mencari,
/// dan mengurutkan data katalog produk di aplikasi SayurHub.
class CatalogProcessor {
  CatalogProcessor._();

  // =========================================================================
  // METODE STRONGLY-TYPED BERBASIS OBJEK PRODUCT (MODUL 06+)
  // =========================================================================

  /// Mengambil daftar kategori unik dari sekumpulan objek Product
  static Set<String> getProduceCategories(List<Product> products) {
    return products.map((item) => item.category).toSet();
  }

  /// Menyaring objek Product berdasarkan kategori
  static List<Product> filterProductsByCategory({
    required List<Product> products,
    String? categoryName,
  }) {
    if (categoryName == null || categoryName.trim().isEmpty || categoryName == 'Semua') {
      return List.unmodifiable(products);
    }

    return products
        .where((item) => item.category.toLowerCase() == categoryName.toLowerCase())
        .toList();
  }

  /// Melakukan pencarian objek Product berdasarkan nama atau kategori
  static List<Product> searchProduceObjects({
    required List<Product> products,
    required String query,
  }) {
    final String cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return List.unmodifiable(products);
    }

    return products.where((item) {
      final String name = item.name.toLowerCase();
      final String category = item.category.toLowerCase();
      return name.contains(cleanQuery) || category.contains(cleanQuery);
    }).toList();
  }

  /// Mengurutkan objek Product berdasarkan harga
  static List<Product> sortProduceByPrice({
    required List<Product> products,
    bool ascending = true,
  }) {
    final List<Product> sortedList = List.from(products);
    sortedList.sort((a, b) {
      return ascending
          ? a.pricePerKg.compareTo(b.pricePerKg)
          : b.pricePerKg.compareTo(a.pricePerKg);
    });
    return sortedList;
  }

  // =========================================================================
  // METODE LEGACY MAP UNTUK KOMPATIBILITAS MOCK DATA LAMA (MODUL 05)
  // =========================================================================

  /// Mengambil daftar kategori unik dari sekumpulan data produk mentah
  static Set<String> getUniqueCategories(List<Map<String, dynamic>> products) {
    return products.map((item) => item['category'] as String).toSet();
  }

  /// Menyaring produk berdasarkan nama kategori tertentu
  static List<Map<String, dynamic>> filterByCategory({
    required List<Map<String, dynamic>> products,
    String? categoryName,
  }) {
    if (categoryName == null || categoryName.trim().isEmpty || categoryName == 'Semua') {
      return List.unmodifiable(products);
    }

    return products
        .where((item) => (item['category'] as String).toLowerCase() == categoryName.toLowerCase())
        .toList();
  }

  /// Melakukan pencarian produk berdasarkan kata kunci nama produk
  static List<Map<String, dynamic>> searchProducts({
    required List<Map<String, dynamic>> products,
    required String query,
  }) {
    final String cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return List.unmodifiable(products);
    }

    return products.where((item) {
      final String name = (item['name'] as String).toLowerCase();
      final String category = (item['category'] as String).toLowerCase();
      return name.contains(cleanQuery) || category.contains(cleanQuery);
    }).toList();
  }

  /// Mengurutkan daftar produk berdasarkan harga termurah atau termahal
  static List<Map<String, dynamic>> sortByPrice({
    required List<Map<String, dynamic>> products,
    bool ascending = true,
  }) {
    final List<Map<String, dynamic>> sortedList = List.from(products);

    sortedList.sort((a, b) {
      final num priceA = a['pricePerKg'] as num;
      final num priceB = b['pricePerKg'] as num;
      return ascending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
    });

    return sortedList;
  }

  /// Menghitung grand total nilai belanja dari sekumpulan item keranjang
  static double calculateCartGrandTotal(List<Map<String, dynamic>> cartItems) {
    return cartItems.fold(0.0, (accumulatedTotal, item) {
      final double price = (item['pricePerKg'] as num).toDouble();
      final double quantity = (item['quantity'] as num).toDouble();
      return accumulatedTotal + PriceCalculator.calculateSubtotal(
        pricePerUnit: price,
        quantity: quantity,
      );
    });
  }
}
