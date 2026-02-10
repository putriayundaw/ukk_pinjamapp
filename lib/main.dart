import 'dart:async';
import 'package:aplikasi_pinjam_ukk/controller/auth_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/kategori_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart'; // Tambahkan ini
import 'package:aplikasi_pinjam_ukk/controller/log_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/peminjaman_controller.dart';
import 'package:aplikasi_pinjam_ukk/controller/user_controller.dart'; // Tambahkan ini
import 'package:aplikasi_pinjam_ukk/screens/admin/settings/settings_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/dashboard/dashboard_admin.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/dashboard_peminjam.dart';
import 'package:aplikasi_pinjam_ukk/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Pastikan intl di-import
import 'package:intl/date_symbol_data_local.dart'; // Import ini untuk initializeDateFormatting
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Supabase
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runZonedGuarded(() async {
    try {
      await Supabase.initialize(
        url: 'https://plmmhkfvucxwyyjxlkyc.supabase.co',
        anonKey: 'sb_publishable_9QkzrnGaWWu_9kdPhAcXsg_pxBsQemQ',
        authOptions: const FlutterAuthClientOptions(
          autoRefreshToken: true,
        ),
      );
    } catch (e) {
      print('Supabase initialization failed: $e');
      // Fallback or show error
    }

    // Inisialisasi format tanggal dan waktu untuk locale Indonesia
    await initializeDateFormatting('id_ID', null);

    // Inisialisasi controller
    Get.put(AuthController());
    Get.put(KategoriController());
    Get.put(AlatController());
    Get.put(UserController());
    Get.put(LogAktivitasController());
    Get.put(PeminjamanController());

    // Menjalankan aplikasi
    runApp(const MyApp());
  }, (error, stack) {
    print('Error: $error');
    print('Stack: $stack');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
