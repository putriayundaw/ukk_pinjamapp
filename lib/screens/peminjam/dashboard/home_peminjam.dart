import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/widgets/tools.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pinjam_ukk/controller/kategori_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/widgets/kategori_chips.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/create_alat.dart';

class HomePeminjam extends StatefulWidget {
  const HomePeminjam({super.key});

  @override
  State<HomePeminjam> createState() => _HomePeminjamState();
}

class _HomePeminjamState extends State<HomePeminjam> {
  final KategoriController kategoriC = Get.put(KategoriController());
  final AlatController alatC = Get.put(AlatController());

  final RxInt selectedKategoriId = 0.obs;

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
      floatingActionButton: Obx(() {
        final jumlahDipilih = alatC.selectedAlatList.length;

        if (jumlahDipilih == 0) return const SizedBox(); // sembunyikan jika 0

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 50,
              
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        '${alatC.selectedAlatList.length} Items',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi tombol, misal ke halaman CreateAlat
                      Get.to(() => const CreateAlat());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.Blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Tambah',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      body: SingleChildScrollView(
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
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: const [
        CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=58'),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text('admin@gmail.com',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
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
            imageUrl: (alat.imageUrl == null || alat.imageUrl!.isEmpty)
                ? 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_600,h_600/global/375864/02/sv01/fnd/IND/fmt/png/Scuderia-Ferrari-Speedcat-Driving-Shoes'
                : alat.imageUrl!,
            title: alat.namaAlat,
            onAdd: () {
              if (!alatC.selectedAlatList.contains(alat)) {
                alatC.selectedAlatList.add(alat);
              }
            },
          );
        },
      );
    });
  }
}
