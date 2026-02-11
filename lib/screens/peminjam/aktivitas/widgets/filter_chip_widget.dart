import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final String selectedFilter;
  final VoidCallback onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedFilter == label;

    Color chipColor;

    switch (label) {
      case 'menunggu persetujuan':
        chipColor = Colors.orange;
        break;
      case 'disetujui':
        chipColor = Colors.green;
        break;
      case 'selesai':
        chipColor = Colors.blue;
        break;
      default:
        chipColor = Colors.grey;
    }

    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
