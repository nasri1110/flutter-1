import 'package:sayur_hub/core/utils/price_calculator.dart';

/// Kelas utilitas pengelola evaluasi inventaris, mutu komoditas,
/// dan kebijakan diskon bertingkat pada aplikasi SayurHub.
class InventoryManager {
  // Konstruktor privat mencegah instansiasi kelas utilitas
  InventoryManager._();

  /// Menghitung persentase diskon bertingkat (Volume Tier Discount)
  /// berdasarkan total berat komoditas yang dibeli konsumen
  static double getVolumeTierDiscount(double weightInKg) {
    if (weightInKg >= 20.0) {
      return 0.25; // Diskon 25% untuk pesanan grosir / restoran
    } else if (weightInKg >= 10.0) {
      return 0.15; // Diskon 15% untuk katering
    } else if (weightInKg >= 5.0) {
      return 0.10; // Diskon 10% untuk pesanan keluarga besar
    } else {
      return 0.0;  // Harga eceran normal
    }
  }

  /// Menentukan status grade mutu komoditas sayur berdasarkan umur simpan pascapanen
  /// Menggunakan fitur Switch Expression modern Dart 3
  static String evaluateProduceGrade(int daysSinceHarvest) {
    return switch (daysSinceHarvest) {
      <= 1 => 'Grade A (Super Segar)',
      <= 3 => 'Grade B (Segar Standar)',
      <= 5 => 'Grade C (Promo Cuci Gudang)',
      _    => 'Kadaluarsa (Tidak Layak Konsumsi)',
    };
  }

  /// Memeriksa apakah suatu komoditas masih aman dan diizinkan untuk dipajang di katalog aplikasi
  static bool isProductSalable({
    required int stockAvailable,
    required int daysSinceHarvest,
  }) {
    // Guard clause: Stok kosong tidak boleh dijual
    if (stockAvailable <= 0) {
      return false;
    }

    // Produk dengan usia lebih dari 5 hari ditarik dari penjualan
    if (daysSinceHarvest > 5) {
      return false;
    }

    return true;
  }

  /// Menghitung ringkasan tagihan lengkap dengan otomatisasi diskon bertingkat
  static Map<String, dynamic> calculateOrderSummary({
    required String produceName,
    required double pricePerKg,
    required double weightInKg,
    double? shippingFee,
  }) {
    final double discountRate = getVolumeTierDiscount(weightInKg);
    final double subtotal = PriceCalculator.calculateSubtotal(
      pricePerUnit: pricePerKg,
      quantity: weightInKg,
    );

    final double discountAmount = PriceCalculator.calculateDiscountAmount(
      subtotal: subtotal,
      discountPercentage: discountRate,
    );

    final double finalTotal = PriceCalculator.calculateFinalTotal(
      subtotal: subtotal,
      discountPercentage: discountRate,
      shippingFee: shippingFee,
    );

    return {
      'produceName': produceName,
      'weightInKg': weightInKg,
      'pricePerKg': pricePerKg,
      'subtotal': subtotal,
      'discountRate': discountRate,
      'discountAmount': discountAmount,
      'shippingFee': shippingFee ?? 0.0,
      'finalTotal': finalTotal,
    };
  }
}
