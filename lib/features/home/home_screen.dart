import 'package:flutter/material.dart';
import 'package:sayur_hub/core/mock/mock_produce_data.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/core/utils/catalog_processor.dart';
import 'package:sayur_hub/shared/widgets/category_pill.dart';
import 'package:sayur_hub/shared/widgets/product_card.dart';
import 'package:sayur_hub/shared/widgets/promo_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _totalCartItems = 0;
  String _selectedCategory = 'Semua';

  void _handleAddToCart(Product product) {
    setState(() {
      _totalCartItems++;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} dimasukkan ke keranjang belanja!'),
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(seconds: 1),
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
    final List<Product> displayedProducts = CatalogProcessor.filterProductsByCategory(
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
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
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
                    child: Icon(Icons.person_rounded, size: 32, color: AppColors.primaryGreen),
                  ),
                  SizedBox(height: 8),
                  Text('Siti Nurhaliza', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('siti@smkrpl.sch.id', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded, color: AppColors.primaryGreen),
              title: const Text('Katalog Beranda'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Menentukan jumlah kolom secara dinamis sesuai lebar layar perangkat
          final double screenWidth = constraints.maxWidth;
          final int crossAxisCount = screenWidth >= 900
              ? 4
              : screenWidth >= 600
                  ? 3
                  : 2;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Banner Promosi Panen Raya
                const PromoBanner(
                  discountTag: 'DISKON PANEN 25%',
                  title: 'Panen Sayur Segar Lembang',
                  subtitle: 'Sayuran organik bebas pestisida dipetik langsung pagi hari ini.',
                  iconData: Icons.eco_rounded,
                ),
                const SizedBox(height: 20),

                // 2. Baris Filter Kategori Horizontal
                Text(
                  'Kategori Pilihan:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryPill(
                        label: category,
                        isSelected: _selectedCategory == category,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Header Informasi Jumlah Komoditas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Katalog Komoditas (${displayedProducts.length}):',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    Text(
                      'Grid: $crossAxisCount Kolom',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4. GridView Katalog Responsif
                if (displayedProducts.isEmpty)
                  Container(
                    height: 200,
                    width: double.infinity,
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
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Total belanjaan saat ini: $_totalCartItems item'),
            ),
          );
        },
        icon: const Icon(Icons.shopping_cart_rounded),
        label: Text('Keranjang ($_totalCartItems)'),
      ),
    );
  }
}
