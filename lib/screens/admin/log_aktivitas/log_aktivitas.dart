import 'package:aplikasi_pinjam_ukk/controller/log_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/log_aktivitas/models.dart/log_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogAktivitasPage extends StatelessWidget {
  final LogAktivitasController logC = Get.find<LogAktivitasController>();

  LogAktivitasPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Aktivitas', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SEARCH BAR
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                // Filter list by aktivitas
                if (value.isEmpty) {
                  logC.fetchLogs();
                } else {
                  final filtered = logC.logList.where((log) =>
                      log.aktivitas.toLowerCase().contains(value.toLowerCase())).toList();
                  logC.logList.assignAll(filtered);
                }
              },
            ),
            const SizedBox(height: 16),
            // LIST LOG
            Expanded(
              child: Obx(() {
                if (logC.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (logC.logList.isEmpty) {
                  return const Center(child: Text('Tidak ada log aktivitas'));
                }

                return ListView.builder(
                  itemCount: logC.logList.length,
                  itemBuilder: (context, index) {
                    LogAktivitas log = logC.logList[index];
                    final tanggal = log.waktu != null
                        ? "${log.waktu!.day.toString().padLeft(2, '0')}/${log.waktu!.month.toString().padLeft(2, '0')}/${log.waktu!.year}"
                        : "-";

                    final role = log.petugasId != null ? "Petugas" : "Peminjam";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Tanggal + Aktivitas
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tanggal,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(log.aktivitas),
                              ],
                            ),
                          ),
                          // Role
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              role,
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
