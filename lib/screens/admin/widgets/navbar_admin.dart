import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:flutter/material.dart';

class NavbarAdmin extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NavbarAdmin({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.Blue,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Icons.propane_tank_rounded), label: 'Alat'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
