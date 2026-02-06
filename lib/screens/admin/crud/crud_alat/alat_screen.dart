// screens/admin/crud/crud_alat/alat_screen.dart

import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlatScreen extends StatelessWidget {
  AlatScreen({super.key});

  final AlatController alatController = Get.put(AlatController());

  @override
  Widget build(BuildContext context) {
    // Memanggil loadAlat() saat screen pertama kali dibuka
    alatController.loadAlat();
    const Color primaryBlue = Color(0xFF0D47A1);

    return Scaffold(
      // AppBar dihapus dari sini karena header baru akan menjadi bagian dari body
      // untuk fleksibilitas yang lebih baik, sesuai desain.
      backgroundColor: const Color(0xFFFDFDFD),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        onPressed: () {
          // TODO: Implementasi navigasi ke halaman tambah alat
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header berisi Judul dan Search Bar
              _buildHeader(),
              const SizedBox(height: 20),
              // Filter Kategori
              _buildCategoryFilters(),
              const SizedBox(height: 24),
              // Grid Daftar Alat
              Expanded(
                child: Obx(() {
                  if (alatController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (alatController.alatList.isEmpty) {
                    return const Center(child: Text("Belum ada alat yang ditambahkan."));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 80), // Padding untuk FAB
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.7, // Sesuaikan rasio agar kartu terlihat bagus
                    ),
                    itemCount: alatController.alatList.length,
                    itemBuilder: (context, index) {
                      final alat = alatController.alatList[index];
                      return _AlatItemCard(
                        // Ganti dengan data asli dari controller Anda
                        imageUrl: 'https://via.placeholder.com/150/0D47A1/FFFFFF?text=Alat', // Ganti dengan alat.imageUrl jika ada
                        namaAlat: alat.namaAlat,
                        kategori: 'Elektronik', // Ganti dengan alat.kategori
                        stok: 15, // Ganti dengan alat.stok
                        onEdit: () {
                          // TODO: Logika untuk edit
                        },
                        onHapus: () {
                          alatController.deleteAlat(alat.alatId);
                        },
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

  // Widget untuk Header (Judul + Search)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Alat',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(
          width: Get.width * 0.45, // Lebar search bar sekitar 45% dari layar
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari alat...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
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

  // Widget untuk filter kategori
  Widget _buildCategoryFilters() {
    // State sementara untuk kategori yang aktif
    final RxString selectedCategory = 'Semua'.obs;

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: ['Semua', 'Elektronik', 'Olahraga', 'Kesenian'].map((kategori) {
          return Obx(() => _CategoryChip(
            label: kategori,
            isSelected: selectedCategory.value == kategori,
            onTap: () {
              selectedCategory.value = kategori;
              // TODO: Implementasi filter alat berdasarkan kategori di controller
            },
          ));
        }).toList(),
      ),
    );
  }
}

// Widget untuk Chip Kategori
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}


// Widget untuk Kartu Item Alat
class _AlatItemCard extends StatelessWidget {
  final String imageUrl;
  final String namaAlat;
  final String kategori;
  final int stok;
  final VoidCallback onEdit;
  final VoidCallback onHapus;

  const _AlatItemCard({
    required this.imageUrl,
    required this.namaAlat,
    required this.kategori,
    required this.stok,
    required this.onEdit,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 40),
                ),
              ),
            ),
          ),
          // Detail Informasi
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaAlat,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                       Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 16),
                       SizedBox(width: 4),
                       Text('Stok: $stok', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const Spacer(), // Mendorong tombol ke bawah
                  // Tombol Aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0D47A1),
                            side: const BorderSide(color: Color(0xFF0D47A1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onHapus,
                          icon: const Icon(Icons.delete, size: 16, color: Colors.white),
                          label: const Text('Hapus', style: TextStyle(color: Colors.white)),
                           style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
