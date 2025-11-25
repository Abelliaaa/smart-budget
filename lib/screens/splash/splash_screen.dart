import 'dart:async';
import 'dart:developer'; // 🔑 Import untuk logging yang benar
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
    // ✅ Mengganti print() dengan log()
    log("--- [SPLASH] initState() dimulai. Akan memulai navigasi setelah delay. ---", name: 'SPLASH');
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Tunggu 2 detik untuk menampilkan splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Pastikan widget masih ada di tree sebelum navigasi
    if (!mounted) return;

    // ✅ Mengganti print() dengan log()
    log("--- [SPLASH] Waktu tunggu selesai. Mencoba navigasi... ---", name: 'SPLASH');

    // Cek apakah onboarding sudah pernah dilihat
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (onboardingCompleted) {
      // Jika sudah, langsung ke halaman auth
      log("--- [SPLASH] Navigasi ke /auth ---", name: 'SPLASH');
      context.go('/auth');
    } else {
      // Jika belum, ke halaman onboarding
      log("--- [SPLASH] Navigasi ke /onboarding ---", name: 'SPLASH');
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Mengganti print() dengan log()
    log("--- [SPLASH] UI sedang dibangun (build method). ---", name: 'SPLASH');
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