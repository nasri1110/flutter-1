import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sayur_hub/core/models/cart_item.dart';
import 'package:sayur_hub/core/providers/cart_provider.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';
import 'package:sayur_hub/shared/widgets/custom_button.dart';

/// Halaman Keranjang Belanja Reaktif SayurHub
/// Terhubung penuh dengan CartProvider menggunakan Consumer dan context.read
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Sayur Segar'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Kosongkan Keranjang',
                onPressed: () {
                  _showClearCartDialog(context);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryGreen),
                  SizedBox(height: 16),
                  Text('Memuat keranjang sayur...'),
                ],
              ),
            );
          }

          if (cart.isEmpty) {
            return _buildEmptyCartView(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Info Promo Panen
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer_rounded,
                          color: AppColors.primaryGreen, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          cart.subtotal >= 50000
                              ? 'Selamat! Anda berhak mendapatkan diskon promo otomatis 10%!'
                              : 'Tambah belanja hingga Rp 50.000 untuk menikmati diskon promo 10%!',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Daftar Item Komoditas dalam Keranjang
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final CartItem item = cart.items[index];
                    return _buildCartItemCard(context, item);
                  },
                ),
                const SizedBox(height: 20),

                // Rincian Kalkulasi Harga
                _buildPriceSummary(cart),
                const SizedBox(height: 24),

                // Tombol Eksekusi Menuju Formulir Checkout Alamat
                CustomButton(
                  text: 'Lanjutkan ke Checkout Alamat',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    context.pushNamed('checkout');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Tampilan ketika keranjang masih kosong melompong
  Widget _buildEmptyCartView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_basket_outlined,
                size: 80,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Keranjang Belanja Kosong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Wah, Anda belum memilih sayur atau buah segar. Yuk jelajahi pasar sekarang!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.storefront_rounded),
              label: const Text('Mulai Belanja Sekarang'),
              onPressed: () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu per item keranjang dengan kontroler kuantitas (+, -, hapus)
  Widget _buildCartItemCard(BuildContext context, CartItem item) {
    final cart = context.read<CartProvider>();
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbnail Ikon Produk
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.product.category == 'Buah Segar'
                    ? Icons.apple_rounded
                    : Icons.eco_rounded,
                color: AppColors.primaryGreen,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),

            // Deskripsi Nama & Harga
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${PriceCalculator.formatRupiah(item.product.pricePerKg)} / kg',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    PriceCalculator.formatRupiah(item.subtotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Kontrol Stepper Kuantitas (+, -, tong sampah)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 22),
                  color: Colors.grey.shade600,
                  onPressed: () {
                    cart.removeSingleItem(item.product.id);
                  },
                ),
                Text(
                  '${item.quantity.toInt()} kg',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 22),
                  color: AppColors.primaryGreen,
                  onPressed: () {
                    if (item.quantity < item.product.stock) {
                      cart.addItem(item.product, 1.0);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Maksimal stok tercapai (${item.product.stock} kg)'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  onPressed: () {
                    cart.removeItem(item.product.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu Ringkasan Perhitungan Harga
  Widget _buildPriceSummary(CartProvider cart) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Belanja',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCostRow('Total Kuantitas Komoditas', '${cart.totalQuantity} kg'),
            const SizedBox(height: 6),
            _buildCostRow('Subtotal Belanja', PriceCalculator.formatRupiah(cart.subtotal)),
            if (cart.discountAmount > 0) ...[
              const SizedBox(height: 6),
              _buildCostRow(
                'Diskon Promo Panen (10%)',
                '- ${PriceCalculator.formatRupiah(cart.discountAmount)}',
                isDiscount: true,
              ),
            ],
            const Divider(height: 20),
            _buildCostRow(
              'Estimasi Total Belanja',
              PriceCalculator.formatRupiah(cart.grandTotal),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value,
      {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.textDark : AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isDiscount
                ? Colors.red
                : (isTotal ? AppColors.primaryGreen : AppColors.textDark),
          ),
        ),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kosongkan Keranjang?'),
        content: const Text('Seluruh sayuran dan buah yang telah dipilih akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<CartProvider>().clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Ya, Kosongkan'),
          ),
        ],
      ),
    );
  }
}
