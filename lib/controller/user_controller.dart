import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/admin/crud/crud_user/models/users_model.dart';
import 'log_controller.dart';

class UserController extends GetxController {
  final supabase = Supabase.instance.client;

  var usersList = <UserModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  // ================= GET USERS =================
  Future<void> getUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await supabase
          .from('users')
          .select()
          .order('created_at', ascending: false);

      usersList.value =
          (response as List).map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      errorMessage.value = 'Gagal mengambil data user';
    } finally {
      isLoading.value = false;
    }
  }

  // ================= CREATE USER =================
  Future<void> createUser({
    required String nama,
    required String email,
    required String password,
    String role = 'peminjam',
  }) async {
    print('Starting createUser with nama: $nama, email: $email, role: $role');
    try {
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final authUser = authResponse.user;
      if (authUser == null) throw 'Gagal membuat akun auth';
      print('Auth user created: ${authUser.id}');

      print('Inserting into users: id: ${authUser.id}, nama: $nama, email: $email, role: $role');
      await supabase.from('users').insert({
        'id': authUser.id,
        'nama': nama,
        'email': email,
        'role': role,
      });
      print('Insert successful');

      await getUsers(); // Refresh list first
      print('getUsers called after insert');
      Get.back();
      Get.snackbar('Sukses', 'User berhasil ditambahkan');
    } on AuthApiException catch (e) {
      print('AuthApiException: ${e.message}, status: ${e.statusCode}');
      if (e.statusCode == 422) {
        Get.snackbar('Error', 'Email sudah terdaftar');
      } else {
        Get.snackbar('Error', e.message);
      }
    } catch (e) {
      print('Exception in createUser: ${e.toString()}');
      if (e.toString().contains('duplicate key')) {
        Get.snackbar('Error', 'User sudah ada');
      } else {
        Get.snackbar('Error', 'Gagal membuat user: ${e.toString()}');
      }
    }
  }

  // ================= UPDATE =================
  Future<void> updateUser(UserModel user) async {
    try {
      await supabase.from('users').update({
        'nama': user.nama,
        'email': user.email,
        'role': user.role,
      }).eq('id', user.id!);

      Get.back();
      Get.snackbar('Sukses', 'User berhasil diupdate');
      getUsers();
    } catch (e) {
      Get.snackbar('Error', 'Gagal update user');
    }
  }

  // ================= DELETE =================
  Future<void> deleteUser(String id) async {
    try {
      // Get current user info for logging
      final currentUser = supabase.auth.currentUser;

      // Get user data before deletion for logging
      final userData = await supabase.from('users').select('nama, email').eq('id', id).single();
      final userName = userData['nama'] ?? 'Unknown';
      final userEmail = userData['email'] ?? 'Unknown';

      // Try to log the deletion (optional)
      try {
        final logController = Get.find<LogAktivitasController>();
        if (currentUser != null && currentUser.id != id) {
          await logController.addLog(
            idUser: null, // Set to null since user will be deleted
            aktivitas: 'User $userName ($userEmail) dihapus oleh admin',
            petugasId: currentUser.id, // Set to admin's id
          );
        }
      } catch (e) {
        print('Logging failed, but continuing with deletion: $e');
        // Continue with deletion even if logging fails
      }

      // Update related log activities to set id_user and petugas_id to null (to avoid foreign key constraints)
      await supabase.from('log_aktivitas').update({'id_user': null}).eq('id_user', id);
      await supabase.from('log_aktivitas').update({'petugas_id': null}).eq('petugas_id', id);

      // Also update any other tables that might reference this user
      // For example, if there are tables like 'peminjaman' or 'pengembalian' that reference user id
      try {
        await supabase.from('peminjaman').update({'id_user': null}).eq('id_user', id);
      } catch (e) {
        print('No peminjaman table or no references to update: $e');
      }
      try {
        await supabase.from('pengembalian').update({'id_user': null}).eq('id_user', id);
      } catch (e) {
        print('No pengembalian table or no references to update: $e');
      }

      // Delete the user
      await supabase.from('users').delete().eq('id', id);

      // If deleting current user, logout
      if (id == currentUser?.id) {
        await supabase.auth.signOut();
        Get.offAllNamed('/login');
        Get.snackbar('Sukses', 'Akun Anda berhasil dihapus');
        return;
      }

      await getUsers(); // Refresh list first
      Get.snackbar('Sukses', 'User berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal hapus user');
    }
  }

  // ================= DELETE BY EMAIL =================
  Future<void> deleteUserByEmail(String email) async {
    try {
      // Get current user info for logging
      final currentUser = supabase.auth.currentUser;

      // Get user data before deletion for logging
      final userData = await supabase.from('users').select('id, nama, email').eq('email', email).single();
      final userId = userData['id'];
      final userName = userData['nama'] ?? 'Unknown';
      final userEmail = userData['email'] ?? 'Unknown';

      // Try to log the deletion (optional)
      try {
        final logController = Get.find<LogAktivitasController>();
        if (currentUser != null && currentUser.id != userId) {
          await logController.addLog(
            idUser: null, // Set to null since user will be deleted
            aktivitas: 'User $userName ($userEmail) dihapus oleh admin',
            petugasId: currentUser.id, // Set to admin's id
          );
        }
      } catch (e) {
        print('Logging failed, but continuing with deletion: $e');
        // Continue with deletion even if logging fails
      }

      // Update all tables that reference the user to set foreign keys to null
      // peminjaman table: user_id and petugas_id
      await supabase.from('peminjaman').update({'user_id': null}).eq('user_id', userId);
      await supabase.from('peminjaman').update({'petugas_id': null}).eq('petugas_id', userId);

      // pengembalian table: petugas_id
      await supabase.from('pengembalian').update({'petugas_id': null}).eq('petugas_id', userId);

      // Update related log activities to set id_user and petugas_id to null (to avoid foreign key constraints)
      await supabase.from('log_aktivitas').update({'id_user': null}).eq('id_user', userId);
      await supabase.from('log_aktivitas').update({'petugas_id': null}).eq('petugas_id', userId);

      // Delete the user
      await supabase.from('users').delete().eq('email', email);

      // If deleting current user, logout
      if (userId == currentUser?.id) {
        await supabase.auth.signOut();
        Get.offAllNamed('/login');
        Get.snackbar('Sukses', 'Akun Anda berhasil dihapus');
        return;
      }

      await getUsers(); // Refresh list first
      Get.snackbar('Sukses', 'User berhasil dihapus');
    } catch (e) {
      print('Error deleting user by email: $e');
      Get.snackbar('Error', 'Gagal hapus user');
    }
  }
}