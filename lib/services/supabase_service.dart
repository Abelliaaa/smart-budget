// File: lib/services/supabase_service.dart

import 'dart:developer';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../database/database.dart';
import 'supabase_client.dart';

class SupabaseService {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Uuid _uuid = const Uuid();

  static const String transactionsTable = 'transactions';
  static const String avatarBucket = 'avatars';

  SupabaseService(this._db) : _supabase = SupabaseClientService.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  // =====================================================
  // UPLOAD PROFILE IMAGE
  // =====================================================
  Future<String?> uploadProfileImage(File imageFile) async {
    final userId = currentUserId;
    if (userId == null) throw Exception("Not logged in");

    final ext = imageFile.path.split('.').last;
    final filePath = "profile/$userId/avatar_${_uuid.v4()}.$ext";

    try {
      await _supabase.storage.from(avatarBucket).upload(
        filePath,
        imageFile,
      );

      // SDK always returns String URL
      final publicUrl =
          _supabase.storage.from(avatarBucket).getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      log("UPLOAD ERROR: $e");
      rethrow;
    }
  }

  // =====================================================
  // SIGN OUT
  // =====================================================
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // =====================================================
  // SYNC ON LOGIN → CLOUD → LOCAL
  // =====================================================
  Future<void> syncOnLogin() async {
    final userId = currentUserId;
    if (userId == null) return;

    final rows = await _supabase
        .from(transactionsTable)
        .select()
        .eq("user_id", userId);

    for (final raw in rows) {
      try {
        final cloudTx = Transaction.fromJson(
          Map<String, dynamic>.from(raw),
        );

        await _db.transactionDao.upsertFromCloud(cloudTx);
      } catch (e) {
        log("SYNC (CLOUD→LOCAL) ERROR: $e");
      }
    }

    await pushPendingToCloud(userId);
  }

  // =====================================================
  // PUSH LOCAL UNSYNCED → CLOUD
  // =====================================================
  Future<void> pushPendingToCloud(String userId) async {
    final pending = await _db.transactionDao.getPendingUploads(userId);

    for (final t in pending) {
      final uid = (t.transactionUid?.isNotEmpty ?? false)
          ? t.transactionUid!
          : _uuid.v4();

      final payload = {
        'transaction_uid': uid,
        'user_id': userId,
        'tanggal': t.tanggal.toIso8601String(),
        'kategori': t.kategori,
        'is_income': t.isIncome,
        'catatan': t.catatan,
        'nominal': t.nominal,
        'bukti_transaksi': t.buktiTransaksi,
        'updated_at': t.updatedAt.toIso8601String(),
      };

      try {
        await _supabase.from(transactionsTable).upsert(payload);

        // Update local: set uploaded
        await _db.transactionDao.updateIsUploaded(uid, true);
      } catch (e) {
        log("PUSH ERROR: $e");
      }
    }
  }
}
