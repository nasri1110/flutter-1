# SPESIFIKASI KEBUTUHAN PERANGKAT LUNAK (SRS)
## PROYEK: SAYURHUB — E-COMMERCE SAYUR DAN BUAH SEGAR
**Versi Dokumen**: 1.0.0  
**Target Pengguna**: Siswa SMK RPL, Instruktur, Penguji Teknis, dan Calon Konsumen

---

## 1. PENDAHULUAN
### 1.1 Tujuan Proyek
SayurHub dibangun untuk mendistribusikan komoditas pangan segar (sayur, buah, bumbu herbal) dari petani lokal langsung ke tangan konsumen akhir secara efisien dengan jaminan kesegaran maksimal.

### 1.2 Cakupan Sistem (System Scope)
Aplikasi mobile client-side berbasis Flutter yang terintegrasi dengan REST API Laravel, basis data lokal SQLite untuk persistensi offline, dan gateway pembayaran.

---

## 2. KEBUTUHAN FUNGSIONAL UTAMA (20 FITUR PRODUKSI)
1. **Splash Screen Dinamis**: Tampilan pembuka dengan animasi logo dan pemeriksaan sesi otomatis.
2. **Onboarding Slider**: Pengenalan 3 proposisi nilai (Segar dari Kebun, Pengiriman Cepat Pagi Hari, Garansi Ganti Baru).
3. **Pendaftaran Pengguna (Register)**: Validasi formulir nama, email, nomor HP (+62), password.
4. **Otentikasi Pengguna (Login & Logout)**: Validasi kredensial, token JWT tersimpan aman di secure storage.
5. **Dashboard Beranda (Home)**: Banner promosi, pencarian cepat, baris kategori, dan katalog produk.
6. **Katalog Produk Dinamis**: Grid view responsif kartu sayur/buah dengan indikator stok dan harga per kg.
7. **Filter & Kategori**: Kategori Sayuran Hijau, Buah Segar, Umbi-umbian, Bumbu Dapur, Organik.
8. **Halaman Detail Produk**: Galeri gambar resolusi tinggi, informasi nutrisi, rating ulasan, selektor kuantitas.
9. **Pencarian Real-Time (Live Search)**: Pencarian nama produk dengan algoritma debouncing (500 ms).
10. **Keranjang Belanja Reaktif**: State management Provider untuk penambahan/pengurangan jumlah kuantitas dan auto-update total belanja.
11. **Manajemen Checkout**: Kalkulasi biaya produk, asuransi kesegaran, dan ongkos kirim.
12. **Manajemen Alamat Pengiriman**: Pemilihan alamat tujuan rumah, catatan kurir (contoh: 'titip di pagar').
13. **Riwayat Transaksi**: Daftar riwayat belanja dengan status (Menunggu Pembayaran, Dikemas, Dikirim, Selesai).
14. **Detail Pesanan & Invoice**: Rincian tagihan digital dan nomor resi kurir pengiriman.
15. **Halaman Profil Pengguna**: Informasi akun, pengaturan notifikasi, ubah kata sandi.
16. **Upload Foto Profil & Bukti Bayar**: Integrasi kamera perangkat keras dan galeri foto via image_picker.
17. **Integrasi REST API Backend**: Komunikasi data menggunakan protokol HTTP/JSON secara asinkron.
18. **Persistensi Data Offline**: Keranjang dan cache katalog tersimpan di SQLite lokal.
19. **Penanganan Status Jaringan**: Shimmer loading effect, empty state visual, dan dialog koneksi internet terputus.
20. **Desain Antarmuka Responsif**: Mendukung layar smartphone berbagai rasio hingga tablet Android.

---

## 3. KEBUTUHAN NON-FUNGSIONAL
- **Performa**: Waktu muat awal (*cold start*) < 2.5 detik; animasi katalog konsisten pada 60 FPS tanpa jank.
- **Keamanan**: Token otentikasi disimpan di hardware-backed Android Keystore / iOS Keychain (`flutter_secure_storage`).
- **Skalabilitas**: Struktur kode mematuhi prinsip Clean Architecture (*Feature-First*).
