import 'dart:convert';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/models/alat_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class AlatController extends GetxController {
  // Daftar alat yang akan ditampilkan
  var alatList = <Alat>[].obs;
  var isLoading = true.obs; // Flag untuk menampilkan indikator loading

  // Inisialisasi Supabase Client
  final SupabaseClient supabase = Supabase.instance.client;

  // Mengambil data alat dari Supabase
  Future<void> loadAlat() async {
     {
      isLoading(true);

      // Query untuk mengambil data dari tabel "alat"
      final response = await supabase
          .from('alat') // Nama tabel di Supabase
          .select() // Pilih semua data dari tabel
          ; // Supabase query tanpa execute() di versi terbaru

     

     
      
      }
  }

  // Menambahkan alat ke Supabase
  Future<void> addAlat(Alat alat) async {
    try {
      final response = await supabase
          .from('alat') // Nama tabel di Supabase
          .insert(alat.toJson()) // Mengirim data alat baru ke Supabase
          ; // Jangan gunakan execute() lagi di versi terbaru

      if (response.error != null) {
        print('Error adding alat: ${response.error!.message}');
        throw Exception('Gagal menambahkan alat: ${response.error!.message}');
      }

      alatList.add(alat); // Menambahkan alat ke dalam list lokal
    } catch (e) {
      print('Error adding alat: $e');
    }
  }

  // Mengupdate alat di Supabase
  Future<void> updateAlat(Alat alat) async {
    try {
      final response = await supabase
          .from('alat') // Nama tabel di Supabase
          .update(alat.toJson()) // Mengupdate data alat
          .eq('alat_id', alat.alatId) ;// Menentukan ID alat yang ingin diupdate
           // Jangan gunakan execute() lagi di versi terbaru

      if (response.error != null) {
        print('Error updating alat: ${response.error!.message}');
        throw Exception('Gagal mengupdate alat: ${response.error!.message}');
      }

      // Menemukan indeks alat yang sudah diupdate dan menggantinya dengan data baru
      var index = alatList.indexWhere((item) => item.alatId == alat.alatId);
      if (index != -1) {
        alatList[index] = alat;
      }
    } catch (e) {
      print('Error updating alat: $e');
    }
  }

  // Menghapus alat dari Supabase
  Future<void> deleteAlat(int alatId) async {
    try {
      final response = await supabase
          .from('alat') // Nama tabel di Supabase
          .delete() // Menghapus data
          .eq('alat_id', alatId) // Menentukan ID alat yang ingin dihapus
          ; // Jangan gunakan execute() lagi di versi terbaru

      if (response.error != null) {
        print('Error deleting alat: ${response.error!.message}');
        throw Exception('Gagal menghapus alat: ${response.error!.message}');
      }

      alatList.removeWhere((item) => item.alatId == alatId); // Menghapus alat dari list lokal
    } catch (e) {
      print('Error deleting alat: $e');
    }
  }
}
