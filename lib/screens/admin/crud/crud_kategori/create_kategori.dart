import 'package:aplikasi_pinjam_ukk/controller/kategori_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateKategori extends StatelessWidget {
  const CreateKategori({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    final KategoriController kategoriC = Get.find<KategoriController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kategori', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Kategori',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama kategori',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (namaController.text.trim().isEmpty) {
                    Get.snackbar('Error', 'Nama kategori tidak boleh kosong');
                    return;
                  }

                  try {
                    await kategoriC.createKategori(namaController.text.trim());
                    Get.back();
                    Get.snackbar('Sukses', 'Kategori berhasil ditambahkan');
                  } catch (e) {
                    Get.snackbar('Error', 'Gagal menambahkan kategori: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
