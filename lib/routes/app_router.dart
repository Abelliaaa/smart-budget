// File: lib/routes/app_router.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import semua halaman yang digunakan
import '../database/database.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/splash/splash_screen.dart';

import '../screens/add_transaction/add_transaction.dart';
import '../screens/home/category_detail_page.dart';
import '../screens/profile/edit_name_page.dart';
import '../screens/profile/edit_email_page.dart';


class AppRouter {
  final AppDatabase database; 

  AppRouter({required this.database});

  late final GoRouter router = GoRouter(
    // 🔑 FIX: Mengganti 'refreshListable' menjadi 'refreshListENable'
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

      // 🔄 Route Home
      GoRoute(
        path: '/home',
        builder: (context, state) {
          String? userId = Supabase.instance.client.auth.currentUser?.id;
          
          if (state.extra is Map<String, dynamic>) {
            final extra = state.extra as Map<String, dynamic>;
            final db = extra['database'] as AppDatabase;
            userId = extra['userId'] as String;
            
            return HomeScreen(
              database: db,
              userId: userId,
            );
          }

          if (userId == null) {
            return AuthScreen(database: database); 
          }

          return HomeScreen(
            database: database, 
            userId: userId, 
          );
        },
      ),

      /// Route Tambah Transaksi
      GoRoute(
        path: '/add-transaction',
        pageBuilder: (context, state) {
          final userId = Supabase.instance.client.auth.currentUser!.id;

          final extra = state.extra as Map<String, dynamic>?;
          final VoidCallback onTransactionAdded = extra?['onTransactionAdded'] ?? () => context.pop();

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

      // Route Detail Kategori 
      GoRoute(
        path: '/category-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CategoryDetailPage(
            category: extra['category'] as String,
            transactions: extra['transactions'] as List<Transaction>,
            color: extra['color'] as Color,
            icon: extra['icon'] as IconData,
          );
        },
      ),

      // RUTE PROFIL BARU
      GoRoute(
        path: '/edit-name',
        pageBuilder: (context, state) {
          return const MaterialPage(
            fullscreenDialog: false,
            child: EditNamePage(), 
          );
        },
      ),

      GoRoute(
        path: '/edit-email',
        pageBuilder: (context, state) {
          return const MaterialPage(
            fullscreenDialog: false,
            child: EditEmailPage(), 
          );
        },
      ),
    ],

    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn =
          Supabase.instance.client.auth.currentSession != null;
      final location = state.matchedLocation;

      final isAuthRoute = location == '/auth' || location == '/splash' || location == '/onboarding';

      if (loggedIn && isAuthRoute) {
        return '/home';
      }

      if (!loggedIn && !isAuthRoute) {
        return '/auth';
      }

      return null;
    },
  );
}

// Helper class untuk listen event auth Supabase
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