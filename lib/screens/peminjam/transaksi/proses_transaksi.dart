import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/auth_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/peminjaman_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/models/alat_models.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/dashboard_peminjam.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/transaksi/widgets/persetujuan_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProsesTransaksi extends StatefulWidget {
  const ProsesTransaksi({super.key});

  @override
  State<ProsesTransaksi> createState() => _ProsesTransaksiState();
}

class _ProsesTransaksiState extends State<ProsesTransaksi> {
  // --- SEMUA LOGIKA STATE DAN CONTROLLER ANDA TETAP SAMA ---
  final AlatController alatC = Get.find();
  final AuthController authC = Get.find();
  final PeminjamanController peminjamanC = Get.put(PeminjamanController());
  final TextEditingController tanggalPinjamController = TextEditingController();
  final TextEditingController tanggalKembaliController = TextEditingController();
  DateTime? tanggalPinjam;
  DateTime? tanggalKembali;

  @override
  void initState() {
    super.initState();
    tanggalPinjam = DateTime.now();
    tanggalPinjamController.text = DateFormat('d MMMM yyyy', 'id_ID').format(tanggalPinjam!);
  }

  Future<void> _selectDate(BuildContext context, bool isPinjam) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPinjam ? tanggalPinjam! : (tanggalKembali ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isPinjam) {
          tanggalPinjam = picked;
          tanggalPinjamController.text = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
        } else {
          tanggalKembali = picked;
          tanggalKembaliController.text = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
        }
      });
    }
  }

  void _konfirmasiPeminjaman() async {
    if (tanggalKembali == null) {
      Get.snackbar('Error', 'Pilih tanggal kembali', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (alatC.selectedAlatMap.isEmpty) {
      Get.snackbar('Error', 'Tidak ada alat yang dipilih', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    bool success = await peminjamanC.createPeminjaman(
      userId: authC.userId.value!,
      tanggalPinjam: tanggalPinjam!,
      tanggalKembali: tanggalKembali!,
      selectedAlat: alatC.selectedAlatMap,
    );
    if (success) {
      alatC.selectedAlatMap.value = {};
      _showPersetujuanDialog(() {
        Get.snackbar('Sukses', 'Peminjaman berhasil dibuat', backgroundColor: Colors.green, colorText: Colors.white);
        _navigasiKeHome();
      });
    }
  }
  
void _showPersetujuanDialog(VoidCallback onOk) {
  showDialog(
    context: context,
    barrierDismissible: false, // Mencegah menutup dialog dengan menekan di luar dialog
    builder: (BuildContext context) {
      return PersetujuanDialog(
        onOk: onOk, // Fungsi yang dipanggil setelah OK
      );
    },
  );
}
 // Fungsi untuk menavigasi ke halaman Home setelah klik OK
  void _navigasiKeHome() {
    Get.offAll(() => const DashboardPeminjam()); // Navigasi ke dashboard peminjam
  }
  // --- UI YANG SUDAH DIREVISI ---
  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Peminjaman', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: _buildBottomAction(primaryBlue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRingkasanSection(), // Widget ringkasan yang sudah diperbaiki
            const SizedBox(height: 24),
            _buildTanggalSection(),
          ],
        ),
      ),
    );
  }

  // WIDGET RINGKASAN ALAT - PERBAIKAN UTAMA DI SINI
  Widget _buildRingkasanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ringkasan Alat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          // Tinggi tidak lagi di-set, akan otomatis menyesuaikan
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300), // Menambahkan border
          ),
          child: Obx(() {
            if (alatC.selectedAlatMap.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Center(child: Text('Tidak ada alat dipilih')),
              );
            }
            return ListView.builder(
              shrinkWrap: true, // <-- KUNCI PERBAIKAN: Membuat ListView seukuran kontennya
              physics: const NeverScrollableScrollPhysics(), // Agar tidak ada double scroll
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: alatC.selectedAlatMap.length,
              itemBuilder: (context, index) {
                final alatId = alatC.selectedAlatMap.keys.elementAt(index);
                final qty = alatC.selectedAlatMap[alatId];
                final AlatModel? alat = alatC.alatList.firstWhereOrNull((e) => e.alatId == alatId);
                if (alat == null) return const SizedBox.shrink();
                return _buildAlatCard(alat, qty!);
              },
            );
          }),
        ),
      ],
    );
  }

  // KARTU ALAT (dengan sedikit penyesuaian padding)
  Widget _buildAlatCard(AlatModel alat, int qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              alat.imageUrl ?? 'https://via.placeholder.com/150',
              width: 50, height: 50, fit: BoxFit.cover, // Ukuran gambar sedikit lebih kecil
              errorBuilder: (c, e, s) => const Icon(Icons.inventory_2, size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alat.namaAlat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Jumlah: $qty', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
         
        ],
      ),
    );
  }

  // WIDGET PEMILIHAN TANGGAL (UI tetap sama, sudah bagus)
  Widget _buildTanggalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Detail Peminjaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildDatePickerField(
          controller: tanggalPinjamController,
          label: 'Tanggal Pinjam',
          onTap: () => _selectDate(context, true),
        ),
        const SizedBox(height: 16),
        _buildDatePickerField(
          controller: tanggalKembaliController,
          label: 'Tanggal Kembali',
          onTap: () => _selectDate(context, false),
        ),
      ],
    );
  }

  // WIDGET INPUT TANGGAL (UI tetap sama, sudah bagus)
  Widget _buildDatePickerField({required TextEditingController controller, required String label, required VoidCallback onTap}) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF0D47A1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
        ),
      ),
    );
  }

  // WIDGET AKSI DI BAWAH (UI tetap sama, sudah bagus)
  Widget _buildBottomAction(Color primaryBlue) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 10)],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Alat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Obx(() {
                int total = alatC.selectedAlatMap.values.fold(0, (sum, item) => sum + item);
                return Text('$total Unit', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
              }),
            ],
          ),
         SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _konfirmasiPeminjaman, // Langsung konfirmasi peminjaman
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Konfirmasi Peminjaman', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
         ),
        ],
      ),
    );
  }
}
