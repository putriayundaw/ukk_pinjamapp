import 'package:aplikasi_pinjam_ukk/screens/admin/dashboard/dashboard_admin.dart';
import 'package:aplikasi_pinjam_ukk/screens/auth/login_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/dashboard_peminjam.dart';
import 'package:aplikasi_pinjam_ukk/screens/petugas/dashboard/dashboard_petugas.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final RxBool isLoading = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  // Tambahan untuk profile
  final RxString namaDepan = ''.obs;  // untuk nama depan
  final RxString emailUser = ''.obs;   // untuk email
  final RxString userId = ''.obs; // untuk user id

  // Cek status login saat app start
  Future<void> checkAuthStatus() async {
  // Gunakan session dari Supabase
  final session = _supabase.auth.currentSession;

  if (session != null && session.user != null) {
    final user = session.user!;
    
    // Ambil role
    final response = await _supabase
        .from('users')
        .select('role')
        .eq('id', user.id)
        .single();

    final emailSupabase = user.email ?? '';
    userId.value = user.id;
    namaDepan.value = emailSupabase.split('@')[0];
    emailUser.value = emailSupabase;

    final String role = response['role'] as String;
    _redirectBasedOnRole(role);
  } else {
    // Jika session null, arahkan ke login
    Get.offAll(() => const LoginScreen());
  }
}


  // Login dengan email dan password
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      _clearErrors();

      // Validasi input
      bool hasError = false;
      if (email.isEmpty) {
        emailError.value = 'Email harus diisi';
        hasError = true;
      } else if (!_validateEmail(email)) {
        emailError.value = 'Format email tidak valid';
        hasError = true;
      }
      if (password.isEmpty) {
        passwordError.value = 'Password harus diisi';
        hasError = true;
      }
      if (hasError) {
        isLoading.value = false;
        return;
      }

      // Sign in Supabase
      final AuthResponse authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final String userId = authResponse.user!.id;

      // Ambil nama depan dari email
      final String nama = email.split('@')[0];
      namaDepan.value = nama;
      emailUser.value = email;
      this.userId.value = userId;

      // Simpan di Supabase (opsional)
      await _supabase.from('users').upsert({
        'id': userId,
        'nama': nama,
      }, onConflict: 'id');

      // Query role
      final response = await _supabase
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();
      final String role = response['role'] as String;

      _redirectBasedOnRole(role);

    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        passwordError.value = 'Password salah';
      } else {
        emailError.value = 'Terjadi kesalahan autentikasi';
      }
    } on PostgrestException {
      emailError.value = 'Terjadi kesalahan sistem';
    } catch (e) {
      emailError.value = 'Terjadi kesalahan. Coba lagi nanti.';
    } finally {
      isLoading.value = false;
    }
  }

  void _redirectBasedOnRole(String role) {
    switch (role) {
      case 'admin':
        Get.offAll(() => const DashboardAdmin());
        break;
      case 'petugas':
        Get.offAll(() => const DashboardPetugas());
        break;
      case 'peminjam':
        Get.offAll(() => const DashboardPeminjam());
        break;
      default:
        emailError.value = 'Role tidak dikenali';
    }
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      emailError.value = 'Gagal logout';
    }
  }

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }
}
