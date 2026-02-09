import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/admin/crud/crud_alat/models/alat_models.dart';

class AlatController extends GetxController {
  final supabase = Supabase.instance.client;

  final alatList = <AlatModel>[].obs;
  final filteredAlatList = <AlatModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAlat();
  }

  // ================= FETCH =================
  Future<void> fetchAlat() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('alat')
          .select()
          .order('created_at', ascending: false);

      final data = response as List;

      alatList.value = data.map((e) => AlatModel.fromJson(e)).toList();
      filteredAlatList.assignAll(alatList);
    } catch (e) {
      print('Error fetchAlat: $e');
      Get.snackbar('Error', 'Gagal mengambil data alat');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FILTER =================
  void filterByKategori(int kategoriId) {
    if (kategoriId == 0) {
      filteredAlatList.assignAll(alatList);
    } else {
      filteredAlatList.assignAll(
        alatList.where((e) => e.kategoriId == kategoriId).toList(),
      );
    }
  }

  // ================= CREATE =================
Future<bool> createAlat(AlatModel alat, {Uint8List? imageBytes}) async {
  try {
    String imageUrl = '';

    if (imageBytes != null) {
      // Konversi ke base64
      imageUrl = 'data:image/png;base64,${base64Encode(imageBytes)}';
    }

    // Simpan ke tabel langsung
    await supabase.from('alat').insert({
      'nama_alat': alat.namaAlat,
      'stok': alat.stok,
      'kategori_id': alat.kategoriId,
      'image_url': imageUrl,
      'created_at': alat.createdAt.toIso8601String(),
      'updated_at': alat.updatedAt.toIso8601String(),
    });

    fetchAlat();
    Get.back();
    Get.snackbar('Sukses', 'Alat berhasil ditambahkan');
    return true;
  } catch (e) {
    print('Error createAlat: $e');
    Get.snackbar('Error', 'Gagal menambahkan alat');
    return false;
  }
}


 Future<void> updateAlat(AlatModel alat, {Uint8List? imageBytes}) async {
  try {
    String? imageUrl = alat.imageUrl;

    if (imageBytes != null) {
      // konversi ke base64
      imageUrl = 'data:image/png;base64,${base64Encode(imageBytes)}';
    }

    // update ke tabel
    await supabase.from('alat').update({
      'nama_alat': alat.namaAlat,
      'stok': alat.stok,
      'kategori_id': alat.kategoriId,
      'status': alat.status,
      'image_url': imageUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('alat_id', alat.alatId!);

    fetchAlat();
    Get.back();
    Get.snackbar('Sukses', 'Alat berhasil diperbarui');
  } catch (e) {
    print('Error updateAlat: $e');
    Get.snackbar('Error', 'Gagal update alat');
  }
}


  // ================= DELETE =================
  Future<void> deleteAlat(int alatId) async {
    try {
      await supabase.from('alat').delete().eq('alat_id', alatId);
      fetchAlat();
      Get.snackbar('Sukses', 'Alat berhasil dihapus');
    } catch (e) {
      print('Error deleteAlat: $e');
      Get.snackbar('Error', 'Gagal menghapus alat');
    }
  }
}
