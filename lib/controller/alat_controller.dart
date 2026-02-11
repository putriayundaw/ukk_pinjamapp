import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/admin/crud/crud_alat/models/alat_models.dart';

class AlatController extends GetxController {
  final supabase = Supabase.instance.client;

  final alatList = <AlatModel>[].obs; // Semua data alat
  final filteredAlatList = <AlatModel>[].obs; // Data setelah filter/search
  final isLoading = false.obs;

  var selectedAlatMap = <int, int>{}.obs; // key: alatId, value: quantity
  int? currentFilterKategoriId;

  @override
  void onInit() {
    super.onInit();
    _setupRealtimeStream();
    ever(
        alatList, (_) => _applyFilter()); // otomatis filter setiap data berubah
  }

  void _applyFilter() {
    if (currentFilterKategoriId == null || currentFilterKategoriId == 0) {
      filteredAlatList.assignAll(alatList);
    } else {
      filteredAlatList.assignAll(
        alatList.where((e) => e.kategoriId == currentFilterKategoriId).toList(),
      );
    }
  }

  void _setupRealtimeStream() {
    // Bind stream ke alatList
    alatList.bindStream(
      supabase
          .from('alat')
          .stream(primaryKey: ['alat_id'])
          .order('created_at', ascending: false)
          .map((data) => data.map((e) => AlatModel.fromJson(e)).toList()),
    );
  }

  // ================= SEARCH =================
  void searchAlat(String query) {
    final filtered = alatList.where((e) {
      final matchesQuery =
          e.namaAlat.toLowerCase().contains(query.toLowerCase());
      final matchesKategori = currentFilterKategoriId == null ||
          currentFilterKategoriId == 0 ||
          e.kategoriId == currentFilterKategoriId;
      return matchesQuery && matchesKategori;
    }).toList();

    filteredAlatList.assignAll(filtered);
  }

  // ================= FILTER =================
  void filterByKategori(int kategoriId) {
    currentFilterKategoriId = kategoriId;
    _applyFilter();
  }

  // ================= CREATE =================
  Future<bool> createAlat(AlatModel alat, {Uint8List? imageBytes}) async {
    try {
      String imageUrl = '';
      if (imageBytes != null) {
        imageUrl = 'data:image/png;base64,${base64Encode(imageBytes)}';
      }

      await supabase.from('alat').insert({
        'nama_alat': alat.namaAlat,
        'stok': alat.stok,
        'kategori_id': alat.kategoriId,
        'image_url': imageUrl,
        'status': alat.status,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      Get.back();
      Get.snackbar('Sukses', 'Alat berhasil ditambahkan');
      return true;
    } catch (e) {
      print('Error createAlat: $e');
      Get.snackbar('Error', 'Gagal menambahkan alat');
      return false;
    }
  }

  // ================= UPDATE =================
  Future<void> updateAlat(AlatModel alat, {Uint8List? imageBytes}) async {
    try {
      String? imageUrl = alat.imageUrl;
      if (imageBytes != null) {
        imageUrl = 'data:image/png;base64,${base64Encode(imageBytes)}';
      }

      await supabase.from('alat').update({
        'nama_alat': alat.namaAlat,
        'stok': alat.stok,
        'kategori_id': alat.kategoriId,
        'status': alat.status,
        'image_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('alat_id', alat.alatId!);

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
      Get.snackbar('Sukses', 'Alat berhasil dihapus');
    } catch (e) {
      print('Error deleteAlat: $e');
      Get.snackbar('Error', 'Gagal menghapus alat');
    }
  }

  // ================= UTILITY =================
  int get totalSelectedItems =>
      selectedAlatMap.values.fold(0, (sum, qty) => sum + qty);
}
