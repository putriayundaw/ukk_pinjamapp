import 'package:aplikasi_pinjam_ukk/controller/kategori_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/create_kategori.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/models/kategori_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KategoriScreen extends StatelessWidget {
  KategoriScreen({super.key});

  final KategoriController kategoriC = Get.find<KategoriController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // SEARCH BAR
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari kategori...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                // Implementasi search jika diperlukan
              },
            ),
            const SizedBox(height: 16),
            // LIST KATEGORI
            Expanded(
              child: Obx(() {
                if (kategoriC.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (kategoriC.kategoriList.isEmpty) {
                  return const Center(child: Text('Tidak ada kategori'));
                }

                return RefreshIndicator(
                  onRefresh: () async => await kategoriC.fetchKategori(),
                  child: ListView.builder(
                    itemCount: kategoriC.kategoriList.length,
                    itemBuilder: (context, index) {
                      final kategori = kategoriC.kategoriList[index];
                      return _kategoriCard(kategori);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Get.to(() => const CreateKategori()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _kategoriCard(Kategori kategori) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kategori.namaKategori,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${kategori.kategoriId}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // Implementasi edit kategori jika diperlukan
                  Get.snackbar('Info', 'Fitur edit kategori belum diimplementasi');
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(kategori),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Kategori kategori) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus kategori "${kategori.namaKategori}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              // Implementasi delete kategori jika diperlukan
              Get.snackbar('Info', 'Fitur delete kategori belum diimplementasi');
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
