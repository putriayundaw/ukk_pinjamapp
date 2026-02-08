// pastikan kategori_controller.dart ada dan berfungsi
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/models/kategori_models.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriController extends GetxController {
  final supabase = Supabase.instance.client;
  final kategoriList = <Kategori>[].obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchKategori();
  }
  
  Future<void> fetchKategori() async {
    try {
      isLoading.value = true;
      print('🔄 Memulai fetchKategori...');
      final response = await supabase
          .from('kategori')
          .select()
          .order('nama_kategori', ascending: true);

      print('📡 Response kategori dari Supabase: $response');

      if (response != null) {
        kategoriList.value = (response as List)
            .map((e) => Kategori.fromJson(e))
            .toList();
        print('✅ Data kategori berhasil diambil: ${kategoriList.length} item');
        if (kategoriList.isNotEmpty) {
          print('📋 Contoh kategori pertama: ${kategoriList.first.namaKategori}');
        } else {
          print('⚠️ Tidak ada data kategori di database');
        }
      } else {
        print('⚠️ Response kategori null');
      }
    } catch (e) {
      print('❌ Error fetchKategori: $e');
    } finally {
      isLoading.value = false;
    }
  }
}