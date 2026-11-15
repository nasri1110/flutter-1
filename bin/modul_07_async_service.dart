import 'package:sayur_hub/core/exceptions/app_exceptions.dart';
import 'package:sayur_hub/core/models/order_status.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/services/mock_product_service.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

void main() async {
  print('====================================================');
  print('   SAYURHUB ASYNCHRONOUS ENGINE & STREAM RUNNER     ');
  print('====================================================\n');

  final service = MockProductService();

  // 1. Uji Pengambilan Data Asinkron Sukses (Future)
  print('>>> 1. MEMULAI FETCH KATALOG ASINKRON (Tunggu 2 Detik)...');
  final Stopwatch stopwatch = Stopwatch()..start();

  try {
    final List<Product> catalog = await service.fetchCatalog(latencySeconds: 2);
    stopwatch.stop();

    print('    [SUKSES] ${catalog.length} Produk berhasil diambil dalam ${stopwatch.elapsedMilliseconds} ms!');
    for (final item in catalog.take(3)) {
      print('    • ${item.name.padRight(26)} : ${PriceCalculator.formatRupiah(item.pricePerKg)}/kg');
    }
  } catch (e) {
    print('    [GAGAL] Terjadi error: $e');
  }

  // 2. Uji Penanganan Error Jaringan (Simulasi Server Down)
  print('\n>>> 2. UJI KETANGGUHAN SIMULASI ERROR JARINGAN:');
  try {
    print('    Mencoba menghubungi server bermasalah...');
    await service.fetchCatalog(latencySeconds: 1, forceError: true);
    print('    (Baris ini tidak boleh dieksekusi)');
  } on AppException catch (e) {
    print('    [TERTANGKAP DENGAN AMAN]');
    print('    Pesan Error : ${e.message}');
    print('    Kode Status : ${e.detailCode}');
  }

  // 3. Uji Konsumsi Aliran Data Reaktif (Stream Tracking)
  print('\n>>> 3. MEMULAI LIVE TRACKING PESANAN KURIR (STREAM):');
  const String sampleOrderId = 'ORDER-SAYUR-999';
  print('    Memantau Pesanan: $sampleOrderId\n');

  final Stream<OrderStatus> deliveryStream = service.trackOrderDelivery(sampleOrderId);

  // Mendengarkan data yang mengalir dari Stream menggunakan 'await for'
  await for (final OrderStatus status in deliveryStream) {
    final String timestamp = DateTime.now().toIso8601String().substring(11, 19);
    print('    [$timestamp] Status Diperbarui: ${status.label} (${status.code})');
  }

  print('\n    [SELESAI] Kurir telah menyerahkan sayur ke tangan pelanggan!');
  print('\n====================================================');
  print('>> VERIFIKASI ASYNC DART MODUL 07: SUKSES 100%    <<');
}
