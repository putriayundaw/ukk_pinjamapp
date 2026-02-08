import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/kategori_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/create_alat.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/models/alat_models.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/update_alat.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/models/kategori_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlatScreen extends StatelessWidget {
  AlatScreen({super.key});

  // Menggunakan Get.find() sesuai kode Anda, pastikan controller sudah di-put di tempat lain
  final AlatController alatC = Get.find<AlatController>();
  final KategoriController kategoriC = Get.find<KategoriController>();

  // State untuk UI, dipisahkan dari logika controller
  final RxInt selectedKategoriId = 0.obs;
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        onPressed: () => Get.to(() => const CreateAlat()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header dan Search Bar yang baru
              _buildHeader(),
              const SizedBox(height: 20),
              // Filter Kategori dengan UI baru
              _buildCategoryFilters(),
              const SizedBox(height: 24),
              // Grid Alat dengan kartu baru
              Expanded(child: _alatGrid()),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET HEADER BARU (JUDUL + SEARCH)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Alat', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        SizedBox(
          width: Get.width * 0.45,
          child: TextField(
            
            onChanged: (value) => searchQuery.value = value,
            decoration: InputDecoration(
              hintText: 'Cari alat...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // WIDGET FILTER KATEGORI BARU
  Widget _buildCategoryFilters() {
    return Obx(() {
      if (kategoriC.isLoading.value) return const SizedBox(height: 40);

      // Membuat daftar gabungan: "Semua" + daftar dari controller
      final List<Map<String, dynamic>> displayList = [
        {'id': 0, 'nama': 'Semua'},
        ...kategoriC.kategoriList.map((k) => {'id': k.kategoriId, 'nama': k.namaKategori}),
      ];

      return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            final kategori = displayList[index];
            return Obx(() => _CategoryChip(
              key: ValueKey('category_${kategori['id']}'),
              label: kategori['nama'],
              isSelected: selectedKategoriId.value == kategori['id'],
              onTap: () => selectedKategoriId.value = kategori['id'],
            ));
          },
        ),
      );
    });
  }

  // WIDGET GRID ALAT DENGAN KARTU BARU
  Widget _alatGrid() {
    return Obx(() {
      if (alatC.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      // Menggunakan logika filter gabungan Anda
      final filteredList = alatC.alatList.where((alat) {
        final isCategoryMatch = selectedKategoriId.value == 0 || alat.kategoriId == selectedKategoriId.value;
        final isSearchMatch = (alat.namaAlat?.toLowerCase() ?? '').contains(searchQuery.value.toLowerCase());
        return isCategoryMatch && isSearchMatch;
      }).toList();

      if (filteredList.isEmpty) {
        return const Center(child: Text('Alat tidak ditemukan.'));
      }

      return RefreshIndicator(
        onRefresh: () async => await alatC.fetchAlat(),
        child: GridView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: filteredList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.68, // Rasio kartu yang tinggi dan ramping
          ),
          itemBuilder: (context, index) {
            final alat = filteredList[index];
            return _alatCard(alat, key: ValueKey(alat.alatId ?? index)); // Memanggil widget kartu baru
          },
        ),
      );
    });
  }

  // WIDGET KARTU ALAT - VERSI FINAL 100% SESUAI GAMBAR
  Widget _alatCard(AlatModel alat, {Key? key}) {
    // Mencari nama kategori dari KategoriController
    final kategoriNama = kategoriC.kategoriList.firstWhere(
      (k) => k.kategoriId == alat.kategoriId,
      orElse: () => Kategori(kategoriId: 0, namaKategori: 'Lainnya'),
    ).namaKategori;

    return Container(
      key: key,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                alat.imageUrl ?? 'https://via.placeholder.com/150',
                width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Center(child: Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 40)),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alat.namaAlat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      _buildInfoRow(Icons.category_outlined, kategoriNama),
                      const SizedBox(height: 2),
                      _buildInfoRow(Icons.inventory_2_outlined, 'Stok: ${alat.stok}'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.edit, label: 'Edit', isElevated: false,
                        onPressed: () => Get.to(() => UpdateAlat(alat: alat)),
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        icon: Icons.delete, label: 'Hapus', isElevated: true,
                        onPressed: () => _showDeleteConfirmation(alat), // Menggunakan dialog Anda
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // KONFIRMASI HAPUS - Dipertahankan dari kode Anda
  void _showDeleteConfirmation(AlatModel alat) {
    Get.dialog(AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: Text('Apakah Anda yakin ingin menghapus "${alat.namaAlat}"?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            Get.back();
            await alatC.deleteAlat(alat.alatId!);
          },
          child: const Text('Hapus', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  // HELPER WIDGETS untuk tampilan yang bersih
  Widget _buildInfoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, color: Colors.grey, size: 16),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    ],
  );

  Widget _buildActionButton({required IconData icon, required String label, required bool isElevated, required VoidCallback onPressed}) {
    const Color primaryBlue = Color(0xFF0D47A1);
    return Expanded(
      child: isElevated
          ? ElevatedButton.icon(
              onPressed: onPressed, icon: Icon(icon, size: 16, color: Colors.white),
              label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed, icon: Icon(icon, size: 16, color: primaryBlue),
              label: Text(label, style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryBlue, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
    );
  }
}

// WIDGET UNTUK CHIP KATEGORI
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600))),
      ),
    );
  }
}
