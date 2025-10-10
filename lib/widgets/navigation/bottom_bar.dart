// import 'package:flutter/material.dart';

// class CustomBottomBar extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   const CustomBottomBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       shape: const CircularNotchedRectangle(),
//       notchMargin: 8.0,
//       child: SizedBox(
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             // Tombol Home
//             IconButton(
//               icon: Icon(
//                 Icons.home,
//                 color: currentIndex == 0 ? Colors.brown : Colors.grey,
//               ),
//               onPressed: () => onTap(0), // Kirim event tap dengan indeks 0
//             ),

//             const SizedBox(width: 40), // Spacer untuk FloatingActionButton

//             // Tombol Profile
//             IconButton(
//               icon: Icon(
//                 Icons.person,
//                 color: currentIndex == 1 ? Colors.brown : Colors.grey,
//               ),
//               onPressed: () => onTap(1), // Kirim event tap dengan indeks 1
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
