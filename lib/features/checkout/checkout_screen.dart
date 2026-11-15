import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sayur_hub/core/providers/cart_provider.dart';
import 'package:sayur_hub/core/theme/app_colors.dart';
import 'package:sayur_hub/core/utils/price_calculator.dart';
import 'package:sayur_hub/shared/widgets/custom_button.dart';

/// Halaman formulir pengisian alamat pengiriman dan opsi logistik SayurHub
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // 1. Kunci Global Pengendali Validasi Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Kontroler Teks (Wajib di-dispose di akhir)
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  // 3. State Opsi Input Pilihan
  String? _selectedCourier = 'INSTANT'; // Pilihan Kurir
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 1)); // Jadwal Besok
  bool _useFreshGuarantee = true; // Asuransi Kesegaran (+Rp 2.000)
  String _deliveryTimeSlot = 'PAGI'; // Slot Pagi vs Sore
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Siti Nurhaliza');
    _phoneController = TextEditingController(text: '081234567890');
    _addressController = TextEditingController(text: 'Jl. Merdeka No. 45, Bandung Barat');
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    // Membersihkan seluruh controller dari memori RAM
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Fungsi pemilih tanggal kalender
  Future<void> _pickDeliveryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      helpText: 'PILIH TANGGAL PENGIRIMAN SAYUR',
    );
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  void _handleSubmitOrder() async {
    // Validasi seluruh input secara serentak
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon perbaiki kolom formulir yang bertanda merah!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulasi pengiriman order ke backend selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    // Tampilkan dialog sukses pesanan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 28),
            SizedBox(width: 8),
            Text('Pesanan Berhasil!'),
          ],
        ),
        content: Text(
          'Terima kasih ${_nameController.text.trim()}. Pesanan sayur segar Anda dijadwalkan tiba pada ${_deliveryDate.day}/${_deliveryDate.month}/${_deliveryDate.year} (Slot $_deliveryTimeSlot).',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.white),
            onPressed: () {
              context.read<CartProvider>().clearCart();
              ctx.pop(); // Tutup dialog
              context.go('/'); // Kembali ke Beranda
            },
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    // Perhitungan ongkir dinamis sesuai kurir yang dipilih
    final double courierFee = _selectedCourier == 'INSTANT'
        ? 15000.0
        : _selectedCourier == 'SAMEDAY'
            ? 10000.0
            : 7000.0;
    final double insuranceFee = _useFreshGuarantee ? 2000.0 : 0.0;
    final double subtotalProduk = cart.grandTotal > 0 ? cart.grandTotal : 60000.0;
    final double grandTotal = subtotalProduk + courierFee + insuranceFee;

    return Scaffold(
      appBar: AppBar(title: const Text('Alamat & Pengiriman')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian 1: Data Penerima
              _buildSectionTitle('1. Data Penerima Sayur'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: _buildInputDecoration(
                  label: 'Nama Lengkap Penerima',
                  hint: 'Masukkan nama Anda',
                  icon: Icons.person_rounded,
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 3) {
                    return 'Nama minimal harus memuat 3 huruf!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration(
                  label: 'Nomor WhatsApp Aktif',
                  hint: 'Contoh: 081234567890',
                  icon: Icons.phone_rounded,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nomor WhatsApp wajib diisi untuk konfirmasi kurir!';
                  }
                  final RegExp phoneRegex = RegExp(r'^(?:\+62|62|0)8[1-9][0-9]{7,10}$');
                  if (!phoneRegex.hasMatch(val.trim())) {
                    return 'Format nomor tidak valid (Contoh: 081234567890)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Bagian 2: Alamat Pengiriman
              _buildSectionTitle('2. Alamat Lengkap Rumah'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: _buildInputDecoration(
                  label: 'Alamat Rumah / Kantor',
                  hint: 'Nama jalan, nomor rumah, RT/RW, kelurahan',
                  icon: Icons.location_on_rounded,
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 10) {
                    return 'Alamat terlalu pendek! Masukkan alamat lengkap (minimal 10 karakter).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: _buildInputDecoration(
                  label: 'Catatan Patokan (Opsional)',
                  hint: 'Contoh: Rumah pagar hitam samping masjid',
                  icon: Icons.note_alt_rounded,
                ),
              ),
              const SizedBox(height: 20),

              // Bagian 3: Opsi Kurir & Logistik
              _buildSectionTitle('3. Kurir Pengiriman'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCourier,
                decoration: _buildInputDecoration(
                  label: 'Pilih Metode Ekspedisi',
                  hint: 'Pilih kurir',
                  icon: Icons.local_shipping_rounded,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'INSTANT',
                    child: Text('Instant Sayur (1 Jam Tiba) — Rp 15.000'),
                  ),
                  DropdownMenuItem(
                    value: 'SAMEDAY',
                    child: Text('Same Day Sayur Pagi — Rp 10.000'),
                  ),
                  DropdownMenuItem(
                    value: 'REGULAR',
                    child: Text('Pengiriman Reguler Esok Hari — Rp 7.000'),
                  ),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedCourier = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Bagian 4: Jadwal Tanggal & Slot Waktu
              _buildSectionTitle('4. Jadwal Pengantaran Sayur'),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickDeliveryDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: AppColors.primaryGreen),
                          const SizedBox(width: 10),
                          Text(
                            'Tanggal: ${_deliveryDate.day}/${_deliveryDate.month}/${_deliveryDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      const Text('Ganti', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Pilihan Slot Pagi / Sore (Radio Button)
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Pagi\n06.00-09.00', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      value: 'PAGI',
                      groupValue: _deliveryTimeSlot,
                      activeColor: AppColors.primaryGreen,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _deliveryTimeSlot = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Sore\n15.00-18.00', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      value: 'SORE',
                      groupValue: _deliveryTimeSlot,
                      activeColor: AppColors.primaryGreen,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _deliveryTimeSlot = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Switch Asuransi Garansi Kesegaran
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primaryGreen,
                title: const Text('Garansi Kesegaran 100% (+Rp 2.000)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text('Ganti baru gratis jika ada sayur layu/busuk saat tiba.', style: TextStyle(fontSize: 11)),
                value: _useFreshGuarantee,
                onChanged: (val) => setState(() => _useFreshGuarantee = val),
              ),
              const Divider(height: 32),

              // Ringkasan Tagihan Terkini
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pembayaran Akhir:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(
                    PriceCalculator.formatRupiah(grandTotal),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Submit Pesanan Terpadu
              CustomButton(
                text: 'Konfirmasi Pesanan Sayur',
                icon: Icons.lock_outline_rounded,
                isLoading: _isSubmitting,
                onPressed: _handleSubmitOrder,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primaryGreen),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
      ),
    );
  }
}
