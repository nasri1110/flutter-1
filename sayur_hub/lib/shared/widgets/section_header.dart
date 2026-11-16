import 'package:flutter/material.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';

/// Komponen judul bagian dengan tombol aksi sekunder di sisi kanan
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
        ),
        if (actionText != null && onActionTap != null)
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text(
                actionText!,
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
