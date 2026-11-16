/// Entitas murni (Domain Entity) yang merepresentasikan komoditas sayur dan buah.
/// Berada di Domain Layer: Bebas dari dependensi Flutter framework, HTTP client, maupun SQLite.
class ProductEntity {
  final String id;
  final String name;
  final String category;
  final double pricePerKg;
  final int stock;
  final double rating;
  final bool isOrganic;
  final String? imageUrl;
  final String? description;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerKg,
    this.stock = 0,
    this.rating = 5.0,
    this.isOrganic = false,
    this.imageUrl,
    this.description,
  });

  /// Aturan bisnis domain: Mengecek ketersediaan stok produk
  bool get isAvailable => stock > 0;

  /// Memeriksa apakah produk merupakan komoditas bernilai ekonomis tinggi
  bool get isPremiumGrade => isOrganic && rating >= 4.7;
}
