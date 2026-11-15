/// Enum yang merepresentasikan siklus status pesanan komoditas di SayurHub
enum OrderStatus {
  pending(label: 'Menunggu Konfirmasi', code: 'PENDING'),
  confirmed(label: 'Dikonfirmasi Petani', code: 'CONFIRMED'),
  processing(label: 'Sedang Dipetik & Dikemas', code: 'PROCESSING'),
  delivering(label: 'Dalam Pengiriman Kurir', code: 'DELIVERING'),
  completed(label: 'Pesanan Selesai', code: 'COMPLETED'),
  cancelled(label: 'Dibatalkan', code: 'CANCELLED');

  final String label;
  final String code;

  const OrderStatus({
    required this.label,
    required this.code,
  });

  /// Factory untuk memetakan string dari JSON backend menjadi Enum aman
  factory OrderStatus.fromCode(String code) {
    return OrderStatus.values.firstWhere(
      (element) => element.code == code.toUpperCase(),
      orElse: () => OrderStatus.pending,
    );
  }

  bool get isFinished => this == completed || this == cancelled;
}
