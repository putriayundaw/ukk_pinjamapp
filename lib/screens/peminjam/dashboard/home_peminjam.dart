import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/auth_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/kategori_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/widgets/kategori_chips.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/widgets/tools.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/proses/peminjaman.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomePeminjam extends StatefulWidget {
  const HomePeminjam({super.key});

  @override
  State<HomePeminjam> createState() => _HomePeminjamState();
}

class _HomePeminjamState extends State<HomePeminjam> {
  final KategoriController kategoriC = Get.put(KategoriController());
  final AlatController alatC = Get.put(AlatController());
  final AuthController authController = Get.find<AuthController>();

  final RxInt selectedKategoriId = 0.obs;

  @override
  void initState() {
    super.initState();

    // Filter alat saat kategori berubah
    ever<int>(selectedKategoriId, (kategoriId) {
      alatC.filterByKategori(kategoriId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          // FloatingActionButton bottom
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Obx(() {
              final jumlahDipilih = alatC.totalSelectedItems;
              if (jumlahDipilih == 0) return const SizedBox();

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
                                fontWeight: FontWeight.bold, fontSize: 16),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Proses',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue,
          child: Obx(() {
            final email = authController.emailUser.value;
            final initials =
                email.isNotEmpty ? email.split('@')[0][0].toUpperCase() : '';
            return Text(initials,
                style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20));
          }),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selamat Datang',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            Obx(() {
              final email = authController.emailUser.value;
              return Text(email,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16));
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
        alatC.searchAlat(query);
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
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.inventory_2_outlined, size: 72, color: Colors.grey),
              SizedBox(height: 12),
              Text('Tidak ada alat tersedia',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        );
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
            imageUrl: alat.imageUrl ?? '',
            title: alat.namaAlat,
          );
        },
      );
    });
  }
}
