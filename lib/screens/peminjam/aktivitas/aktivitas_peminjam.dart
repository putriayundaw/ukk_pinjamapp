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
  final PeminjamanController peminjamanController =
      Get.put(PeminjamanController());

  final TextEditingController searchController = TextEditingController();

  String selectedFilter = 'semua';

  @override
  void initState() {
    super.initState();
    peminjamanController.fetchUserPeminjaman();
  }

  // ================= FILTER FUNCTION =================
  List<PeminjamanModel> getFilteredPeminjaman() {
    var filtered = peminjamanController.peminjamanList.toList();

    // FILTER STATUS
    if (selectedFilter != 'semua') {
      filtered = filtered.where((p) {
        final status = (p.status ?? '').toLowerCase().trim();

        if (selectedFilter == 'selesai') {
          return status == 'dikembalikan' || status == 'selesai';
        }

        return status == selectedFilter.toLowerCase().trim();
      }).toList();
    }

    // FILTER SEARCH
    final keyword = searchController.text.toLowerCase().trim();

    if (keyword.isNotEmpty) {
      filtered = filtered.where((p) {
        final namaAlat = (p.namaAlat ?? '').toLowerCase().trim();

        final tanggalPinjam = p.tanggalPinjam != null
            ? DateFormat('dd MMM yyyy')
                .format(p.tanggalPinjam!)
                .toLowerCase()
            : '';

        final tanggalKembali = DateFormat('dd MMM yyyy')
            .format(p.tanggalKembali)
            .toLowerCase();

        return namaAlat.contains(keyword) ||
            tanggalPinjam.contains(keyword) ||
            tanggalKembali.contains(keyword);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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

              // SEARCH
              TextField(
                controller: searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari Aktivitas',
                  suffixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 20),

              // ================= FILTER CHIP =================
            SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      FilterChipWidget(
        label: 'semua',
        selectedFilter: selectedFilter,
        onSelected: () =>
            setState(() => selectedFilter = 'semua'),
      ),

      const SizedBox(width: 8),

      FilterChipWidget(
        label: 'menunggu persetujuan',
        selectedFilter: selectedFilter,
        onSelected: () =>
            setState(() => selectedFilter = 'menunggu persetujuan'),
      ),

      const SizedBox(width: 8),

      FilterChipWidget(
        label: 'disetujui',
        selectedFilter: selectedFilter,
        onSelected: (
          
        ) =>
            setState(() => selectedFilter = 'disetujui'),
      ),

      const SizedBox(width: 8),

      FilterChipWidget(
        label: 'selesai',
        selectedFilter: selectedFilter,
        onSelected: () =>
            setState(() => selectedFilter = 'selesai'),
      ),
    ],
  ),
),

              const SizedBox(height: 24),

              // ================= LIST =================
              Expanded(
                child: Obx(() {
                  if (peminjamanController.isLoading.value) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final filtered = getFilteredPeminjaman();

                  if (filtered.isEmpty) {
                    return const Center(
                        child: Text('Tidak ada aktivitas'));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final p = filtered[index];
                      final dateFormat = DateFormat('dd MMM');

                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 12.0),
                        child: ActivityCardWidget(
                          name: p.namaAlat ?? 'Alat tidak diketahui',
                          item:
                              'Jumlah: ${p.jumlahAlat} | Petugas: ${p.namaPetugas ?? 'Belum disetujui'}',
                          date:
                              '${dateFormat.format(p.tanggalPinjam!)} - ${dateFormat.format(p.tanggalKembali)}',
                          status: p.status ?? 'unknown',
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
