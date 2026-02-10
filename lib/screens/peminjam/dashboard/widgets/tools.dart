import 'package:aplikasi_pinjam_ukk/controller/alat_controller.dart';
import 'package:aplikasi_pinjam_ukk/screens/admin/crud/crud_alat/models/alat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToolCard extends StatefulWidget {
  final AlatModel alat;
  final AlatController alatC;
  final String imageUrl;
  final String title;

  const ToolCard({
    super.key,
    required this.alat,
    required this.alatC,
    required this.imageUrl,
    required this.title,
  });

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard> {
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
              child: (widget.imageUrl == null || widget.imageUrl!.isEmpty)
                  ? Icon(Icons.build, size: 50, color: Colors.grey)
                  : Image.network(widget.imageUrl!, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(() {
              final qty = widget.alatC.selectedAlatMap[widget.alat.alatId!] ?? 0;
              if (qty == 0) {
                return ElevatedButton(
                  onPressed: () {
                    widget.alatC.selectedAlatMap[widget.alat.alatId!] = 1;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Tambah', style: TextStyle(color: Colors.white)),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (qty > 1) {
                          widget.alatC.selectedAlatMap[widget.alat.alatId!] = qty - 1;
                        } else {
                          widget.alatC.selectedAlatMap.remove(widget.alat.alatId!);
                        }
                      },
                      icon: const Icon(Icons.remove, color: Colors.red),
                    ),
                    Text('$qty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () {
                        widget.alatC.selectedAlatMap[widget.alat.alatId!] = qty + 1;
                      },
                      icon: const Icon(Icons.add, color: Colors.green),
                    ),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
