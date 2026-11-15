import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sayur_hub/core/mock/mock_produce_data.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/providers/cart_provider.dart';
import 'package:sayur_hub/core/providers/wishlist_provider.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';
import 'package:sayur_hub/shared/widgets/custom_button.dart';
import 'package:sayur_hub/shared/widgets/quantity_counter_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final Product? initialProduct;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.initialProduct,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _product;
  int _selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.initialProduct != null) {
      _product = widget.initialProduct!;
    } else {
      _product = MockProduceData.products.firstWhere(
        (p) => p.id == widget.productId,
        orElse: () => const Product(
          id: 'UNKNOWN',
          name: 'Produk Tidak Ditemukan',
          category: 'Umum',
          pricePerKg: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.name),
        actions: [
          // Tombol Favorit Reaktif tersambung ke WishlistProvider
          Consumer<WishlistProvider>(
            builder: (context, wishlist, child) {
              final bool isFav = wishlist.isFavorite(_product.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? Colors.red : Colors.white,
                ),
                tooltip: isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                onPressed: () {
                  wishlist.toggleFavorite(_product.id);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav
                            ? '${_product.name} dihapus dari favorit.'
                            : '${_product.name} disimpan ke daftar favorit!',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
          // Badge Keranjang Reaktif di AppBar Detail
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Badge(
                isLabelVisible: cart.totalQuantity > 0,
                label: Text('${cart.totalQuantity}'),
                backgroundColor: AppColors.accentOrange,
                alignment: const AlignmentDirectional(24, 6),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  tooltip: 'Keranjang Belanja',
                  onPressed: () => context.pushNamed('cart'),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Area Banner Foto Sayur Besar
            Container(
              height: 220,
              width: double.infinity,
              color: AppColors.primaryGreen.withOpacity(0.08),
              child: Center(
                child: Icon(
                  _product.category == 'Buah Segar'
                      ? Icons.apple_rounded
                      : Icons.eco_rounded,
                  size: 96,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Kategori & Status Organik
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _product.category.toUpperCase(),
                          style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_product.isOrganic)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '100% ORGANIK',
                            style: TextStyle(
                                color: AppColors.accentOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Judul Komoditas
                  Text(
                    _product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Harga dan Satuan
                  Row(
                    children: [
                      Text(
                        PriceCalculator.formatRupiah(_product.pricePerKg),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const Text(
                        ' / kg',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Card Informasi Rating & Ketersediaan Stok
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${_product.rating} / 5.0',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                            height: 20, width: 1, color: Colors.grey.shade300),
                        Row(
                          children: [
                            const Icon(Icons.inventory_2_outlined,
                                color: AppColors.primaryGreen, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              _product.isAvailable
                                  ? 'Stok: ${_product.stock} kg'
                                  : 'Stok Kosong',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _product.isAvailable
                                    ? AppColors.textDark
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Deskripsi Nutrisi & Manfaat
                  const Text('Deskripsi Komoditas:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 6),
                  Text(
                    _product.description ??
                        'Sayuran segar berkualitas prima dipetik pagi hari dari kebun mitra hidroponik lokal.',
                    style: const TextStyle(
                        color: AppColors.textMuted, height: 1.5, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Kontrol Jumlah Pembelian
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jumlah Pesanan:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      QuantityCounterWidget(
                        maxStock: _product.stock > 0 ? _product.stock : 1,
                        initialQuantity: _selectedQuantity,
                        onQuantityChanged: (val) {
                          setState(() {
                            _selectedQuantity = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -3)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Pembelian:',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                    Text(
                      PriceCalculator.formatRupiah(
                          _product.pricePerKg * _selectedQuantity),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: '+ Keranjang',
                  icon: Icons.shopping_cart_checkout_rounded,
                  onPressed: _product.isAvailable
                      ? () {
                          // Menambahkan produk sejumlah _selectedQuantity ke CartProvider
                          context.read<CartProvider>().addItem(
                                _product,
                                _selectedQuantity.toDouble(),
                              );

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '$_selectedQuantity kg ${_product.name} ditambahkan ke keranjang!'),
                              backgroundColor: AppColors.primaryGreen,
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'KERANJANG',
                                textColor: Colors.white,
                                onPressed: () => context.pushNamed('cart'),
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
