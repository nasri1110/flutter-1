import 'package:flutter/material.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/features/category/categories_screen.dart';
import 'package:sayur_hub/features/home/home_screen.dart';
import 'package:sayur_hub/features/orders/order_history_screen.dart';
import 'package:sayur_hub/features/profile/profile_screen.dart';

/// Kerangka navigasi utama aplikasi SayurHub (Shell Navigation)
/// Memadukan IndexedStack untuk preservasi state halaman dan NavigationBar M3
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _activeTabIndex = 0;

  // Daftar 4 halaman utama yang dikelola dalam memori
  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga posisi scroll dan status memori pada setiap tab
      body: IndexedStack(
        index: _activeTabIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _activeTabIndex,
        onDestinationSelected: (int selectedIndex) {
          setState(() {
            _activeTabIndex = selectedIndex;
          });
        },
        elevation: 3,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryGreen.withOpacity(0.18),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.primaryGreen),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            selectedIcon: Icon(Icons.grid_view_sharp, color: AppColors.primaryGreen),
            label: 'Kategori',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primaryGreen),
            label: 'Pesanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primaryGreen),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
