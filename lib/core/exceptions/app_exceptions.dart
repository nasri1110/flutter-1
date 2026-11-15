/// Kelas dasar seluruh exception bisnis aplikasi SayurHub
abstract class AppException implements Exception {
  final String message;
  final String? detailCode;

  const AppException(this.message, [this.detailCode]);

  @override
  String toString() => 'AppException: $message ${detailCode != null ? "[$detailCode]" : ""}';
}

/// Dilempar saat pembeli memesan kuantitas yang melebihi sisa stok di gudang
class InsufficientStockException extends AppException {
  final String productName;
  final int currentStock;
  final int requestedQuantity;

  InsufficientStockException({
    required this.productName,
    required this.currentStock,
    required this.requestedQuantity,
  }) : super(
          'Stok komoditas $productName tidak mencukupi. Tersedia: $currentStock, Diminta: $requestedQuantity.',
          'ERR_OUT_OF_STOCK',
        );
}

/// Dilempar jika data profil pengguna tidak valid
class InvalidUserDataException extends AppException {
  InvalidUserDataException(String message) : super(message, 'ERR_INVALID_USER');
}
