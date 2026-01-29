
import 'package:aplikasi_pinjam_ukk/screens/auth/login_screen.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Fungsi logout dengan konfirmasi
  Future<void> _confirmLogout(BuildContext context) async {
    bool? logout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (logout == true) {
      _logout(context);
    }
  }

  // Fungsi logout
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    Get.snackbar(
      "Logout Berhasil",
      "Anda telah berhasil logout",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.Blue,
      colorText: Colors.white,
    );

    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            'Settings',
            style: TextStyle(
              color: AppColors.Blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            const SizedBox(height: 10),
            const Text(
              'CasHieR',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.Blue,
              ),
            ),
            const SizedBox(height: 30),
            settingsItem('Profile'),
            const SizedBox(height: 12),
            settingsItem('Tentang Aplikasi'),
            const SizedBox(height: 12),
            settingsItem('Versi Aplikasi'),
            const SizedBox(height: 30),
            SizedBox(
              width: 370,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _confirmLogout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.Blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsItem(String title) {
    return Container(
      width: 370,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.Blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: null, // disabled
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          disabledForegroundColor: AppColors.Blue,
          disabledBackgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.Blue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
