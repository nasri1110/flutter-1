/// Model entitas resmi untuk komoditas sayur dan buah pada aplikasi SayurHub
class Product {
  final String id;
  final String name;
  final String category;
  final double pricePerKg;
  final int stock;
  final double rating;
  final bool isOrganic;
  final String? imageUrl;
  final String? description;

  const Product({
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

  bool get isAvailable => stock > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      pricePerKg: (json['pricePerKg'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      isOrganic: json['isOrganic'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'pricePerKg': pricePerKg,
      'stock': stock,
      'rating': rating,
      'isOrganic': isOrganic,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? pricePerKg,
    int? stock,
    double? rating,
    bool? isOrganic,
    String? imageUrl,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      isOrganic: isOrganic ?? this.isOrganic,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'Product(id: $id, name: $name, price: Rp $pricePerKg, stock: $stock)';
}
