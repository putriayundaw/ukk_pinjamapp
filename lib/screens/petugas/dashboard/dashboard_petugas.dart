import 'package:aplikasi_pinjam_ukk/screens/petugas/pemantau.dart';
import 'package:aplikasi_pinjam_ukk/screens/petugas/persetujuan.dart';
import 'package:aplikasi_pinjam_ukk/screens/petugas/settings/petugas_set.dart';
import 'package:flutter/material.dart';
import 'home_screen_petugas.dart';

class DashboardPetugas extends StatefulWidget {
  const DashboardPetugas({super.key});

  @override
  State<DashboardPetugas> createState() => _DashboardPetugasState();
}

class _DashboardPetugasState extends State<DashboardPetugas> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreenPetugas(),
      PemantauPage(),
      PersetujuanPage(),
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
                'Dashboard Petugas',
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
          BottomNavigationBarItem(icon: Icon(Icons.visibility), label: 'Pemantau'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Persetujuan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
