import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/peminjaman/peminjaman.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/manajemen/pengembalian/pengembalian.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';
import 'package:flutter/material.dart';

class ManajemenScreen extends StatefulWidget {
  const ManajemenScreen({super.key});

  @override
  _ManajemenScreenState createState() => _ManajemenScreenState();
}

class _ManajemenScreenState extends State<ManajemenScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.Blue),),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Peminjaman'),
              Tab(text: 'Pengembalian'),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            PeminjamanScreen(),
            PengembalianScreen(),
          ],
        ),
      ),
    );
  }
}
