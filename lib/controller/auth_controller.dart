import 'package:aplikasi_pinjam_ukk/screens/admin/dashboard/dashboard_admin.dart';
import 'package:aplikasi_pinjam_ukk/screens/auth/login_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/dashboard_peminjam.dart';
import 'package:aplikasi_pinjam_ukk/screens/petugas/dashboard/dashboard_petugas.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Loading & error state
  final RxBool isLoading = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  // User info
  final RxString namaDepan = ''.obs;
  final RxString emailUser = ''.obs;
  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Listener untuk session (Google login atau session aktif)
    _supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await _handleSession(session);
      }
    });
  }

  // HANDLE SESSION (dipakai untuk Google login & saat app start)
  Future<void> _handleSession(Session session) async {
    try {
      final user = session.user;
      if (user == null) return;

      // Simpan info user di controller
      final email = user.email ?? '';
      userId.value = user.id;
      emailUser.value = email;
      namaDepan.value = email.split('@')[0];

      // Cek apakah user sudah ada di tabel 'users'
      final existingUser = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existingUser == null) {
        // Jika belum ada, insert default role peminjam
        await _supabase.from('users').insert({
          'id': user.id,
          'nama': namaDepan.value,
          'email': email,
          'role': 'peminjam'
        });
      }

      // Ambil role user dari tabel
      final response = await _supabase
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single();

      final String role = response['role'] as String;

      _redirectBasedOnRole(role);
    } catch (e) {
      Get.snackbar("Error", "Gagal memproses login: $e");
    }
  }

  // CEK SESSION SAAT APP START
  Future<void> checkAuthStatus() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      await _handleSession(session);
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  // LOGIN GOOGLE
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
await _supabase.auth.signInWithOAuth(
  OAuthProvider.google,
  redirectTo: 'com.example.aplikasi_pinjam_ukk://login-callback/',
);

    } catch (e) {
      Get.snackbar("Error", "Gagal login Google: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // LOGIN EMAIL & PASSWORD
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      _clearErrors();

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

      final AuthResponse authResponse =
          await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) throw Exception("User tidak ditemukan");

      userId.value = user.id;
      emailUser.value = email;
      namaDepan.value = email.split('@')[0];

      final response = await _supabase
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single();

      final String role = response['role'] as String;

      _redirectBasedOnRole(role);
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        passwordError.value = 'Password salah';
      } else {
        emailError.value = 'Terjadi kesalahan autentikasi';
      }
    } catch (e) {
      emailError.value = 'Terjadi kesalahan. Coba lagi nanti.';
    } finally {
      isLoading.value = false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');

      Get.offAll(() => const LoginScreen());
    } catch (e) {
      Get.snackbar("Error", "Gagal logout: $e");
    }
  }

  // Redirect user berdasarkan role
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
        Get.snackbar("Error", "Role tidak dikenali");
    }
  }

  // Validasi email
  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Clear error state
  void _clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }
}
