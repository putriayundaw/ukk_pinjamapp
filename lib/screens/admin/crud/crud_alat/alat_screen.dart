import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/create_alat.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/models/alat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlatScreen extends StatelessWidget {
  AlatScreen({super.key});

  final AlatController alatC = Get.put(AlatController());

  final List<Map<String, dynamic>> kategoriList = [
    {'id': 0, 'nama': 'Semua'},
    {'id': 1, 'nama': 'Elektronik'},
  ];

  final RxInt selectedKategori = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: () {
          Get.to(() => const CreateAlat());
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchField(),
            const SizedBox(height: 12),
            const SizedBox(height: 16),
            Expanded(child: _alatGrid()),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      onChanged: (value) {
        final keyword = value.toLowerCase();
        alatC.filteredAlatList.assignAll(
          alatC.alatList.where(
            (e) => e.namaAlat.toLowerCase().contains(keyword),
          ),
        );
      },
      decoration: InputDecoration(
        hintText: 'Cari alat',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _alatGrid() {
    return Obx(() {
      if (alatC.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (alatC.filteredAlatList.isEmpty) {
        return const Center(child: Text('Data alat kosong'));
      }

      return GridView.builder(
        itemCount: alatC.filteredAlatList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final alat = alatC.filteredAlatList[index];
          return _alatCard(alat);
        },
      );
    });
  }

  Widget _alatCard(AlatModel alat) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              color: Colors.grey.shade200,
            ),
            child: alat.imageUrl == null
                ? const Icon(Icons.inventory_2, size: 50, color: Colors.grey)
                : ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      alat.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alat.namaAlat,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stok: ${alat.stok}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF0D47A1)),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        alatC.deleteAlat(alat.alatId!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
