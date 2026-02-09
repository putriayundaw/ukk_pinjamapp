// import 'package:flutter/material.dart';

// class _CategoryChip extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final bool isAddButton;  // Add this to differentiate add button
//   final VoidCallback onTap;

//   const _CategoryChip({
//     super.key,
//     required this.label,
//     required this.isSelected,
//     this.isAddButton = false,  // Default to false
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryBlue = Color(0xFF0D47A1);
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(right: 10),
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           color: isAddButton
//               ? Colors.green.shade100 // Add different color for 'Add' button
//               : isSelected
//                   ? primaryBlue
//                   : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(20),
//           border: isAddButton ? Border.all(color: Colors.green.shade300) : null,
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: TextStyle(
//               color: isAddButton
//                   ? Colors.green.shade800  // Text color for add button
//                   : isSelected
//                       ? Colors.white
//                       : Colors.black87,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
