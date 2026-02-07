import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/overview_section.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

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
          _activityLog(),
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
              'admin@gmail.com',
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
      children: const [
        StatCard(title: 'Total User', value: '20', color: Color(0xFFE3F2FD)),
        StatCard(title: 'Jumlah Alat', value: '108', color: Color(0xFFE8F5E9)),
        StatCard(title: 'Peminjam Aktif', value: '78', color: Color(0xFFFFF3E0)),
        StatCard(title: 'Pengembalian\nHari ini', value: '12', color: Color(0xFFF3E5F5)),
      ],
    );
  }

  Widget _activityLog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Log Aktifitas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('senin 17 januari 2026 - 19 januari 2026'),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
