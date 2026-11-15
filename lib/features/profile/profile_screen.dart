import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sayur_hub/core/providers/auth_provider.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/shared/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil Pengguna')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined,
                    size: 72,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Masuk ke Akun Anda',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masuk untuk mengakses riwayat transaksi, diskon khusus member, dan kemudahan checkout.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Masuk Sekarang',
                  icon: Icons.login_rounded,
                  onPressed: () => context.pushNamed('login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: AppColors.primaryGreen,
                child: Icon(Icons.person_rounded, size: 54, color: Colors.white),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              user?.fullName ?? 'Siti Nurhaliza',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${user?.email ?? "siti@smkrpl.sch.id"} | ${user?.phoneNumber ?? "+62 812-3456-7890"}',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Badge Status Autentikasi JWT Terenkripsi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user_rounded,
                      size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 6),
                  Text(
                    'Sesi JWT Aktif (${auth.token != null ? auth.token!.substring(0, 15) : "Terverifikasi"}...)',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.location_on_outlined,
                  color: AppColors.primaryGreen),
              title: const Text('Alamat Rumah Terdaftar'),
              subtitle: Text(
                  user?.address ?? 'Jl. Merdeka No. 45, Bandung Barat'),
              trailing: const Icon(Icons.edit_outlined, size: 18),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock_outline_rounded,
                  color: AppColors.primaryGreen),
              title: const Text('Keamanan & Enkripsi Keystore'),
              subtitle: const Text('FlutterSecureStorage aktif'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded,
                  color: AppColors.primaryGreen),
              title: const Text('Pusat Bantuan SayurHub'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {},
            ),
            const SizedBox(height: 32),

            CustomButton(
              text: 'Keluar dari Akun (Logout)',
              icon: Icons.logout_rounded,
              backgroundColor: Colors.red.shade700,
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Akun?'),
        content: const Text(
          'Token JWT akan dihapus dari FlutterSecureStorage. Anda perlu masuk kembali untuk melakukan pemesanan.',
        ),
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
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Anda telah berhasil keluar dari akun.'),
                  ),
                );
              }
            },
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }
}
