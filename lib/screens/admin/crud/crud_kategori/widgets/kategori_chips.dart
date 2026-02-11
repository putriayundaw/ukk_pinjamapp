import 'package:flutter/material.dart';
import 'package:aplikasi_pinjam_ukk/utils/colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isAddButton;
  final VoidCallback onTap;

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
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        constraints: const BoxConstraints(
          minHeight: 44, // 🔥 bikin chip gak gepeng
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10, // 🔥 tinggi jelas
        ),
        decoration: BoxDecoration(
          color: isAddButton
              ? Colors.blue
              : isSelected
                  ? AppColors.Blue
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: isAddButton
              ? Border.all(color: Colors.blue)
              : Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isAddButton || isSelected
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
