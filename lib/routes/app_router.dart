import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import semua halaman yang akan digunakan
import '../database/database.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/splash/splash_screen.dart';

// 🔹 1. PERBAIKI PATH IMPORT
import '../screens/add_transaction/add_transaction.dart';
import '../screens/home/category_detail_page.dart';

class AppRouter {
  final AppDatabase database;

  AppRouter({required this.database});

  late final GoRouter router = GoRouter(
    // 🔹 2. GUNAKAN SUPABASE LANGSUNG UNTUK OTENTIKASI
    refreshListenable: GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    ),
    initialLocation: '/splash',
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
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final userId = Supabase.instance.client.auth.currentUser!.id;
          return HomeScreen(
            database: database,
            userId: userId,
          );
        },
        routes: [
          GoRoute(
            path: 'category-detail',
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return CategoryDetailPage(
                category: args['category'] as String,
                transactions: args['transactions'] as List<Transaction>,
                color: args['color'] as Color,
                icon: args['icon'] as IconData,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/add-transaction',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final userId = Supabase.instance.client.auth.currentUser!.id;
          return MaterialPage(
            fullscreenDialog: true,
            child: AddTransactionPage(
              database: database,
              userId: userId,
              onTransactionAdded: args['onTransactionAdded'] as VoidCallback,
            ),
          );
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = Supabase.instance.client.auth.currentSession != null;
      final location = state.matchedLocation;

      if (loggedIn && (location == '/splash' || location == '/onboarding' || location == '/auth')) {
        return '/home';
      }
      if (!loggedIn && (location.startsWith('/home') || location == '/add-transaction')) {
        return '/auth';
      }
      return null;
    },
  );
}

// Helper class untuk GoRouter refresh
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