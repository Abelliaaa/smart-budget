// lib/services/auth_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase;          // client supabase
  final SupabaseService _supabaseService;  // service untuk sync
  late final StreamSubscription<AuthState> _authSubscription;
  Session? _session;

  AuthService(
    this._supabase,
    this._supabaseService,
  ) {
    _listenToAuthState();
  }

  // GETTERS
  Session? get session => _session;
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // ============================================================
  // 🔊 LISTEN SUPABASE AUTH EVENTS
  // ============================================================
  void _listenToAuthState() {
    _authSubscription = _supabase.auth.onAuthStateChange.listen(
      (AuthState state) async {
        _session = state.session;
        notifyListeners();

        // Jika user LOGIN
        if (_session != null) {
          try {
            await _supabaseService.syncOnLogin();
          } catch (e) {
            debugPrint('[AuthService] syncOnLogin ERROR → $e');
          }
        }
      },
      onError: (error) {
        debugPrint('[AuthService] ERROR on auth stream → $error');
      },
    );
  }

  // ============================================================
  // 🔌 DISPOSE LISTENER
  // ============================================================
  @override
  void dispose() {
    try {
      _authSubscription.cancel();
    } catch (_) {
      // Just in case stream already closed
    }
    super.dispose();
  }
}
