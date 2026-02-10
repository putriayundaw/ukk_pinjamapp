import 'package:flutter/material.dart';
import '../../admin/widgets/stat_card.dart';
import '../../admin/widgets/overview_section.dart';

class HomeScreenPetugas extends StatelessWidget {
  const HomeScreenPetugas({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userInfo(),
          const SizedBox(height: 24),
          _statsGrid(),
          const SizedBox(height: 24),
          const OverviewSection(),
        ],
      ),
    );
  }

  Widget _userInfo() {
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
            Text('Selamat Pagi', style: TextStyle(color: Colors.grey)),
            Text(
              'PETUGAS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.1,
      children: [
        StatCard(title: 'Jumlah Alat', value: '108', color: Color(0xFFE8F5E9)),
        StatCard(title: 'Peminjam Aktif', value: '78', color: Color(0xFFFFF3E0)),
        StatCard(title: 'Pengembalian\nHari ini', value: '12', color: Color(0xFFF3E5F5)),
      ],
    );
  }
}
