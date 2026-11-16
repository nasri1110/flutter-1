import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/features/catalog/domain/entities/product_entity.dart';

/// Model Data (Data Layer) yang memperluas ProductEntity (Domain Layer).
/// Menangani serialisasi dan deserialisasi data dari JSON REST API dan baris SQLite.
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.pricePerKg,
    super.stock = 0,
    super.rating = 5.0,
    super.isOrganic = false,
    super.imageUrl,
    super.description,
  });

  /// Konversi dari JSON balasan REST API ke ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      pricePerKg: (json['pricePerKg'] ?? json['price_per_kg'] as num).toDouble(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      isOrganic: json['isOrganic'] is bool
          ? json['isOrganic'] as bool
          : (json['is_organic'] == 1),
      imageUrl: (json['imageUrl'] ?? json['image_url']) as String?,
      description: json['description'] as String?,
    );
  }

  /// Konversi dari ProductModel ke Map JSON untuk dikirim ke API atau disimpan ke SQLite
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price_per_kg': pricePerKg,
      'stock': stock,
      'rating': rating,
      'is_organic': isOrganic ? 1 : 0,
      'image_url': imageUrl,
      'description': description,
    };
  }

  /// Konversi antar entitas model inti untuk menjaga interoperabilitas penuh
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      pricePerKg: entity.pricePerKg,
      stock: entity.stock,
      rating: entity.rating,
      isOrganic: entity.isOrganic,
      imageUrl: entity.imageUrl,
      description: entity.description,
    );
  }

  /// Konversi ke model Product warisan
  Product toProduct() {
    return Product(
      id: id,
      name: name,
      category: category,
      pricePerKg: pricePerKg,
      stock: stock,
      rating: rating,
      isOrganic: isOrganic,
      imageUrl: imageUrl,
      description: description,
    );
  }
}
