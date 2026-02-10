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
        'id_user': user?.id,
        'aktivitas': 'Menghapus data peminjaman ID $id',
        'waktu': DateTime.now().toIso8601String(),
      });

      fetchPeminjaman();
      Get.snackbar('Sukses', 'Data berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createPeminjaman({
    required String userId,
    required DateTime tanggalPinjam,
    required DateTime tanggalKembali,
    required Map<int, int> selectedAlat,
  }) async {
    try {
      isLoading.value = true;

      // Insert satu peminjaman untuk setiap alat yang dipilih
      List<Map<String, dynamic>> peminjamanData = [];
      selectedAlat.forEach((alatId, qty) {
        peminjamanData.add({
          'alat_id': alatId,
          'user_id': userId,
          'tanggal_pinjam': tanggalPinjam.toIso8601String(),
          'tanggal_kembali': tanggalKembali.toIso8601String(),
          'jumlah_alat': qty,
          'status': 'menunggu persetujuan',
          'petugas_id': null,
        });
      });

      await supabase.from('peminjaman').insert(peminjamanData);

      // Log aktivitas
      await supabase.from('log_aktivitas').insert({
        'id_user': userId,
        'aktivitas': 'Membuat ${selectedAlat.length} peminjaman alat',
        'waktu': DateTime.now().toIso8601String(),
      });

      fetchPeminjaman();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat peminjaman: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserPeminjaman() async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User tidak ditemukan');
        return;
      }

      final response = await supabase
          .from('peminjaman')
          .select('*, alat!fk_alat(nama_alat), users!fk_peminjaman_user_id_fkey(email), petugas!fk_peminjaman_petugas_id_fkey(nama)')
          .eq('user_id', user.id)
          .order('peminjaman_id', ascending: false);

      peminjamanList.value =
          (response as List).map((e) => PeminjamanModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPendingPeminjaman() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('peminjaman')
          .select('*, alat!fk_alat(nama_alat), users!fk_peminjaman_user_id_fkey(email, nama), petugas!fk_peminjaman_petugas_id_fkey(nama)')
          .eq('status', 'menunggu persetujuan')
          .order('peminjaman_id', ascending: false);

      peminjamanList.value =
          (response as List).map((e) => PeminjamanModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approvePeminjaman(int id) async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;

      await supabase
          .from('peminjaman')
          .update({
            'status': 'disetujui',
            'petugas_id': user?.id,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('peminjaman_id', id);

      // log aktivitas
      await supabase.from('log_aktivitas').insert({
        'id_user': user?.id,
        'aktivitas': 'Menyetujui peminjaman ID $id',
        'waktu': DateTime.now().toIso8601String(),
      });

      fetchPendingPeminjaman();
      Get.snackbar('Sukses', 'Peminjaman disetujui');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectPeminjaman(int id) async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;

      await supabase
          .from('peminjaman')
          .update({
            'status': 'ditolak',
            'petugas_id': user?.id,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('peminjaman_id', id);

      // log aktivitas
      await supabase.from('log_aktivitas').insert({
        'id_user': user?.id,
        'aktivitas': 'Menolak peminjaman ID $id',
        'waktu': DateTime.now().toIso8601String(),
      });

      fetchPendingPeminjaman();
      Get.snackbar('Sukses', 'Peminjaman ditolak');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllPeminjaman() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('peminjaman')
          .select('*, alat!fk_alat(nama_alat), users!fk_peminjaman_user_id_fkey(email, nama), petugas!fk_peminjaman_petugas_id_fkey(nama)')
          .order('peminjaman_id', ascending: false);

      peminjamanList.value =
          (response as List).map((e) => PeminjamanModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
