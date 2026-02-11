import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/pengembalian/models/pengembalian_models.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PengembalianController extends GetxController {
  final supabase = Supabase.instance.client;

  var pengembalianList = <PengembalianModel>[].obs;
  var isLoading = false.obs;

  // ===================== GET DATA =====================

  Future<void> fetchPengembalian() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('pengembalian')
          .select()
          .order('created_at', ascending: false);

      pengembalianList.value = (response as List)
          .map((e) => PengembalianModel.fromJson(e))
          .toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===================== CREATE =====================

  Future<bool> createPengembalian({
    required int peminjamanId,
    required DateTime tanggalKembaliActual,
    double denda = 0,
  }) async {
    try {
      isLoading.value = true;

      await supabase.from('pengembalian').insert({
        'peminjaman_id': peminjamanId,
        'tanggal_kembali_actual':
            tanggalKembaliActual.toIso8601String(),
        'denda': denda,
        'status': 'menunggu verifikasi',
      });

      await fetchPengembalian();

      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===================== UPDATE STATUS =====================

  Future<bool> updateStatus({
    required int pengembalianId,
    required String status,
    String? petugasId,
  }) async {
    try {
      isLoading.value = true;

      await supabase.from('pengembalian').update({
        'status': status,
        'petugas_id': petugasId,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('pengembalian_id', pengembalianId);

      await fetchPengembalian();

      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===================== GET BY USER =====================

  Future<List<PengembalianModel>> getByPeminjaman(
      int peminjamanId) async {
    try {
      final response = await supabase
          .from('pengembalian')
          .select()
          .eq('peminjaman_id', peminjamanId);

      return (response as List)
          .map((e) => PengembalianModel.fromJson(e))
          .toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return [];
    }
  }

  // ===================== DELETE =====================

  Future<bool> deletePengembalian(int id) async {
    try {
      await supabase
          .from('pengembalian')
          .delete()
          .eq('pengembalian_id', id);

      await fetchPengembalian();

      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }
}
