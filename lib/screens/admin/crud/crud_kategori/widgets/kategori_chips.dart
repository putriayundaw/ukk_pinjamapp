import 'package:flutter/material.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isAddButton;
  final VoidCallback onTap; // ini required

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.isAddButton = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // wajib diisi saat pemanggilan
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isAddButton
              ? Colors.blue
              : isSelected
                  ? AppColors.Blue
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: isAddButton ? Border.all(color: Colors.blue) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isAddButton
                  ? Colors.white
                  : isSelected
                      ? Colors.white
                      : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
