import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/kategori_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/models/alat_models.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/models/kategori_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAlat extends StatefulWidget {
  const CreateAlat({super.key});

  @override
  State<CreateAlat> createState() => _CreateAlatState();
}

class _CreateAlatState extends State<CreateAlat> {
  final AlatController alatC = Get.find<AlatController>();
  final KategoriController kategoriC = Get.find<KategoriController>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  int? selectedKategoriId;

  @override
  void dispose() {
    namaController.dispose();
    stokController.dispose();
    super.dispose();
  }

  void _createAlat() {
    if (namaController.text.isEmpty || stokController.text.isEmpty || selectedKategoriId == null) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return;
    }

    final newAlat = AlatModel(
      namaAlat: namaController.text,
      stok: int.parse(stokController.text),
      kategoriId: selectedKategoriId!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    alatC.createAlat(newAlat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Alat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// IMAGE PLACEHOLDER
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Add Image',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// PRODUCT NAME
            TextField(
              controller: namaController,
              decoration: _inputDecoration(
                'Nama Alat',
                Icons.shopping_cart,
              ),
            ),

            const SizedBox(height: 20),

            /// STOCK
            TextField(
              controller: stokController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                'Jumlah',
                Icons.inventory_2,
              ),
            ),

            const SizedBox(height: 20),

            /// CATEGORY DROPDOWN
            Obx(() {
              if (kategoriC.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return DropdownButtonFormField<int>(
                value: selectedKategoriId,
                decoration: _inputDecoration(
                  'Pilih Kategori',
                  Icons.category,
                ),
                items: kategoriC.kategoriList.map((Kategori kategori) {
                  return DropdownMenuItem<int>(
                    value: kategori.kategoriId,
                    child: Text(kategori.namaKategori),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKategoriId = value;
                  });
                },
              );
            }),

            const SizedBox(height: 40),

            /// SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _createAlat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tambahkan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
