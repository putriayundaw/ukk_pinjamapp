import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/pengembalian/models/pengembalian_models.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PengembalianController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var pengembalianList = <Pengembalian>[].obs;

  /// Ambil semua pengembalian
  Future<void> fetchPengembalian() async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from('pengembalian')
          .select()
          .order('created_at', ascending: false);

      // Supabase v2+ langsung return List
      if (response != null && response is List) {
        pengembalianList.value =
            response.map((e) => Pengembalian.fromJson(e)).toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Tambah pengembalian baru
  Future<void> addPengembalian(Pengembalian pengembalian) async {
    try {
      isLoading.value = true;
      final response = await supabase.from('pengembalian').insert([
        {
          'peminjaman_id': pengembalian.peminjamanId,
          'tanggal_kembali_actual':
              pengembalian.tanggalKembaliActual?.toIso8601String(),
          'denda': pengembalian.denda,
          'status': pengembalian.status,
          'petugas_id': pengembalian.petugasId,
        }
      ]);

      if (response != null && response is List) {
        final inserted = response.first;
        pengembalianList.add(Pengembalian.fromJson(inserted));
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Update pengembalian
  Future<void> updatePengembalian(int id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response =
          await supabase.from('pengembalian').update(data).eq('pengembalian_id', id);

      if (response != null && response is List) {
        final index =
            pengembalianList.indexWhere((p) => p.pengembalianId == id);
        if (index != -1) {
          pengembalianList[index] = Pengembalian.fromJson(response.first);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Hapus pengembalian
  Future<void> deletePengembalian(int id) async {
    try {
      isLoading.value = true;
      await supabase.from('pengembalian').delete().eq('pengembalian_id', id);
      pengembalianList.removeWhere((p) => p.pengembalianId == id);
    } finally {
      isLoading.value = false;
    }
  }
}
