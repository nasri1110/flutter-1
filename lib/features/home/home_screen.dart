import 'package:flutter/material.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';

/// Halaman Beranda Utama aplikasi SayurHub
/// Menggunakan kanvas Scaffold lengkap dengan AppBar, Drawer, dan FloatingActionButton
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca informasi ukuran layar perangkat menggunakan BuildContext
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SayurHub — Pasar Segar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifikasi Panen',
            onPressed: () {
              // Menampilkan pesan snackbar memanfaatkan context
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Belum ada notifikasi panen baru.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_rounded, size: 36, color: AppColors.primaryGreen),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Siti Nurhaliza',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'siti@smkrpl.sch.id',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded, color: AppColors.primaryGreen),
              title: const Text('Beranda SayurHub'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text('Riwayat Transaksi'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Pengaturan'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Selamat Datang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panen Pagi Hari Ini!',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primaryGreen,
                              ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sayuran hijau organik dipetik pukul 05.00 WIB langsung dari kebun Lembang.',
                          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.eco_rounded, size: 48, color: AppColors.primaryGreen),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Indikator Lebar Layar (Demo BuildContext MediaQuery)
            Text(
              'Informasi Layar:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lebar Layar Smartphone:'),
                  Text(
                    '${screenWidth.toStringAsFixed(1)} dp',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Informasi Modul Selanjutnya
            Text(
              'Status Pengembangan:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Card(
              elevation: 0,
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen),
                title: Text('Modul 08 Selesai: Arsitektur & Scaffold Siap'),
                subtitle: Text('Siap membangun kartu produk mandiri pada Modul 09.'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Keranjang belanja siap diintegrasikan pada Modul 14!'),
            ),
          );
        },
        icon: const Icon(Icons.shopping_cart_rounded),
        label: const Text('Keranjang (0)'),
      ),
    );
  }
}
