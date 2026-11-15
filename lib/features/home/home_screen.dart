import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sayur_hub/core/mock/mock_produce_data.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/providers/cart_provider.dart';
import 'package:sayur_hub/core/providers/wishlist_provider.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/core/utils/catalog_processor.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';
import 'package:sayur_hub/shared/widgets/category_pill.dart';
import 'package:sayur_hub/shared/widgets/product_card.dart';
import 'package:sayur_hub/shared/widgets/promo_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Semua';

  void _handleAddToCart(Product product) {
    // Memanggil aksi bisnis addItem pada CartProvider
    context.read<CartProvider>().addItem(product);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} dimasukkan ke keranjang!'),
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: Colors.white,
          onPressed: () => context.pushNamed('cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> allProducts = MockProduceData.products;

    // Mengambil seluruh kategori unik dan menyematkan filter 'Semua' di awal
    final List<String> categories = [
      'Semua',
      ...CatalogProcessor.getProduceCategories(allProducts),
    ];

    // Menyaring daftar produk sesuai kategori yang sedang dipilih pengguna
    final List<Product> displayedProducts =
        CatalogProcessor.filterProductsByCategory(
      products: allProducts,
      categoryName: _selectedCategory,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('SayurHub — Pasar Segar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Cari Sayuran',
            onPressed: () {},
          ),
          // Badge Keranjang Reaktif di AppBar menggunakan Consumer
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
          const SizedBox(width: 4),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primaryGreen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_rounded,
                        size: 32, color: AppColors.primaryGreen),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Siti Nurhaliza',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'siti@smkrpl.sch.id',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.store_mall_directory_rounded,
                  color: AppColors.primaryGreen),
              title: const Text('Katalog Utama'),
              onTap: () => Navigator.pop(context),
            ),
            Consumer<WishlistProvider>(
              builder: (context, wishlist, child) {
                return ListTile(
                  leading: const Icon(Icons.favorite_rounded, color: Colors.red),
                  title: const Text('Produk Favorit'),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${wishlist.count}',
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long_rounded,
                  color: AppColors.primaryGreen),
              title: const Text('Riwayat Transaksi'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded),
              title: const Text('Pusat Bantuan SayurHub'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          if (constraints.maxWidth > 900) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth > 600) {
            crossAxisCount = 3;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const PromoBanner(
                  title: 'PANEN RAYA PETANI LEMBANG',
                  subtitle:
                      'Dapatkan potongan langsung 10% untuk pesanan minimal Rp 50.000.',
                ),
                const SizedBox(height: 20),

                const Text(
                  'Kategori Pilihan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryPill(
                        categoryName: category,
                        isSelected: _selectedCategory == category,
                        onSelected: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Katalog Sayuran (${displayedProducts.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Filter: $_selectedCategory',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (displayedProducts.isEmpty)
                  Container(
                    height: 160,
                    alignment: Alignment.center,
                    child: const Text('Tidak ada produk pada kategori ini.'),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayedProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = displayedProducts[index];
                      return ProductCard(
                        product: product,
                        onAddToCart: () => _handleAddToCart(product),
                      );
                    },
                  ),
                const SizedBox(height: 80), // Ruang ekstra untuk FAB
              ],
            ),
          );
        },
      ),
      // FAB Reaktif yang menampilkan total item dan total belanja realtime
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => context.pushNamed('cart'),
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.shopping_cart_rounded),
            label: Text(
              '${cart.totalQuantity} Item • ${PriceCalculator.formatRupiah(cart.subtotal)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
