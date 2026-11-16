import 'package:flutter/material.dart';
import 'package:sayur_hub/core/mock/mock_produce_data.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/core/utils/catalog_processor.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CatalogProcessor.getProduceCategories(MockProduceData.products).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Sayur & Buah')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eco_rounded, color: AppColors.primaryGreen),
              ),
              title: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
