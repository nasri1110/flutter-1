import 'package:flutter_test/flutter_test.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

void main() {
  group('PriceCalculator Unit Tests (Logika Transaksi Finansial SayurHub)', () {
    test('calculateSubtotal menghitung harga total dengan tepat', () {
      // 1. Arrange (Persiapan)
      const double pricePerKg = 14000.0;
      const double quantity = 2.5; // 2.5 kg

      // 2. Act (Eksekusi)
      final double subtotal = PriceCalculator.calculateSubtotal(
        pricePerUnit: pricePerKg,
        quantity: quantity,
      );

      // 3. Assert (Verifikasi)
      expect(subtotal, equals(35000.0));
    });

    test('calculateDiscountAmount menghitung diskon persentase secara akurat', () {
      const double subtotal = 60000.0;
      const double discountPercentage = 10.0; // Promo Panen 10%

      final double discount = PriceCalculator.calculateDiscountAmount(
        subtotal: subtotal,
        discountPercentage: discountPercentage,
      );

      expect(discount, equals(6000.0));
    });

    test('calculateFinalTotal memotong diskon dari subtotal secara tepat', () {
      const double subtotal = 60000.0;
      const double discount = 6000.0;

      final double finalTotal = PriceCalculator.calculateFinalTotal(
        subtotal: subtotal,
        discountAmount: discount,
      );

      expect(finalTotal, equals(54000.0));
    });

    test('formatRupiah memformat angka ke dalam format mata uang Indonesia standar', () {
      expect(PriceCalculator.formatRupiah(14000.0), equals('Rp 14.000'));
      expect(PriceCalculator.formatRupiah(0.0), equals('Rp 0'));
      expect(PriceCalculator.formatRupiah(1250500.0), equals('Rp 1.250.500'));
    });
  });
}
