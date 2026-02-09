
import 'package:aplikasi_pinjam_ukk/screens/admin/dashboard/dashboard_admin.dart';
import 'package:aplikasi_pinjam_ukk/screens/auth/login_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/dashboard_peminjam.dart';
import 'package:aplikasi_pinjam_ukk/screens/petugas/dashboard_petugas.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final RxBool isLoading = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;



  // Cek status login saat app start
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final User? user = _supabase.auth.currentUser;
      if (user != null) {
        final response = await _supabase
            .from('users')
            .select('role')
            .eq('id', user.id)
            .single();

        final String role = response['role'] as String;
        _redirectBasedOnRole(role);
      } else {
        // Jika user tidak ada, arahkan ke login
        Get.offAll(() => const LoginScreen());
      }
    } else {
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

      // Sign in dengan Supabase Auth
      final AuthResponse authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Simpan status login di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // Menyimpan status login

      // Ambil user ID dari response
      final String userId = authResponse.user!.id;

      // Query ke tabel users untuk mendapatkan role
      final response = await _supabase
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();

      final String role = response['role'] as String;

      // Navigasi berdasarkan role
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

  // Redirect berdasarkan role
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

  // Logout
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();

      // Hapus status login di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');

      // Redirect ke Login Screen
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      emailError.value = 'Gagal logout';
    }
  }

  // Validasi email
  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Clear semua error
  void _clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }
}
