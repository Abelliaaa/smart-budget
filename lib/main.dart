// File: lib/routes/app_router.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/database.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';

// Screens
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/dashboard_page.dart';
import '../screens/add_transaction/add_transaction.dart';
import '../screens/home/category_detail_page.dart';
import '../screens/profile/edit_name_page.dart';
import '../screens/profile/edit_email_page.dart';

class AppRouter {
  final AppDatabase database;
  final AuthService authService;
  final SupabaseService supabaseService;

  AppRouter({
    required this.database,
    required this.authService,
    required this.supabaseService,
  });

  late final GoRouter router = GoRouter(
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
        builder: (context, state) => AuthScreen(
          database: database,
        ),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) {
          final user = Supabase.instance.client.auth.currentUser;
          if (user == null) {
            return AuthScreen(database: database);
          }

          return DashboardPage(
            database: database,
            userId: user.id,
          );
        },
      ),

      /// ➕ Tambah Transaksi
      GoRoute(
        path: '/add-transaction',
        pageBuilder: (context, state) {
          final userId = Supabase.instance.client.auth.currentUser!.id;

          final extra = state.extra as Map<String, dynamic>?;
          final VoidCallback onTransactionAdded =
              extra?['onTransactionAdded'] ?? () => context.pop();

          return MaterialPage(
            fullscreenDialog: true,
            child: AddTransactionPage(
              database: database,
              userId: userId,
              onTransactionAdded: onTransactionAdded,
            ),
          );
        },
      ),

      /// Detail Kategori
      GoRoute(
        path: '/category-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CategoryDetailPage(
            category: extra['category'],
            transactions: extra['transactions'],
            color: extra['color'],
            icon: extra['icon'],
          );
        },
      ),

      /// Edit Profil
      GoRoute(
        path: '/edit-name',
        builder: (context, state) => const EditNamePage(),
      ),
      GoRoute(
        path: '/edit-email',
        builder: (context, state) => const EditEmailPage(),
      ),
    ],

    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final loggedIn = session != null;
      final location = state.matchedLocation;

      final authRoutes = ['/auth', '/splash', '/onboarding'];

      if (!loggedIn && !authRoutes.contains(location)) {
        return '/auth';
      }

      if (loggedIn && authRoutes.contains(location)) {
        return '/home';
      }

      return null;
    },
  );
}

// Listener Supabase → GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;

  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
