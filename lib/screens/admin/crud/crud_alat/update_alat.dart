import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/kategori_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/models/alat_models.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/models/kategori_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateAlat extends StatefulWidget {
  final AlatModel alat;

  const UpdateAlat({super.key, required this.alat});

  @override
  State<UpdateAlat> createState() => _UpdateAlatState();
}

class _UpdateAlatState extends State<UpdateAlat> {
  final AlatController alatC = Get.find<AlatController>();
  final KategoriController kategoriC = Get.find<KategoriController>();

  late TextEditingController namaController;
  late TextEditingController stokController;
  late int selectedKategoriId;

  XFile? _selectedImage;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.alat.namaAlat);
    stokController = TextEditingController(text: widget.alat.stok.toString());
    selectedKategoriId = widget.alat.kategoriId;
  }

  @override
  void dispose() {
    namaController.dispose();
    stokController.dispose();
    super.dispose();
  }

  // ===== PICK IMAGE =====
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = image;
      if (kIsWeb) {
        _webImage = await image.readAsBytes();
      }
      setState(() {});
    }
  }

  void _updateAlat() async {
    if (namaController.text.isEmpty || stokController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return;
    }

    Uint8List? bytes;
    if (_selectedImage != null) {
      if (kIsWeb) {
        bytes = _webImage;
      } else {
        bytes = await File(_selectedImage!.path).readAsBytes();
      }
    }

    final updatedAlat = AlatModel(
      alatId: widget.alat.alatId,
      namaAlat: namaController.text,
      stok: int.parse(stokController.text),
      kategoriId: selectedKategoriId,
      status: widget.alat.status,
      createdAt: widget.alat.createdAt,
      updatedAt: DateTime.now(),
      imageUrl: widget.alat.imageUrl,
    );

    await alatC.updateAlat(updatedAlat, imageBytes: bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Alat', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // IMAGE PICKER
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade100,
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: kIsWeb
                              ? MemoryImage(_webImage!)
                              : FileImage(File(_selectedImage!.path)) as ImageProvider,
                          fit: BoxFit.cover,
                        )
                      : (widget.alat.imageUrl != null
                          ? DecorationImage(
                              image: widget.alat.imageUrl!.startsWith('data:image')
                                  ? MemoryImage(base64Decode(widget.alat.imageUrl!.split(',')[1]))
                                  : NetworkImage(widget.alat.imageUrl!) as ImageProvider,
                              fit: BoxFit.cover,
                            )
                          : null),
                ),
                child: _selectedImage == null && widget.alat.imageUrl == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Add Image', style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 40),
            // NAMA ALAT
            TextField(
              controller: namaController,
              decoration: _inputDecoration('Nama Alat', Icons.shopping_cart),
            ),
            const SizedBox(height: 20),
            // STOK
            TextField(
              controller: stokController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Jumlah', Icons.inventory_2),
            ),
            const SizedBox(height: 20),
            // DROPDOWN KATEGORI
            Obx(() {
              if (kategoriC.isLoading.value) return const CircularProgressIndicator();
              return DropdownButtonFormField<int>(
                value: selectedKategoriId,
                decoration: _inputDecoration('Pilih Kategori', Icons.category),
                items: kategoriC.kategoriList.map((kategori) {
                  return DropdownMenuItem<int>(
                    value: kategori.kategoriId,
                    child: Text(kategori.namaKategori),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => selectedKategoriId = value);
                },
              );
            }),
            const SizedBox(height: 40),
            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateAlat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Perbarui', style: TextStyle(fontWeight: FontWeight.bold)),
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
