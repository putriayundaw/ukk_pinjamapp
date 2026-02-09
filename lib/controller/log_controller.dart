import 'package:aplikasi_pinjam_ukk/screens/admin/log_aktivitas/models.dart/log_models.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogAktivitasController extends GetxController {
  final supabase = Supabase.instance.client;

  final logList = <LogAktivitas>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
  }

  // ================= FETCH =================
  Future<void> fetchLogs({String? userId, String? petugasId}) async {
    try {
      isLoading.value = true;

      // Ambil semua data
      final response = await supabase.from('log_aktivitas').select();

      // Convert ke List<Map>
      final data = response as List;

      // Filter manual jika ada idUser atau petugasId
      List<LogAktivitas> logs = data.map((e) => LogAktivitas.fromJson(e)).toList();
      if (userId != null) logs = logs.where((log) => log.idUser == userId).toList();
      if (petugasId != null) logs = logs.where((log) => log.petugasId == petugasId).toList();

      // Urutkan berdasarkan waktu descending
      logs.sort((a, b) => b.waktu!.compareTo(a.waktu!));

      logList.value = logs;
    } catch (e) {
      print('Error fetchLogs: $e');
      Get.snackbar('Error', 'Gagal mengambil data log aktivitas');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= CREATE =================
  Future<bool> addLog({
    String? idUser,
    required String aktivitas,
    String? petugasId,
  }) async {
    try {
      await supabase.from('log_aktivitas').insert({
        'id_user': idUser,
        'aktivitas': aktivitas,
        'petugas_id': petugasId,
        'waktu': DateTime.now().toIso8601String(),
      });

      fetchLogs(); // refresh
      return true;
    } catch (e) {
      print('Error addLog: $e');
      Get.snackbar('Error', 'Gagal menambahkan log aktivitas');
      return false;
    }
  }

  // ================= DELETE =================
  Future<void> deleteLog(int idAktivitas) async {
    try {
      await supabase.from('log_aktivitas').delete().eq('id_aktivitas', idAktivitas);
      fetchLogs();
      Get.snackbar('Sukses', 'Log berhasil dihapus');
    } catch (e) {
      print('Error deleteLog: $e');
      Get.snackbar('Error', 'Gagal menghapus log');
    }
  }
}
