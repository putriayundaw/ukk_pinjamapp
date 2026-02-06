import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_user/user_screen.dart';
import 'package:flutter/material.dart';

// Pastikan path import ini sudah benar sesuai struktur proyek Anda.
// Jika file-file ini belum ada, Flutter akan memberikan error.
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/alat_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/settings/settings_screen.dart';
// import 'package:aplikasi_pinjam_ukk/screens/admin/widgets/navbar_admin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Definisikan warna utama untuk tema
    const Color primaryBlue = Color(0xFF0D47A1);

    return MaterialApp(
      title: 'Dashboard Admin',
      theme: ThemeData(
        // Menggunakan swatch akan membuat warna lain (seperti splash) konsisten
        primarySwatch: Colors.blue, 
        scaffoldBackgroundColor: const Color(0xFFFDFDFD), // Latar belakang putih bersih
        fontFamily: 'Poppins',
        // Definisikan warna utama untuk BottomNavigationBar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: primaryBlue,
        ),
      ),
      home: const DashboardAdmin(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// === WIDGET UTAMA ANDA UNTUK NAVIGASI ===
class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedIndex = 0;

  // List halaman diubah untuk memasukkan HomeScreenContent di index pertama
  static final List<Widget> _pages = <Widget>[
    const HomeScreenContent(), // UI Dashboard utama Anda
    const UserScreen(), // Halaman daftar user
    AlatScreen(), // Halaman daftar alat
    const Center(child: Text('Halaman Manajemen')), // Placeholder untuk Manajemen
    const SettingsScreen(), // Halaman pengaturan
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(
            color: Color(0xFF333333), // Warna Teks Hitam
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Transparan agar menyatu dengan body
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        // `selectedItemColor` sudah diatur di `ThemeData`
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Manajemen'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}


// === KONTEN UNTUK HALAMAN HOME (DASHBOARD) - VERSI DISEMPURNAKAN ===
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          const SizedBox(height: 24),
          _buildStatsGrid(),
          const SizedBox(height: 24),
          _buildActivityLog(),
          const SizedBox(height: 24),
          _buildOverviewSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return const Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Pagi',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'admin@gmail.com',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.1,
      children: const [
        _StatCard(title: 'Total User', value: '20', color: Color(0xFFE3F2FD)),
        _StatCard(title: 'Jumlah Alat', value: '108', color: Color(0xFFE8F5E9)),
        _StatCard(title: 'Peminjam Aktif', value: '78', color: Color(0xFFFFF3E0)),
        _StatCard(title: 'Pengembalian\nHari ini', value: '12', color: Color(0xFFF3E5F5)),
      ],
    );
  }

  Widget _buildActivityLog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Log Aktifitas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('senin 17 januari 2026 - 19 januari 2026', style: TextStyle(fontSize: 15)),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection() {
    const Color primaryBlue = Color(0xFF0D47A1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ToggleButtons(
                isSelected: const [true, false, false],
                onPressed: (index) { /* Logika untuk mengubah tab */ },
                borderRadius: BorderRadius.circular(20),
                selectedColor: Colors.white,
                color: Colors.grey.shade600,
                fillColor: primaryBlue,
                splashColor: primaryBlue.withOpacity(0.12),
                hoverColor: primaryBlue.withOpacity(0.04),
                constraints: const BoxConstraints(minHeight: 35.0, minWidth: 60.0),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Today')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Weekly')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Month')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        _buildChart(),
      ],
    );
  }

  Widget _buildChart() {
    final List<double> data = [90, 95, 35, 25, 65, 20, 55];
    final List<String> days = ['Mon\nday', 'Tues\nday', 'Wednes\nday', 'Thurs\nday', 'Fri\nday', 'Satur\nday', 'Sun\nday'];
    const Color primaryBlue = Color(0xFF0D47A1);
    const double barWidth = 22.0;

    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                    Container(
                      width: barWidth,
                      height: (data[index] / 100) * 160,
                      decoration: const BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                days[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// === WIDGET KARTU STATISTIK - VERSI DISEMPURNAKAN ===
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
