import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/alat_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_user/user_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/settings/settings_screen.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/widgets/navbar_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedIndex = 0;

  // List halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const Center(child: Text('semangat coooyy')),
    const UserScreen(),
     AlatScreen(),
        const SettingsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Ubah index yang dipilih
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],  // Menampilkan halaman sesuai index yang dipilih
      bottomNavigationBar: NavbarAdmin(
        selectedIndex: _selectedIndex,  // Kirim selectedIndex ke NavbarAdmin
        onItemTapped: _onItemTapped,   // Kirim fungsi onItemTapped ke NavbarAdmin
      ),
    );
  }
}
