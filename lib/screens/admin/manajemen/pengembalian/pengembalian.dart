import 'package:flutter/material.dart';

class PengembalianScreen extends StatefulWidget {
  const PengembalianScreen({super.key});

  @override
  _PengembalianScreenState createState() => _PengembalianScreenState();
}

class _PengembalianScreenState extends State<PengembalianScreen> {
  // Data dummy diperluas untuk mencakup semua informasi yang dibutuhkan UI
  final List<Map<String, String>> peminjamanList = [
    {'id': '1', 'namaAlat': 'Proyektor', 'peminjam': 'John Doe', 'tanggal': '17 Jan 2026', 'status': 'Selesai'},
    {'id': '2', 'namaAlat': 'Kamera DSLR', 'peminjam': 'Jane Smith', 'tanggal': '15 Jan 2026', 'status': 'Selesai'},
    {'id': '3', 'namaAlat': 'Laptop Gaming', 'peminjam': 'Mike Ross', 'tanggal': '20 Feb 2026', 'status': 'Aktif'},
    {'id': '4', 'namaAlat': 'Speaker Bluetooth', 'peminjam': 'Rachel Zane', 'tanggal': '22 Feb 2026', 'status': 'Aktif'},
  ];

  // Controller untuk search bar
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);

    // Menggunakan DefaultTabController untuk mengelola state tab
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Riwayat Peminjaman',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            indicatorColor: primaryBlue,
            indicatorWeight: 3,
            labelColor: primaryBlue,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: 'Aktif'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Konten untuk tab "Aktif"
            _buildPeminjamanTab('Aktif'),
            // Konten untuk tab "Selesai"
            _buildPeminjamanTab('Selesai'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () { /* TODO: Aksi untuk FAB */ },
          backgroundColor: primaryBlue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // Widget untuk membangun konten setiap tab (Search Bar + List)
  Widget _buildPeminjamanTab(String status) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari riwayat peminjaman...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // Daftar Peminjaman
        Expanded(
          child: _buildPeminjamanList(status),
        ),
      ],
    );
  }

  // Widget untuk membangun daftar peminjaman berdasarkan status
  Widget _buildPeminjamanList(String status) {
    // Memfilter list berdasarkan status DAN query pencarian
    final List<Map<String, String>> filteredList = peminjamanList.where((item) {
      final statusMatch = item['status'] == status;
      final searchMatch = item['namaAlat']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          item['peminjam']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return statusMatch && searchMatch;
    }).toList();

    if (filteredList.isEmpty) {
      return Center(child: Text('Tidak ada riwayat untuk ditampilkan.', style: TextStyle(color: Colors.grey.shade600)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return _buildItemCard(item); // Menggunakan kartu kustom
      },
    );
  }

  // Widget untuk membuat setiap kartu item peminjaman
  Widget _buildItemCard(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Ikon di sebelah kiri
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF0D47A1).withOpacity(0.1),
              child: Icon(
                // Ganti ikon berdasarkan nama alat atau kategori
                item['namaAlat']!.contains('Proyektor') ? Icons.videocam : Icons.laptop_chromebook,
                color: const Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(width: 16),
            // Info Alat dan Peminjam
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['namaAlat']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Peminjam: ${item['peminjam']!}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            // Tanggal dan Tombol Detail
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['tanggal']!,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // TODO: Navigasi ke halaman detail peminjaman
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade300)
                    )
                  ),
                  child: const Text('Lihat Detail', style: TextStyle(fontSize: 12, color: Color(0xFF0D47A1))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
