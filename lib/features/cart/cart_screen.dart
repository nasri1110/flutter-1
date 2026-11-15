import 'package:flutter/material.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';
import 'package:sayur_hub/shared/widgets/custom_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kartu Ringkasan Keranjang
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.eco_rounded, color: AppColors.primaryGreen),
                      ),
                      title: const Text('Bayam Hijau Hidroponik', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('2 kg x Rp 14.000'),
                      trailing: Text(
                        PriceCalculator.formatRupiah(28000),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.apple_rounded, color: AppColors.accentOrange),
                      ),
                      title: const Text('Alpukat Mentega Super', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('1 kg x Rp 32.000'),
                      trailing: Text(
                        PriceCalculator.formatRupiah(32000),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Rincian Tagihan Biaya
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildCostRow('Subtotal Belanja', PriceCalculator.formatRupiah(60000)),
                  const SizedBox(height: 8),
                  _buildCostRow('Estimasi Ongkos Kirim', PriceCalculator.formatRupiah(10000)),
                  const SizedBox(height: 8),
                  _buildCostRow('Diskon Voucher Panen', '-${PriceCalculator.formatRupiah(5000)}', isDiscount: true),
                  const Divider(height: 24),
                  _buildCostRow('TOTAL PEMBAYARAN', PriceCalculator.formatRupiah(65000), isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Lanjutkan ke Form Checkout (Modul 13)
            CustomButton(
              text: 'Lanjutkan ke Checkout Alamat',
              icon: Icons.arrow_forward_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Formulir Checkout akan diimplementasikan pada Modul 13!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
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
            color: isDiscount ? Colors.red : (isTotal ? AppColors.primaryGreen : AppColors.textDark),
          ),
        ),
      ],
    );
  }
}
