/// Kelas utilitas mandiri untuk seluruh kalkulasi harga dan transaksi di aplikasi SayurHub.
/// Menerapkan prinsip Sound Null Safety secara ketat untuk mencegah bug kalkulasi.
class PriceCalculator {
  // Konstruktor privat mencegah instansiasi kelas utilitas murni
  PriceCalculator._();

  /// Menghitung subtotal kotor berdasarkan harga per satuan dan kuantitas belanja
  /// Mendukung kuantitas pecahan desimal (contoh: 1.5 kg sayur)
  static double calculateSubtotal({
    required double pricePerUnit,
    required double quantity,
  }) {
    if (pricePerUnit < 0 || quantity < 0) {
      return 0.0;
    }
    return pricePerUnit * quantity;
  }

  /// Menghitung nominal potongan diskon secara aman dari persentase diskon yang bersifat opsional (nullable).
  /// [discountPercentage] bernilai antara 0.0 (0%) hingga 1.0 (100%).
  /// Jika bernilai null, maka diskon dianggap 0.0 (tanpa potongan).
  static double calculateDiscountAmount({
    required double subtotal,
    double? discountPercentage,
  }) {
    // Penggunaan operator ?? menjamin nilai diskon tidak null
    final double safeDiscountRate = discountPercentage ?? 0.0;

    // Validasi batas logis persentase diskon
    if (safeDiscountRate <= 0.0) {
      return 0.0;
    }
    if (safeDiscountRate >= 1.0) {
      return subtotal;
    }

    return subtotal * safeDiscountRate;
  }

  /// Menghitung total akhir pembayaran setelah dipotong diskon dan ditambah ongkir opsional
  static double calculateFinalTotal({
    required double subtotal,
    double? discountPercentage,
    double? shippingFee,
  }) {
    final double discount = calculateDiscountAmount(
      subtotal: subtotal,
      discountPercentage: discountPercentage,
    );
    final double safeShipping = shippingFee ?? 0.0;

    final double totalAfterDiscount = subtotal - discount;
    return totalAfterDiscount + safeShipping;
  }

  /// Memformat angka numerik ke representasi string mata uang Rupiah standar
  /// Contoh: 25000 -> "Rp 25.000"
  static String formatRupiah(num amount) {
    final int roundedAmount = amount.round();
    final String rawString = roundedAmount.toString();

    final StringBuffer buffer = StringBuffer();
    int count = 0;

    for (int i = rawString.length - 1; i >= 0; i--) {
      buffer.write(rawString[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    final String reversedFormatted = buffer.toString().split('').reversed.join('');
    return 'Rp $reversedFormatted';
  }
}
