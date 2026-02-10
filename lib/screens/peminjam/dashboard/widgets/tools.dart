import 'package:flutter/material.dart';

class ToolCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onAdd; // callback saat tombol "Tambah" ditekan

  const ToolCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: onAdd, // pakai callback dari parent
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Tambah', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
