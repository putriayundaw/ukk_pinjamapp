import 'package:aplikasi_pinjam_ukk/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamSetting extends StatelessWidget {
  const PeminjamSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>(); // GetX controller
    final supabase = Supabase.instance.client;

    // Ambil data user dari Supabase
    final user = supabase.auth.currentUser;
    final email = user?.email ?? 'Tidak ada email';
    final username = email.split('@')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Dinamis
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF0D47A1),
              child: username.isNotEmpty
                  ? Text(
                      username[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : const CircularProgressIndicator(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              username.isNotEmpty ? username : 'Memuat...',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              email.isNotEmpty ? email : 'Memuat...',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(username, email),
            const SizedBox(height: 20),
            // Tombol Logout, langsung panggil AuthController
            _buildActionButton(
              label: 'Logout',
              icon: Icons.logout,
              color: Colors.red,
              onTap: () async {
                await authController.logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String username, String email) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildInfoTile(icon: Icons.person_outline, label: 'Username', value: username),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildInfoTile(icon: Icons.email, label: 'Email', value: email),
          const Divider(height: 1, indent: 16, endIndent: 16),
          const ListTile(
            leading: Icon(Icons.lock_outline, color: Color(0xFF0D47A1)),
            title: Text('Password'),
            subtitle: Text('********'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String label, required String value}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0D47A1)),
      title: Text(label),
      subtitle: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  _buildActionButton({
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
    onPressed: () {
      // Dialog konfirmasi logout
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Yakin Anda Keluar dari Aplikasi??',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Tindakan ini tidak dapat dibatalkan.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Tutup dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[200],
                minimumSize: const Size(80, 40),
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Logout via AuthController
                final authController = Get.find<AuthController>();
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
    },
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
}
