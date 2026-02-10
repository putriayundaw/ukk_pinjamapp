import 'package:aplikasi_pinjam_ukk/screens/admin/settings/settings_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/dashboard/home_peminjam.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/aktivitas/aktivitas_peminjam.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/setting/peminjam.dart';
import 'package:aplikasi_pinjam_ukk/screens/petugas/pengajuan/pengajuan.dart';
import 'package:flutter/material.dart';

class DashboardPeminjam extends StatefulWidget {
  const DashboardPeminjam({super.key}
  );

  @override
  State<DashboardPeminjam> createState() => _DashboardPeminjamState();
}

class _DashboardPeminjamState extends State<DashboardPeminjam> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
       HomePeminjam(),
       AktivitasPeminjam(),
       PeminjamSetting(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text(
                'Dashboard Peminjam',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'History'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.article), label: 'Manajemen'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
