import 'package:aplikasi_pinjam_ukk/screens/peminjam/proses/pengembalian.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityCardWidget extends StatelessWidget {
  final String name;
  final String item;
  final String date;
  final String status;

  const ActivityCardWidget({
    super.key,
    required this.name,
    required this.item,
    required this.date,
    required this.status,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu persetujuan':
        return Colors.orange;

      case 'mengajukan pengembalian':
        return Colors.green;

      case 'selesai':
      case 'dikembalikan':
        return Colors.blue;

      case 'ditolak':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  void handleStatusAction(BuildContext context) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        Get.to(() => ());
        break;

      case 'menunggu persetujuan':
        Get.snackbar(
          "Info",
          "Peminjaman masih menunggu persetujuan petugas",
          backgroundColor: Colors.orange.shade100,
        );
        break;

      case 'selesai':
      case 'dikembalikan':
        Get.snackbar(
          "Info",
          "Peminjaman sudah selesai",
          backgroundColor: Colors.blue.shade100,
        );
        break;

      case 'ditolak':
        Get.snackbar(
          "Info",
          "Pengajuan peminjaman ditolak",
          backgroundColor: Colors.red.shade100,
        );
        break;

      default:
        Get.snackbar(
          "Info",
          "Status tidak dikenali",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(status);

    return Container(
      padding: const EdgeInsets.all(32.0),
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          OutlinedButton(
            onPressed: () => handleStatusAction(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: statusColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              minimumSize: Size.zero,
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
