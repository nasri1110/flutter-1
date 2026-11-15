import 'package:flutter/material.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/shared/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Siti Nurhaliza',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'siti@smkrpl.sch.id | +62 812-3456-7890',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 28),
            ListTile(
              leading: const Icon(Icons.location_on_outlined, color: AppColors.primaryGreen),
              title: const Text('Alamat Rumah Terdaftar'),
              subtitle: const Text('Jl. Merdeka No. 45, Bandung Barat'),
              trailing: const Icon(Icons.edit_outlined, size: 18),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryGreen),
              title: const Text('Keamanan & Kata Sandi'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded, color: AppColors.primaryGreen),
              title: const Text('Pusat Bantuan & Petani Mitra'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {},
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Keluar dari Akun',
              icon: Icons.logout_rounded,
              backgroundColor: Colors.red.shade700,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sesi logout akan diaktifkan di Modul 17!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
