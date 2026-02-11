import 'package:aplikasi_pinjam_ukk/controller/peminjaman_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersetujuanPage extends StatefulWidget {
  const PersetujuanPage({super.key});

  @override
  State<PersetujuanPage> createState() => _PersetujuanPageState();
}

class _PersetujuanPageState extends State<PersetujuanPage> {
  final PeminjamanController controller = Get.put(PeminjamanController());
  String selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
   controller.fetchPeminjaman();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persetujuan Peminjaman'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Menunggu Persetujuan'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Disetujui'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Ditolak'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.peminjamanList.isEmpty) {
                return const Center(
                  child: Text('Tidak ada data peminjaman'),
                );
              }

              // Filter the list based on selectedFilter
              List filteredList = controller.peminjamanList;
              if (selectedFilter != 'Semua') {
                String statusFilter;
                switch (selectedFilter) {
                  case 'Menunggu Persetujuan':
                    statusFilter = 'menunggu persetujuan';
                    break;
                  case 'Disetujui':
                    statusFilter = 'disetujui';
                    break;
                  case 'Ditolak':
                    statusFilter = 'ditolak';
                    break;
                  default:
                    statusFilter = '';
                }
                filteredList = controller.peminjamanList.where((data) => data.status == statusFilter).toList();
              }

              return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final data = filteredList[index];

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
                            'Alat: ${data.namaAlat ?? '-'}',
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
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Setujui'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                          ),
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Setujui Peminjaman',
                              middleText: 'Yakin setujui peminjaman ini?',
                              textConfirm: 'Ya',
                              textCancel: 'Batal',
                              onConfirm: () {
                                controller.approvePeminjaman(data.peminjamanId!);
                                Get.back();
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Tolak'),
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Tolak Peminjaman',
                              middleText: 'Yakin tolak peminjaman ini?',
                              textConfirm: 'Ya',
                              textCancel: 'Batal',
                              onConfirm: () {
                                controller.rejectPeminjaman(data.peminjamanId!);
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
    )
     ] ),
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

  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    return isSelected
        ? ElevatedButton(
            onPressed: () {
              setState(() {
                selectedFilter = label;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF64B5F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
            ),
            child: Text(label, style: const TextStyle(color: Colors.white)),
          )
        : OutlinedButton(
            onPressed: () {
              setState(() {
                selectedFilter = label;
              });
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          );
  }
}
