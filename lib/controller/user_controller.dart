import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/admin/crud/crud_user/models/users_model.dart';

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
 try {
  final authResponse = await supabase.auth.signUp(
    email: email,
    password: password,
  );

  final authUser = authResponse.user;
  if (authUser == null) throw 'Gagal membuat akun auth';

  await supabase.from('users').insert({
    'id': authUser.id,
    'nama': nama,
    'email': email,
    'role': role,
  });

  Get.back();
  Get.snackbar('Sukses', 'User berhasil ditambahkan');
} on AuthApiException catch (e) {
  if (e.statusCode == 422) {
    Get.snackbar('Error', 'Email sudah terdaftar');
  } else {
    Get.snackbar('Error', e.message);
  }
}

  }

  // ================= UPDATE =================
  Future<void> updateUser(UserModel user) async {
    try {
      await supabase.from('users').update({
        'nama': user.nama,
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
      await supabase.from('users').delete().eq('id', id);

      Get.snackbar('Sukses', 'User berhasil dihapus');
      getUsers();
    } catch (e) {
      Get.snackbar('Error', 'Gagal hapus user');
    }
  }
}
