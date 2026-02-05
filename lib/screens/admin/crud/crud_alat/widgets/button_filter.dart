import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;

  const FilterButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          iconColor: Colors.blue,
          side: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}