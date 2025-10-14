import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import semua halaman 
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../database/database.dart'; 

class AppRouter {
  static final router = GoRouter(
    refreshListenable: GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    ),

    // Halaman awal ketika aplikasi dibuka
    initialLocation: '/splash',

    // Daftar semua rute aplikasi
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: AuthScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          // Inisialisasi database Drift
          final database = AppDatabase();

          // Ambil user
          final user = Supabase.instance.client.auth.currentUser;
          final userId = user?.id ?? '';

          // Kirim parameter ke HomeScreen
          return HomeScreen(
            database: database,
            userId: userId,
          );
        },
      ),
    ],

    // Logika redirect otomatis
    redirect: (BuildContext context, GoRouterState state) {
      final bool isLoggedIn =
          Supabase.instance.client.auth.currentSession != null;
      final String location = state.matchedLocation;

      // Jika belum login dan bukan di halaman publik
      if (!isLoggedIn &&
          location != '/splash' &&
          location != '/onboarding' &&
          location != '/auth') {
        return '/onboarding';
      }

      // Jika sudah login dan masih di halaman publik
      if (isLoggedIn &&
          (location == '/splash' ||
              location == '/onboarding' ||
              location == '/auth')) {
        return '/home';
      }

      // Tidak ada redirect, tetap di halaman sekarang
      return null;
    },
  );
}

// Class bantuan agar GoRouter otomatis update
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
