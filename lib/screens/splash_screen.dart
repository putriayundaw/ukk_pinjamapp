
import 'package:aplikasi_pinjam_ukk/screens/auth/login_screen.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Menunggu selama 5 detik sebelum berpindah ke halaman login
    Future.delayed(const Duration(seconds: 2), () {
      // Pindah ke halaman LoginScree3
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.Blue,  // Pastikan AppColors sudah didefinisikan
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Agar teks di tengah
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'EquipHub',
              style: TextStyle(
                color: AppColors.White,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),  // Menambahkan jarak antara dua teks
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
