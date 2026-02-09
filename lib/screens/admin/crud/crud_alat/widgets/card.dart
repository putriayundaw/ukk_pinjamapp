// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../models/alat_models.dart';
// import '../../crud_kategori/models/kategori_models.dart';
// import '../update_alat.dart';

// class AlatCard extends StatelessWidget {
//   final AlatModel alat;
//   final String kategoriNama;
//   final VoidCallback onDelete;

//   const AlatCard({
//     super.key,
//     required this.alat,
//     required this.kategoriNama,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryBlue = Color(0xFF0D47A1);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 5))
//         ],
//       ),
//       child: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(15)),
//               child: Image.network(
//                 alat.imageUrl ?? 'https://via.placeholder.com/150',
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (c, e, s) => const Center(
//                     child: Icon(Icons.inventory_2_outlined,
//                         color: Colors.grey, size: 40)),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 6,
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(alat.namaAlat,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis),
//                       const SizedBox(height: 4),
//                       _buildInfoRow(Icons.category_outlined, kategoriNama),
//                       const SizedBox(height: 2),
//                       _buildInfoRow(
//                           Icons.inventory_2_outlined, 'Stok: ${alat.stok}'),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       _buildActionButton(
//                         icon: Icons.edit,
//                         label: 'Edit',
//                         isElevated: false,
//                         onPressed: () =>
//                             Get.to(() => UpdateAlat(alat: alat)),
//                       ),
//                       const SizedBox(width: 8),
//                       _buildActionButton(
//                         icon: Icons.delete,
//                         label: 'Hapus',
//                         isElevated: true,
//                         onPressed: onDelete,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text) => Row(
//         children: [
//           Icon(icon, color: Colors.grey, size: 16),
//           const SizedBox(width: 6),
//           Text(text,
//               style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         ],
//       );

//   Widget _buildActionButton(
//       {required IconData icon,
//       required String label,
//       required bool isElevated,
//       required VoidCallback onPressed}) {
//     const Color primaryBlue = Color(0xFF0D47A1);
//     return Expanded(
//       child: isElevated
//           ? ElevatedButton.icon(
//               onPressed: onPressed,
//               icon: Icon(icon, size: 16, color: Colors.white),
//               label: Text(label,
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red.shade700,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8)),
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//               ),
//             )
//           : OutlinedButton.icon(
//               onPressed: onPressed,
//               icon: Icon(icon, size: 16, color: primaryBlue),
//               label: Text(label,
//                   style: const TextStyle(
//                       color: primaryBlue, fontWeight: FontWeight.bold)),
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: primaryBlue, width: 1.5),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8)),
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//               ),
//             ),
//     );
//   }
// }
