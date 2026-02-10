import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pinjam_ukk/controller/pengembalian_controller.dart';

class PengembalianScreen extends StatelessWidget {
  PengembalianScreen({super.key});

  final controller = Get.put(PengembalianController());

  @override
  Widget build(BuildContext context) {
    controller.fetchPengembalian();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengembalian'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pengembalianList.isEmpty) {
          return const Center(child: Text('Belum ada pengembalian'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.pengembalianList.length,
          itemBuilder: (context, index) {
            final data = controller.pengembalianList[index];
            final statusColor = data.status == 'belum dikembalikan'
                ? Colors.red
                : Colors.green;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: statusColor, width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header: Peminjaman ID & Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Peminjaman ID: ${data.peminjamanId}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Tanggal & Denda
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          data.tanggalKembaliActual != null
                              ? 'Kembali: ${data.tanggalKembaliActual!.toLocal().toString().split(' ')[0]}'
                              : 'Kembali: -',
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.money, size: 16),
                        const SizedBox(width: 6),
                        Text('Denda: Rp ${data.denda.toStringAsFixed(0)}'),
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
}
