import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? ElevatedButton(
            onPressed: onSelected,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF64B5F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
            ),
            child: Text(label, style: const TextStyle(color: Colors.white)),
          )
        : OutlinedButton(
            onPressed: onSelected,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          );
  }
}
