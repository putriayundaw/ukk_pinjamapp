import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/auth_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/kategori_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/transaksi/proses_transaksi.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/widgets/kategori_chips.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/widgets/tools.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomePeminjam extends StatefulWidget {
  HomePeminjam({super.key});

  @override
  State<HomePeminjam> createState() => _HomePeminjamState();
}

class _HomePeminjamState extends State<HomePeminjam> {
  final KategoriController kategoriC = Get.put(KategoriController());
  final AlatController alatC = Get.put(AlatController());

  final RxInt selectedKategoriId = 0.obs;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    // Filter alat setiap kali kategori berubah
    ever<int>(selectedKategoriId, (kategoriId) {
      alatC.filterByKategori(kategoriId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Konten utama kamu di sini (misalnya ListView, Column, dll)
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildCategoryRow(),
                const SizedBox(height: 20),
                _buildToolsGrid(),
              ],
            ),
          ),

          // FloatingActionButton manually positioned
          Positioned(
            bottom: 16,  // Jarak dari bawah layar
            left: 16,    // Jarak dari kiri layar
            right: 16,   // Jarak dari kanan layar
            child: Obx(() {
              final jumlahDipilih = alatC.totalSelectedItems;

              if (jumlahDipilih == 0) return const SizedBox(); // sembunyikan jika 0

              return Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            '${alatC.totalSelectedItems} Items',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          )),
                      ElevatedButton(
                        onPressed: () {
                      
                          Get.to(() => const ProsesTransaksi());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.Blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Proses',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        // Mengambil huruf pertama dari email untuk menjadi inisial
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue,  // Warna background avatar
          child: Obx(() {
            // Ambil email dari controller
            final email = authController.emailUser.value;

            // Ambil huruf pertama dari bagian nama email (sebelum @)
            final initials = email.isNotEmpty ? email.split('@')[0][0].toUpperCase() : ''; 

            return Text(
              initials, 
              style: TextStyle(
                color: Colors.white,  // Warna teks avatar
                fontWeight: FontWeight.bold,
                fontSize: 20,  // Ukuran font inisial
              ),
            );
          }),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Obx(() {
              final email = authController.emailUser.value;  // Mengambil email dari controller
              return Text(
                email,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search alat...',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      onChanged: (query) {
        final filtered = alatC.alatList.where((e) {
          final matchesQuery =
              e.namaAlat.toLowerCase().contains(query.toLowerCase());
          final matchesKategori =
              selectedKategoriId.value == 0 || e.kategoriId == selectedKategoriId.value;
          return matchesQuery && matchesKategori;
        }).toList();

        alatC.filteredAlatList.assignAll(filtered);
      },
    );
  }

  Widget _buildCategoryRow() {
    return Obx(() {
      if (kategoriC.isLoading.value) return const SizedBox(height: 40);
      if (kategoriC.kategoriList.isEmpty) {
        return const Text('⚠️ Tidak ada kategori',
            style: TextStyle(color: Colors.grey));
      }

      final displayList = [
        {'id': 0, 'nama': 'Semua'},
        ...kategoriC.kategoriList
            .map((k) => {'id': k.kategoriId, 'nama': k.namaKategori}),
      ];

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: displayList.map((kategori) {
            return CategoryChip(
              key: ValueKey('category_${kategori['id']}'),
              label: kategori['nama'] as String,
              isSelected: selectedKategoriId.value == kategori['id'],
              onTap: () => selectedKategoriId.value = kategori['id'] as int,
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildToolsGrid() {
    return Obx(() {
      if (alatC.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (alatC.filteredAlatList.isEmpty) {
        return const Text('⚠️ Tidak ada alat tersedia',
            style: TextStyle(color: Colors.grey));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: alatC.filteredAlatList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final alat = alatC.filteredAlatList[index];
          return ToolCard(
            alat: alat,
            alatC: alatC,
            imageUrl: alat.imageUrl!,
            title: alat.namaAlat,
          );
        },
      );
    });
  }
}
