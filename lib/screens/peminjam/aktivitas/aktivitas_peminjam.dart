import 'package:aplikasi_pinjam_ukk/controller/peminjaman_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/peminjaman/models/peminjaman_model.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/aktivitas/widgets/cars_aktivity.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/aktivitas/widgets/filter_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AktivitasPeminjam extends StatefulWidget {
  const AktivitasPeminjam({super.key});

  @override
  State<AktivitasPeminjam> createState() => _AktivitasPeminjamState();
}

class _AktivitasPeminjamState extends State<AktivitasPeminjam> {
  final PeminjamanController peminjamanController = Get.put(PeminjamanController());
  final TextEditingController searchController = TextEditingController();
  String selectedFilter = 'semua';

  @override
  void initState() {
    super.initState();
    peminjamanController.fetchUserPeminjaman();
  }

  List<PeminjamanModel> getFilteredPeminjaman() {
    var filtered = peminjamanController.peminjamanList.toList();

    if (selectedFilter != 'semua') {
      if (selectedFilter == 'selesai') {
        // Asumsikan 'selesai' berarti status 'dikembalikan' atau status akhir
        filtered = filtered.where((peminjaman) =>
            peminjaman.status?.toLowerCase() == 'dikembalikan' || peminjaman.status?.toLowerCase() == 'selesai').toList();
      } else {
        filtered = filtered.where((peminjaman) =>
            peminjaman.status?.toLowerCase() == selectedFilter).toList();
      }
    }

    if (searchController.text.isNotEmpty) {
      filtered = filtered.where((peminjaman) =>
          peminjaman.namaAlat?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Aktivitas Saya',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Kolom Pencarian
              TextField(
                controller: searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari alat...',
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChipWidget(
                      label: 'semua',
                      isSelected: selectedFilter == 'semua',
                      onSelected: () => setState(() => selectedFilter = 'semua'),
                    ),
                    const SizedBox(width: 8),
                    FilterChipWidget(
                      label: 'menunggu persetujuan',
                      isSelected: selectedFilter == 'menunggu persetujuan',
                      onSelected: () => setState(() => selectedFilter = 'menunggu persetujuan'),
                    ),
                    const SizedBox(width: 8),
                    FilterChipWidget(
                      label: 'disetujui',
                      isSelected: selectedFilter == 'disetujui',
                      onSelected: () => setState(() => selectedFilter = 'disetujui'),
                    ),
                    const SizedBox(width: 8),
                    FilterChipWidget(
                      label: 'selesai',
                      isSelected: selectedFilter == 'selesai',
                      onSelected: () => setState(() => selectedFilter = 'selesai'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Daftar Kartu Aktivitas
              Expanded(
                child: Obx(() {
                  if (peminjamanController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final filteredPeminjaman = getFilteredPeminjaman();

                  if (filteredPeminjaman.isEmpty) {
                    return const Center(child: Text('Tidak ada aktivitas'));
                  }

                  return ListView.builder(
                    itemCount: filteredPeminjaman.length,
                    itemBuilder: (context, index) {
                      final peminjaman = filteredPeminjaman[index];
                      final dateFormat = DateFormat('dd MMM');
                      final tanggalPinjam = peminjaman.tanggalPinjam != null
                          ? dateFormat.format(peminjaman.tanggalPinjam!)
                          : '';
                      final tanggalKembali = dateFormat.format(peminjaman.tanggalKembali);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ActivityCardWidget(
                          name: peminjaman.emailPeminjam ?? 'ALAT ${peminjaman.namaAlat ?? '-'}',
                          item: 'Jumlah: ${peminjaman.jumlahAlat} | Petugas: ${peminjaman.namaPetugas ?? 'Belum disetujui'}',
                          date: '$tanggalPinjam - $tanggalKembali',
                          status: peminjaman.status ?? 'unknown',
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
