import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pinjam_ukk/controller/detail_peminjaman_controller.dart';

class DetailPeminjamanSheet extends StatefulWidget {
  final int peminjamanId;

  const DetailPeminjamanSheet({super.key, required this.peminjamanId});

  @override
  State<DetailPeminjamanSheet> createState() => _DetailPeminjamanSheetState();
}

class _DetailPeminjamanSheetState extends State<DetailPeminjamanSheet> {
  final controller = Get.put(DetailPeminjamanController());

  @override
  void initState() {
    super.initState();
    controller.fetchDetail(widget.peminjamanId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.detailList.isEmpty) {
        return const Center(child: Text('Tidak ada detail peminjaman'));
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.assignment, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Detail Peminjaman',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),

          const Divider(),

          /// LIST DETAIL
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.detailList.length,
            itemBuilder: (context, index) {
              final data = controller.detailList[index];

              final status = data['status_alat'];
              final statusColor =
                  status == 'dipinjam' ? Colors.blue : Colors.green;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: statusColor, width: 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// PEMINJAMAN ID
                      Text(
                        'Peminjaman ID: ${widget.peminjamanId}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 6),

                      /// ALAT
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                statusColor.withOpacity(0.15),
                            child: Icon(
                              Icons.build,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Alat ID: ${data['alat_id']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          _statusChip(status),
                        ],
                      ),

                      const Divider(height: 24),

                      /// DETAIL INFO
                      _infoRow(
                        Icons.inventory_2,
                        'Jumlah Alat',
                        data['jumlah_alat'].toString(),
                      ),
                      _infoRow(
                        Icons.info_outline,
                        'Status Alat',
                        status,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }

  /// ROW INFO
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// CHIP STATUS
  Widget _statusChip(String status) {
    Color color;

    switch (status) {
      case 'dipinjam':
        color = Colors.blue;
        break;
      case 'dikembalikan':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
