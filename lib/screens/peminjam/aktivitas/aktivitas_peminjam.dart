import 'package:aplikasi_pinjam_ukk/screens/peminjam/aktivitas/widgets/cars_aktivity.dart';
import 'package:aplikasi_pinjam_ukk/screens/peminjam/aktivitas/widgets/filter_chip_widget.dart';
import 'package:flutter/material.dart';

class AktivitasPeminjam extends StatelessWidget {
  const AktivitasPeminjam({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Aktivitas Saya',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Kolom Pencarian
              TextField(
                decoration: InputDecoration(
                  hintText: '',
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Filter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  FilterChipWidget(label: 'disetujui', isSelected: true),
                  FilterChipWidget(label: 'menunggu'),
                  FilterChipWidget(label: 'ditolak'),
                ],
              ),
              const SizedBox(height: 24),

              // Kartu Aktivitas
              const ActivityCardWidget(
                name: 'Putri Ayunda',
                item: 'Monitor Ketua',
                date: '22 Jan - 25 Jan',
                status: 'dipinjam',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
