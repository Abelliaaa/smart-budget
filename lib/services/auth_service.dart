// lib/services/auth_service.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase;
  late StreamSubscription<AuthState> _authStateSubscription;

  AuthService(this._supabase) {
    // Memulai listener saat service dibuat
    _listenToAuthState();
  }

  Session? _currentSession;

  bool get isLoggedIn => _currentSession != null;
  String? get userId => _currentSession?.user.id;

  void _listenToAuthState() {
    _authStateSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      _currentSession = data.session;
      // Memberi tahu router bahwa status login telah berubah
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }
}