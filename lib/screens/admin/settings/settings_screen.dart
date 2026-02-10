import 'package:aplikasi_pinjam_ukk/controller/auth_controller.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    const Color primaryBlue = AppColors.Blue;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Dinamis
            Obx(() {
              final nama = authController.namaDepan.value;
              final email = authController.emailUser.value;
              return CircleAvatar(
                radius: 50,
                backgroundColor: primaryBlue,
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  child: nama.isNotEmpty
                      ? Text(
                          nama[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        )
                      : const Icon(Icons.person, size: 48, color: Colors.grey),
                ),
              );
            }),
            const SizedBox(height: 12),
            Obx(() => Text(
                  authController.namaDepan.value.isNotEmpty
                      ? authController.namaDepan.value
                      : 'Memuat...',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                )),
            const SizedBox(height: 4),
            Obx(() => Text(
                  authController.emailUser.value.isNotEmpty
                      ? authController.emailUser.value
                      : 'Memuat...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                )),
            const SizedBox(height: 24),
            _buildInfoCard(authController, primaryBlue),
            const SizedBox(height: 20),
            _buildActionButton(
              label: 'Logout',
              icon: Icons.logout,
              color: Colors.red,
              onTap: () => _confirmLogout(context, authController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(AuthController authController, Color primaryBlue) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildInfoTile(
              icon: Icons.person_outline,
              label: 'Username',
              value: authController.namaDepan.value),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildInfoTile(
              icon: Icons.email,
              label: 'Email',
              value: authController.emailUser.value),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: Icon(Icons.lock_outline, color: primaryBlue),
            title: const Text('Password'),
            subtitle: const Text('********'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
      {required IconData icon, required String label, required String value}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0D47A1)),
      title: Text(label),
      subtitle:
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color color = const Color(0xFF0D47A1),
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthController authController) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Yakin Anda Keluar dari Aplikasi?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[200],
              minimumSize: const Size(80, 40),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(80, 40),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
