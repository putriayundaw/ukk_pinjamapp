import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/home_peminjam.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersetujuanDialog extends StatelessWidget {
  const PersetujuanDialog({super.key, required this.onOk});

  final VoidCallback onOk; // Callback untuk tombol OK

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Text('Persetujuan Peminjaman', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ikon centang dengan background biru
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.check, 
              size: 50, 
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Menunggu Persetujuan Petugas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        // Tombol OK yang mengarah ke halaman Home
       TextButton(
  onPressed: () {
    onOk(); // Memanggil callback untuk menavigasi ke halaman Home
  },
  style: TextButton.styleFrom(
    iconColor: Colors.white, // Warna teks tombol (Putih)
    backgroundColor: Colors.blue, // Warna latar belakang tombol (Biru)
  ),
  child: const Center(
    child: Text(
      'OK',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
)
      ]
    );
  }
}
