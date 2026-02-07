import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/models/kategori_models.dart';
import 'package:get/get.dart';

class KategoriController extends GetxController {
  // list kategori
  final kategoriList = <KategoriModel>[].obs;

  // kategori terpilih (untuk filter)
  final selectedKategoriId = 0.obs;

  // loading
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKategori();
  }

  // 🔹 simulasi fetch dari API
  Future<void> fetchKategori() async {
    try {
      isLoading.value = true;

      // 🔥 ganti ini nanti dengan API kamu
      final response = [
        {
          "kategori_id": 1,
          "nama_kategori": "elektronik",
        }
      ];

      kategoriList.value =
          response.map((e) => KategoriModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 pilih kategori
  void selectKategori(int kategoriId) {
    selectedKategoriId.value = kategoriId;
  }
}
