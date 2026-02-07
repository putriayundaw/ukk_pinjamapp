import 'package:flutter/material.dart';

class UserRoleFilter extends StatelessWidget {
  final int selectedRole;
  final Function(int) onChanged;

  const UserRoleFilter({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _button('Petugas', 0),
        const SizedBox(width: 10),
        _button('Peminjam', 1),
      ],
    );
  }

  Widget _button(String text, int index) {
    final isActive = selectedRole == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
