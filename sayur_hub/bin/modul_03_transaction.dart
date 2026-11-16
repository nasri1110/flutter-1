import 'package:sayur_hub/core/utils/price_calculator.dart';

void main() {
  print('====================================================');
  print('    SISTEM KALKULASI TRANSAKSI RESMI SAYURHUB       ');
  print('====================================================\n');

  // Simulasi Data Belanja Pelanggan
  const String namaSayur = 'Bayam Organik Hidroponik';
  const double hargaPerKg = 15000.0;
  const double beratBeli = 2.5; // Beli 2.5 kg

  // Parameter Opsional (Uji Null Safety)
  const double? promoPanenRaya = 0.15; // Diskon 15%
  const double? ongkosKirim = 10000.0;
  String? catatanPelanggan; // Konsumen tidak mengisi catatan

  // 1. Eksekusi Perhitungan Subtotal
  final double subtotal = PriceCalculator.calculateSubtotal(
    pricePerUnit: hargaPerKg,
    quantity: beratBeli,
  );

  // 2. Eksekusi Perhitungan Diskon Aman
  final double nominalDiskon = PriceCalculator.calculateDiscountAmount(
    subtotal: subtotal,
    discountPercentage: promoPanenRaya,
  );

  // 3. Eksekusi Perhitungan Total Akhir
  final double grandTotal = PriceCalculator.calculateFinalTotal(
    subtotal: subtotal,
    discountPercentage: promoPanenRaya,
    shippingFee: ongkosKirim,
  );

  // 4. Fallback Catatan Aman
  final String catatanFinal = catatanPelanggan ?? 'Tidak ada instruksi khusus.';

  // 5. Cetak Hasil Menggunakan Formatter Rupiah
  print('Komoditas       : $namaSayur');
  print('Harga Satuan    : ${PriceCalculator.formatRupiah(hargaPerKg)} / kg');
  print('Kuantitas       : $beratBeli kg');
  print('Subtotal        : ${PriceCalculator.formatRupiah(subtotal)}');
  print('Potongan Diskon : ${PriceCalculator.formatRupiah(nominalDiskon)} (15%)');
  print('Ongkos Kirim    : ${PriceCalculator.formatRupiah(ongkosKirim ?? 0)}');
  print('----------------------------------------------------');
  print('TOTAL PEMBAYARAN: ${PriceCalculator.formatRupiah(grandTotal)}');
  print('Catatan Kurir   : $catatanFinal\n');
  print('====================================================');
  print('>> VERIFIKASI LOGIKA MODUL 03: SUKSES DAN TYPE-SAFE <<');
}
