import 'package:aplikasi_pinjam_ukk/controller/peminjaman_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PemantauPage extends StatefulWidget {
  const PemantauPage({super.key});

  @override
  State<PemantauPage> createState() => _PemantauPageState();
}

class _PemantauPageState extends State<PemantauPage> {
  final PeminjamanController controller = Get.put(PeminjamanController());
  String selectedFilter = 'Hari Ini';

  @override
  void initState() {
    super.initState();
   controller.fetchPeminjaman();
();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Peminjaman', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.blue),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _printReport,
        child: const Icon(Icons.print),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Hari Ini'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Per Bulan'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // LIST LAPORAN
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.peminjamanList.isEmpty) {
                  return const Center(child: Text('Tidak ada data peminjaman'));
                }

                if (selectedFilter == 'Hari Ini') {
                  final today = DateTime.now();
                  final todayString = DateFormat('yyyy-MM-dd').format(today);
                  final filteredList = controller.peminjamanList.where((peminjaman) {
                    final pinjamDate = peminjaman.tanggalPinjam;
                    return pinjamDate != null && DateFormat('yyyy-MM-dd').format(pinjamDate) == todayString;
                  }).toList();

                  if (filteredList.isEmpty) {
                    return const Center(child: Text('Tidak ada peminjaman hari ini'));
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final data = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('Alat: ${data.namaAlat ?? '-'}'),
                          subtitle: Text('Peminjam: ${data.userId ?? '-'}'),
                          trailing: Text('Jumlah: ${data.jumlahAlat}'),
                        ),
                      );
                    },
                  );
                } else if (selectedFilter == 'Per Bulan') {
                  // Group by month
                  Map<String, int> monthlyCounts = {};
                  for (var peminjaman in controller.peminjamanList) {
                    final pinjamDate = peminjaman.tanggalPinjam;
                    if (pinjamDate != null) {
                      final monthKey = DateFormat('yyyy-MM').format(pinjamDate);
                      monthlyCounts[monthKey] = (monthlyCounts[monthKey] ?? 0) + 1;
                    }
                  }

                  final sortedMonths = monthlyCounts.keys.toList()..sort();

                  return ListView.builder(
                    itemCount: sortedMonths.length,
                    itemBuilder: (context, index) {
                      final month = sortedMonths[index];
                      final count = monthlyCounts[month]!;
                      final monthName = DateFormat('MMMM yyyy', 'id_ID').format(DateTime.parse('$month-01'));
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('Bulan: $monthName'),
                          trailing: Text('Total Peminjaman: $count'),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              }),
            ),
          ],
        ),
      ),
    );
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

  Future<void> _printReport() async {
    final pdf = pw.Document();

    if (selectedFilter == 'Hari Ini') {
      final today = DateTime.now();
      final todayString = DateFormat('yyyy-MM-dd').format(today);
      final filteredList = controller.peminjamanList.where((peminjaman) {
        final pinjamDate = peminjaman.tanggalPinjam;
        return pinjamDate != null && DateFormat('yyyy-MM-dd').format(pinjamDate) == todayString;
      }).toList();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('Laporan Peminjaman Hari Ini', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Alat', 'Peminjam', 'Jumlah'],
                  data: filteredList.map((data) => [
                    data.namaAlat ?? '-',
                    data.userId ?? '-',
                    data.jumlahAlat.toString(),
                  ]).toList(),
                ),
              ],
            );
          },
        ),
      );
    } else if (selectedFilter == 'Per Bulan') {
      Map<String, int> monthlyCounts = {};
      for (var peminjaman in controller.peminjamanList) {
        final pinjamDate = peminjaman.tanggalPinjam;
        if (pinjamDate != null) {
          final monthKey = DateFormat('yyyy-MM').format(pinjamDate);
          monthlyCounts[monthKey] = (monthlyCounts[monthKey] ?? 0) + 1;
        }
      }

      final sortedMonths = monthlyCounts.keys.toList()..sort();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('Laporan Peminjaman Per Bulan', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Bulan', 'Total Peminjaman'],
                  data: sortedMonths.map((month) => [
                    DateFormat('MMMM yyyy', 'id_ID').format(DateTime.parse('$month-01')),
                    monthlyCounts[month]!.toString(),
                  ]).toList(),
                ),
              ],
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
///