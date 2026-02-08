import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_user/models/users_model.dart';

class UserController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Reactive variables
  var user = Rx<UserModel?>(null);  // Data pengguna yang terambil
  var usersList = <UserModel>[].obs;  // List pengguna
  var isLoading = false.obs;  // Status loading
  var errorMessage = ''.obs;  // Menyimpan pesan error

  // Mendapatkan data pengguna berdasarkan ID
  Future<void> getUserById(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      user.value = UserModel.fromJson(response);
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  // Mendapatkan daftar semua pengguna
  Future<void> getUsers() async {
    try {
      isLoading.value = true;
      final response = await _supabase
          .from('users')
          .select()
          .order('created_at', ascending: false);

      usersList.value = (response as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  // Menambahkan pengguna baru
  Future<void> addUser(UserModel newUser) async {
    try {
      isLoading.value = true;
      final response = await _supabase.from('users').insert([
        {
          'nama': newUser.nama,
          'role': newUser.role,
          'email': newUser.email,
          'password': newUser.password,
        }
      ]).single();

      usersList.add(UserModel.fromJson(response));
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  // Mengupdate data pengguna
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      isLoading.value = true;
      final response = await _supabase
          .from('users')
          .update({
            'nama': updatedUser.nama,
            'role': updatedUser.role,
            'email': updatedUser.email,
            'password': updatedUser.password,
          })
          .eq('id', updatedUser.id)
          .single();

      final index = usersList.indexWhere((u) => u.id == updatedUser.id);
      if (index != -1) {
        usersList[index] = UserModel.fromJson(response);
      }
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  // Menghapus pengguna
  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;
      await _supabase.from('users').delete().eq('id', userId);
      usersList.removeWhere((user) => user.id == userId);
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }
}
