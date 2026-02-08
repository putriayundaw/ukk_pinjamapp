import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/models/alat_models.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // ================= GET =================
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
  Future<void> createAlat(AlatModel alat) async {
    try {
      await supabase.from('alat').insert(alat.toJson());
      fetchAlat();
      Get.back();
      Get.snackbar('Sukses', 'Alat berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan alat');
    }
  }

  // ================= UPDATE =================
  Future<void> updateAlat(AlatModel alat) async {
    try {
      await supabase
          .from('alat')
          .update(alat.toJson())
          .eq('alat_id', alat.alatId!); // 👈 FIX DI SINI

      fetchAlat();
      Get.back();
      Get.snackbar('Sukses', 'Alat berhasil diperbarui');
    } catch (e) {
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
      Get.snackbar('Error', 'Gagal menghapus alat');
    }
  }
}