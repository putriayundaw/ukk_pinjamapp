import 'package:aplikasi_pinjam_ukk/controller/peminjaman_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/detail_peminjaman/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeminjamanScreen extends StatelessWidget {
  PeminjamanScreen({super.key});

  final PeminjamanController controller = Get.put(PeminjamanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Peminjaman'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.peminjamanList.isEmpty) {
          return const Center(
            child: Text('Belum ada data peminjaman'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.peminjamanList.length,
          itemBuilder: (context, index) {
            final data = controller.peminjamanList[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: _statusColor(data.status),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              _statusColor(data.status).withOpacity(0.15),
                          child: Text(
                            data.jumlahAlat.toString(),
                            style: TextStyle(
                              color: _statusColor(data.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Alat ID: ${data.alatId ?? '-'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _statusChip(data.status),
                      ],
                    ),

                    const Divider(height: 20),

                    /// DETAIL
                    _infoRow(
                      Icons.person,
                      'ID Peminjam',
                      data.userId ?? '-',
                    ),
                    _infoRow(
                      Icons.badge,
                      'Petugas',
                      data.petugasId ?? '-',
                    ),
                    _infoRow(
                      Icons.login,
                      'Tanggal Pinjam',
                      data.tanggalPinjam
                              ?.toLocal()
                              .toString()
                              .split(".")
                              .first ??
                          '-',
                    ),
                    _infoRow(
                      Icons.logout,
                      'Tanggal Kembali',
                      data.tanggalKembali
                          .toLocal()
                          .toString()
                          .split(".")
                          .first,
                    ),
                    const SizedBox(height: 10),

Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    OutlinedButton.icon(
      icon: const Icon(Icons.visibility, size: 18),
      label: const Text('Detail'),
      onPressed: () {
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: Get.width * 0.8,
              child: DetailPeminjamanSheet(
                peminjamanId: data.peminjamanId!,
              ),
            ),
          ),
        );
      },
    
  



    ),
    const SizedBox(width: 8),
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      icon: const Icon(Icons.delete, size: 18),
      label: const Text('Hapus'),
      onPressed: () {
        Get.defaultDialog(
          title: 'Hapus',
          middleText: 'Yakin hapus data ini?',
          textConfirm: 'Ya',
          textCancel: 'Batal',
          onConfirm: () {
            controller.deletePeminjaman(data.peminjamanId!);
            Get.back();
          },
        );
      },
    ),
  ],
),

                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status ?? '-',
        style: TextStyle(
          color: _statusColor(status),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'menunggu persetujuan':
        return Colors.orange;
      case 'disetujui':
        return Colors.blue;
      case 'ditolak':
        return Colors.red;
      case 'dipinjam':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
