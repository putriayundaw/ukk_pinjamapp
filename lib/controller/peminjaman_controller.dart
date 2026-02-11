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

  /// ===============================
  /// CEK APAKAH USER MASIH MEMILIKI PEMINJAMAN AKTIF
  /// ===============================
  Future<bool> hasActivePeminjaman(String userId) async {
  try {
    final response = await supabase
        .from('peminjaman')
        .select()
        .eq('user_id', userId)
        .filter('status', 'in', ['menunggu persetujuan', 'disetujui']);

    return (response as List).isNotEmpty;
  } catch (e) {
    Get.snackbar('Error', 'Gagal cek peminjaman aktif: $e');
    return true; // Default true supaya aman
  }
}


  /// ===============================
  /// AMBIL SEMUA PEMINJAMAN (ADMIN)
  /// ===============================
  Future<void> fetchPeminjaman() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('peminjaman')
          .select('''
            *,
            alat!fk_alat(nama_alat),
            peminjam:users!peminjaman_user_id_fkey(email, nama),
            petugas:users!fk_petugas_peminjaman(nama)
          ''')
          .order('peminjaman_id', ascending: false);

      peminjamanList.value =
          (response as List).map((e) => PeminjamanModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ===============================
  /// AMBIL PEMINJAMAN USER LOGIN
  /// ===============================
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
          .select('''
            *,
            alat!fk_alat(nama_alat),
            peminjam:users!peminjaman_user_id_fkey(email),
            petugas:users!fk_petugas_peminjaman(nama)
          ''')
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

  /// ===============================
  /// AMBIL PEMINJAMAN MENUNGGU
  /// ===============================
  Future<void> fetchPendingPeminjaman() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('peminjaman')
          .select('''
            *,
            alat!fk_alat(nama_alat),
            peminjam:users!peminjaman_user_id_fkey(email, nama),
            petugas:users!fk_petugas_peminjaman(nama)
          ''')
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

  /// ===============================
  /// CREATE PEMINJAMAN
  /// ===============================
  Future<bool> createPeminjaman({
    required String userId,
    required DateTime tanggalPinjam,
    required DateTime tanggalKembali,
    required Map<int, int> selectedAlat,
  }) async {
    try {
      isLoading.value = true;

      // ===============================
      // CEK PEMINJAMAN AKTIF
      // ===============================
      bool hasActive = await hasActivePeminjaman(userId);
      if (hasActive) {
        Get.snackbar(
          'Gagal',
          'Anda masih memiliki peminjaman yang belum dikembalikan!',
        );
        return false;
      }

      // ===============================
      // PROSES PEMBUATAN PEMINJAMAN
      // ===============================
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

      await supabase.from('log_aktivitas').insert({
        'id_user': userId,
        'aktivitas': 'Membuat ${selectedAlat.length} peminjaman alat',
        'waktu': DateTime.now().toIso8601String(),
      });

      fetchUserPeminjaman();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat peminjaman: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ===============================
  /// SETUJUI PEMINJAMAN
  /// ===============================
  Future<void> approvePeminjaman(int id) async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;

      await supabase.from('peminjaman').update({
        'status': 'disetujui',
        'petugas_id': user?.id,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('peminjaman_id', id);

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

  /// ===============================
  /// TOLAK PEMINJAMAN
  /// ===============================
  Future<void> rejectPeminjaman(int id) async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;

      await supabase.from('peminjaman').update({
        'status': 'ditolak',
        'petugas_id': user?.id,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('peminjaman_id', id);

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

  /// ===============================
  /// HAPUS PEMINJAMAN
  /// ===============================
  Future<void> deletePeminjaman(int id) async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;

      await supabase
          .from('detail_peminjaman')
          .delete()
          .eq('peminjaman_id', id);

      await supabase
          .from('peminjaman')
          .delete()
          .eq('peminjaman_id', id);

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
}
