import 'package:flutter/material.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';

/// Komponen penghitung jumlah belanjaan sayur (kg) berbasis StatefulWidget
/// Mengelola status mutasi kuantitas lokal secara aman sesuai ketersediaan stok
class QuantityCounterWidget extends StatefulWidget {
  final int initialQuantity;
  final int maxStock;
  final ValueChanged<int> onQuantityChanged;

  const QuantityCounterWidget({
    super.key,
    this.initialQuantity = 1,
    required this.maxStock,
    required this.onQuantityChanged,
  });

  @override
  State<QuantityCounterWidget> createState() => _QuantityCounterWidgetState();
}

class _QuantityCounterWidgetState extends State<QuantityCounterWidget> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    // Inisialisasi status awal dari parameter widget
    _quantity = widget.initialQuantity;
  }

  void _increment() {
    if (_quantity < widget.maxStock) {
      setState(() {
        _quantity++;
      });
      widget.onQuantityChanged(_quantity);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Batas maksimal stok tercapai (${widget.maxStock} kg)!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
      widget.onQuantityChanged(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tombol Kurang [-]
          IconButton(
            icon: const Icon(Icons.remove_rounded),
            color: _quantity > 1 ? AppColors.primaryGreen : Colors.grey.shade400,
            iconSize: 20,
            splashRadius: 20,
            onPressed: _quantity > 1 ? _decrement : null,
          ),

          // Teks Kuantitas Tengah
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$_quantity kg',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
          ),

          // Tombol Tambah [+]
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: _quantity < widget.maxStock ? AppColors.primaryGreen : Colors.grey.shade400,
            iconSize: 20,
            splashRadius: 20,
            onPressed: _quantity < widget.maxStock ? _increment : null,
          ),
        ],
      ),
    );
  }
}
