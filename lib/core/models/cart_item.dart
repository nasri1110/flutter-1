import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';

/// Model item keranjang belanja yang menghubungkan entitas Produk dengan kuantitas
class CartItem {
  final Product product;
  final double quantity;
  final String? customerNotes;

  const CartItem({
    required this.product,
    required this.quantity,
    this.customerNotes,
  });

  /// Kalkulasi subtotal belanja menggunakan utilitas PriceCalculator
  double get subtotal => PriceCalculator.calculateSubtotal(
        pricePerUnit: product.pricePerKg,
        quantity: quantity,
      );

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      customerNotes: json['customerNotes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'customerNotes': customerNotes,
      'subtotal': subtotal,
    };
  }

  CartItem copyWith({
    Product? product,
    double? quantity,
    String? customerNotes,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      customerNotes: customerNotes ?? this.customerNotes,
    );
  }
}
