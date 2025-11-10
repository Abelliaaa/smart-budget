// import 'dart:async';
// import 'package:flutter/material.dart'; // <-- Perbaikan di sini
// import 'package:go_router/go_router.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Setelah 2 detik, arahkan ke halaman onboarding
//     Timer(const Duration(seconds: 2), () {
//       if (mounted) {
//         // Menggunakan go_router untuk navigasi
//         context.go('/onboarding');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               color: Colors.brown,
//             ),
//             SizedBox(height: 20),
//             Text("Memuat..."),
//           ],
//         ),
//       ),
//     );
//   }
// }



// // lib/screens/splash/splash_screen.dart

// import 'package:flutter/material.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               color: Colors.brown,
//             ),
//             SizedBox(height: 20),
//             Text("Memuat..."),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print("--- [SPLASH] initState() dimulai. Akan memulai navigasi setelah delay. ---");
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Tunggu 2 detik untuk menampilkan splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Pastikan widget masih ada di tree sebelum navigasi
    if (!mounted) return;

    print("--- [SPLASH] Waktu tunggu selesai. Mencoba navigasi... ---");

    // Cek apakah onboarding sudah pernah dilihat
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (onboardingCompleted) {
      // Jika sudah, langsung ke halaman auth
      print("--- [SPLASH] Navigasi ke /auth ---");
      context.go('/auth');
    } else {
      // Jika belum, ke halaman onboarding
      print("--- [SPLASH] Navigasi ke /onboarding ---");
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("--- [SPLASH] UI sedang dibangun (build method). ---");
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.brown,
            ),
            SizedBox(height: 20),
            Text("Memuat..."),
          ],
        ),
      ),
    );
  }
}