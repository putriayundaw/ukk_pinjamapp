import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/peminjaman/models/peminjaman_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var peminjamanList = <PeminjamanModel>[].obs;

  @override
  void onInit() {
    fetchPeminjaman();
    super.onInit();
  }

  Future<void> fetchPeminjaman() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('peminjaman')
          .select()
          .order('peminjaman_id', ascending: false);

      peminjamanList.value =
          (response as List).map((e) => PeminjamanModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// HAPUS + LOG AKTIVITAS
  Future<void> deletePeminjaman(int id) async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;

      // hapus detail dulu (biar tidak kena foreign key)
      await supabase
          .from('detail_peminjaman')
          .delete()
          .eq('peminjaman_id', id);

      // hapus peminjaman
      await supabase
          .from('peminjaman')
          .delete()
          .eq('peminjaman_id', id);

      // log aktivitas
      await supabase.from('log_aktivitas').insert({
        'user_id': user?.id,
        'aktivitas': 'Menghapus data peminjaman ID $id',
        'created_at': DateTime.now().toIso8601String(),
      });

      fetchPeminjaman();
      Get.snackbar('Sukses', 'Data berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
