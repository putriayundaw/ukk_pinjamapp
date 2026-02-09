// import 'package:flutter/material.dart';
// import 'package:aplikasi_pinjam_ukk/controller/peminjaman_controller.dart';
// import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/peminjaman/models/peminjaman_model.dart';

// class PeminjamanScreen extends StatefulWidget {
//   const PeminjamanScreen({super.key});

//   @override
//   _PeminjamanScreenState createState() => _PeminjamanScreenState();
// }

// class _PeminjamanScreenState extends State<PeminjamanScreen> {
//   final PeminjamanController _controller = PeminjamanController(baseUrl: 'http://localhost:3000'); // Ganti dengan baseUrl yang sesuai
//   List<Peminjaman> peminjamanList = [];
//   bool isLoading = true;
//   String? errorMessage;

//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = "";

//   @override
//   void initState() {
//     super.initState();
//     _fetchPeminjaman();
//     // Listener untuk memperbarui UI saat teks pencarian berubah
//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text;
//       });
//     });
//   }

//   Future<void> _fetchPeminjaman() async {
//     try {
//       final peminjaman = await _controller.getAllPeminjaman();
//       setState(() {
//         peminjamanList = peminjaman;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = e.toString();
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryBlue = Color(0xFF0D47A1);

//     // Menggunakan DefaultTabController untuk state tab "Aktif" dan "Selesai"
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.grey[100],
//         appBar: AppBar(
//           title: const Text('Riwayat Peminjaman', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//           centerTitle: true,
//           backgroundColor: Colors.white,
//           elevation: 1,
//           iconTheme: const IconThemeData(color: Colors.black),
//           // Bagian bawah AppBar untuk menempatkan TabBar
//           bottom: const TabBar(
//             indicatorColor: primaryBlue,
//             indicatorWeight: 3,
//             labelColor: primaryBlue,
//             unselectedLabelColor: Colors.grey,
//             labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             tabs: [
//               Tab(text: 'Aktif'),
//               Tab(text: 'Selesai'),
//             ],
//           ),
//         ),
//         // Konten yang bisa digeser sesuai tab yang dipilih
//         body: TabBarView(
//           children: [
//             _buildPeminjamanContent('Aktif'), // UI untuk tab Aktif
//             _buildPeminjamanContent('Selesai'), // UI untuk tab Selesai
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () { /* TODO: Logika untuk tambah peminjaman */ },
//           backgroundColor: primaryBlue,
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//       ),
//     );
//   }

//   // Widget kerangka untuk setiap tab (Search Bar + List)
//   Widget _buildPeminjamanContent(String status) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (errorMessage != null) {
//       return Center(child: Text('Error: $errorMessage'));
//     }

//     // Logika filter Anda, digabungkan dengan filter pencarian
//     final List<Peminjaman> filteredList = peminjamanList.where((item) {
//       final statusMatch = item.status == status;
//       final searchMatch = item.alatId.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
//                           item.userId.toLowerCase().contains(_searchQuery.toLowerCase());
//       return statusMatch && searchMatch;
//     }).toList();

//     return Column(
//       children: [
//         // Search Bar
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Cari riwayat peminjaman...',
//               prefixIcon: const Icon(Icons.search, color: Colors.grey),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: const EdgeInsets.symmetric(vertical: 12),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ),
//         // Daftar Peminjaman
//         Expanded(
//           child: filteredList.isEmpty
//               ? Center(child: Text('Tidak ada riwayat untuk ditampilkan.', style: TextStyle(color: Colors.grey.shade600)))
//               : ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: filteredList.length,
//                   itemBuilder: (context, index) {
//                     return _buildItemCard(filteredList[index]);
//                   },
//                 ),
//         ),
//       ],
//     );
//   }

//   // WIDGET KARTU - INI ADALAH BAGIAN YANG DIDESAIN ULANG TOTAL
//   Widget _buildItemCard(Peminjaman peminjaman) {
//     const Color primaryBlue = Color(0xFF0D47A1);

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shadowColor: Colors.black.withOpacity(0.1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             // Ikon Kiri
//             CircleAvatar(
//               radius: 25,
//               backgroundColor: primaryBlue.withOpacity(0.1),
//               child: const Icon(Icons.laptop_chromebook, color: primaryBlue, size: 28),
//             ),
//             const SizedBox(width: 16),
//             // Kolom Teks Tengah (Nama Alat & Peminjam)
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     peminjaman.alatId.toString(),
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Peminjam: ${peminjaman.userId}',
//                     style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             // Kolom Kanan (Tanggal & Tombol Detail)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   peminjaman.tanggalPinjam.toString(),
//                   style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//                 ),
//                 const SizedBox(height: 8),
//                 // Tombol "Lihat Detail" dengan gaya yang presisi
//                 TextButton(
//                   onPressed: () { /* TODO: Navigasi ke Halaman Detail */ },
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     minimumSize: Size.zero,
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: Colors.grey.shade300),
//                     ),
//                   ),
//                   child: const Text('Lihat Detail', style: TextStyle(fontSize: 12, color: primaryBlue)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Dialog konfirmasi Anda dipertahankan, dapat digunakan di halaman detail
//   void _showDeleteConfirmation(BuildContext context, int itemId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Konfirmasi Hapus'),
//           content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Batal'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await _controller.deletePeminjaman(itemId);
//                   setState(() {
//                     peminjamanList.removeWhere((item) => item.peminjamanId == itemId);
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Peminjaman berhasil dihapus')),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Gagal menghapus: $e')),
//                   );
//                 }
//                 Navigator.pop(context);
//               },
//               child: const Text('Hapus'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
