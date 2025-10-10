// import 'dart:async'; // <-- PERBAIKAN DI SINI
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../screens/auth/auth_screen.dart';
// import '../screens/home/home_screen.dart';
// import '../screens/onboarding/onboarding_screen.dart';
// import '../screens/splash/splash_screen.dart';

// class AppRouter {
//   static final router = GoRouter(
//     refreshListenable: GoRouterRefreshStream(
//       Supabase.instance.client.auth.onAuthStateChange,
//     ),
//     initialLocation: '/splash',
//     routes: [
//       GoRoute(
//         path: '/splash',
//         builder: (context, state) => const SplashScreen(),
//       ),
//       GoRoute(
//         path: '/onboarding',
//         builder: (context, state) => const OnboardingScreen(),
//       ),
//       GoRoute(
//         path: '/auth',
//         pageBuilder: (context, state) => const MaterialPage(
//           fullscreenDialog: true,
//           child: AuthScreen(),
//         ),
//       ),
//       GoRoute(
//         path: '/home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//     ],
//     redirect: (BuildContext context, GoRouterState state) {
//       final bool isLoggedIn =
//           Supabase.instance.client.auth.currentSession != null;
//       final String location = state.matchedLocation;

//       if (!isLoggedIn &&
//           location != '/splash' &&
//           location != '/onboarding' &&
//           location != '/auth') {
//         // Jika belum login, paksa ke onboarding (yang akan lanjut ke auth)
//         return '/onboarding';
//       }
//       if (isLoggedIn &&
//           (location == '/splash' ||
//               location == '/onboarding' ||
//               location == '/auth')) {
//         // Jika sudah login dan masih di halaman publik, paksa ke home
//         return '/home';
//       }

//       // Jika tidak ada kondisi di atas, biarkan
//       return null;
//     },
//   );
// }

// // Class bantuan untuk membuat GoRouter mendengarkan stream Supabase
// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<dynamic> stream) {
//     notifyListeners();
//     _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
//   }

//   late final StreamSubscription<dynamic> _subscription;

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import semua halaman yang akan digunakan dalam navigasi
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/splash/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    // GoRouter akan "mendengarkan" setiap perubahan status login dari Supabase
    refreshListenable: GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    ),

    // Halaman awal saat aplikasi pertama kali dibuka
    initialLocation: '/splash',

    // Daftar semua rute/halaman yang ada di aplikasi
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
        // Menampilkan halaman login sebagai lapisan terpisah untuk mencegah "stuck"
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: AuthScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        // Setelah login, arahkan ke HomeScreen yang berisi navigasi persisten
        builder: (context, state) => const HomeScreen(),
      ),
    ],

    // Logika untuk mengalihkan pengguna berdasarkan status login
    redirect: (BuildContext context, GoRouterState state) {
      final bool isLoggedIn =
          Supabase.instance.client.auth.currentSession != null;
      final String location = state.matchedLocation;

      // Jika belum login dan mencoba mengakses halaman selain halaman publik,
      // arahkan ke halaman onboarding.
      if (!isLoggedIn &&
          location != '/splash' &&
          location != '/onboarding' &&
          location != '/auth') {
        return '/onboarding';
      }

      // Jika sudah login dan masih berada di halaman publik (splash/onboarding/auth),
      // arahkan langsung ke halaman utama.
      if (isLoggedIn &&
          (location == '/splash' ||
              location == '/onboarding' ||
              location == '/auth')) {
        return '/home';
      }

      // Jika tidak ada kondisi di atas, biarkan pengguna tetap di halamannya.
      return null;
    },
  );
}

// Class bantuan untuk membuat GoRouter mendengarkan stream dari Supabase
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
