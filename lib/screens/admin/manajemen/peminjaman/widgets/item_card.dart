import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final Map<String, String> item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Ikon Kiri
            CircleAvatar(
              radius: 25,
              backgroundColor: primaryBlue.withOpacity(0.1),
              child: const Icon(Icons.laptop_chromebook, color: primaryBlue, size: 28),
            ),
            const SizedBox(width: 16),
            // Kolom Teks Tengah (Nama Alat & Peminjam)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['namaAlat']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Peminjam: ${item['peminjam']}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Kolom Kanan (Tanggal & Tombol Detail)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['tanggal']!,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 8),
                // Tombol "Lihat Detail"
                TextButton(
                  onPressed: () { /* TODO: Navigasi ke Halaman Detail */ },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: const Text('Lihat Detail', style: TextStyle(fontSize: 12, color: primaryBlue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
