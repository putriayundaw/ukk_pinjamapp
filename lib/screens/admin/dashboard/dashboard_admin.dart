
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/alat_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_kategori/kategori_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_user/user_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/dashboard/home_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/manajemen_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/settings/settings_screen.dart';
import 'package:flutter/material.dart';



class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
       HomeScreenContent(),
       UserScreen(),
       AlatScreen(),
       ManajemenScreen(),
       SettingsScreen(),
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
                'Dashboard Admin',
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
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Alat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article), label: 'Manajemen'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
