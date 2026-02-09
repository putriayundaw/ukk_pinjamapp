import 'package:aplikasi_pinjam_ukk/controller/auth_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/auth/login_screen.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Menunggu selama 2 detik sebelum berpindah ke halaman login
    Future.delayed(const Duration(seconds: 2), () {
      // Pindah ke halaman LoginScreen
      final authC = Get.find<AuthController>();
      authC.checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.Blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'PinjamAja',
              style: TextStyle(
                color: AppColors.White,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Pinjam Alat Sekolah dengan Mudah',
              style: TextStyle(
                color: AppColors.White,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
