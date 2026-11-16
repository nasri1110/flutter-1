import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sayur_hub/core/models/product.dart';
import 'package:sayur_hub/core/providers/cart_provider.dart';
import 'package:sayur_hub/core/providers/product_catalog_provider.dart';
import 'package:sayur_hub/core/providers/wishlist_provider.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';
import 'package:sayur_hub/shared/widgets/category_pill.dart';
import 'package:sayur_hub/shared/widgets/product_card.dart';
import 'package:sayur_hub/shared/widgets/product_card_shimmer.dart';
import 'package:sayur_hub/shared/widgets/promo_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  static const List<String> _categories = [
    'Semua',
    'Sayuran Daun',
    'Sayuran Buah',
    'Sayuran Umbi',
    'Buah Segar',
    'Rempah & Herbal',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Deteksi saat pengguna menggulir mendekati 200 px dari batas bawah
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductCatalogProvider>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleAddToCart(Product product) {
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
    final catalogProvider = context.watch<ProductCatalogProvider>();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Ketik nama sayur / buah...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  context.read<ProductCatalogProvider>().search(val);
                },
              )
            : const Text('SayurHub — Pasar Segar'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded),
            tooltip: _isSearching ? 'Tutup Pencarian' : 'Cari Sayuran',
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<ProductCatalogProvider>().search('');
                }
              });
            },
          ),
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
              title: const Text('Katalog Utama (REST API)'),
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

          // RefreshIndicator untuk mendukung fitur Pull-to-Refresh
          return RefreshIndicator(
            color: AppColors.primaryGreen,
            onRefresh: () async {
              await context.read<ProductCatalogProvider>().fetchCatalog(isRefresh: true);
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const PromoBanner(
                    title: 'PANEN RAYA PETANI LEMBANG',
                    subtitle:
                        'Dapatkan potongan langsung 10% untuk pesanan minimal Rp 50.000.',
                    discountTag: 'DISKON 10%',
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
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return CategoryPill(
                          categoryName: category,
                          isSelected:
                              catalogProvider.selectedCategory == category,
                          onSelected: () {
                            context
                                .read<ProductCatalogProvider>()
                                .setCategory(category);
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
                        'Katalog Sayuran (${catalogProvider.products.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Filter: ${catalogProvider.selectedCategory}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Area Konten Dinamis REST API (Loading Shimmer, Error, Empty, atau Grid Produk)
                  _buildCatalogBody(catalogProvider, crossAxisCount),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
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

  /// Membangun antarmuka katalog sesuai status jaringan REST API
  Widget _buildCatalogBody(
      ProductCatalogProvider catalog, int crossAxisCount) {
    if (catalog.isLoading) {
      // 1. Loading State: Menampilkan 6 skeleton shimmer cards
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) => const ProductCardShimmer(),
      );
    }

    if (catalog.isError) {
      // 2. Error State: Menampilkan pesan kesalahan dan tombol coba lagi
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              'Gagal Memuat Katalog Sayur',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              catalog.errorMessage ?? 'Periksa koneksi internet Anda.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              onPressed: () => catalog.retry(),
            ),
          ],
        ),
      );
    }

    if (catalog.isEmpty) {
      // 3. Empty State: Hasil filter/pencarian tidak ditemukan
      return Container(
        height: 180,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 48, color: AppColors.textMuted),
            const SizedBox(height: 10),
            Text(
              'Tidak ada produk ditemukan untuk "${catalog.searchQuery.isNotEmpty ? catalog.searchQuery : catalog.selectedCategory}".',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      );
    }

    // 4. Success State: Menampilkan produk hasil fetch API
    final displayedProducts = catalog.products;
    return Column(
      children: [
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

        // Indikator Pemuatan Halaman Tambahan (Infinite Scroll)
        if (catalog.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Memuat komoditas berikutnya...',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),

        // Indikator Akhir Halaman Data
        if (!catalog.hasMore && catalog.products.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                '— Seluruh komoditas segar telah ditampilkan —',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
