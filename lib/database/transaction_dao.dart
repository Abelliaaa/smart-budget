// File: lib/database/transaction_dao.dart

import 'package:drift/drift.dart';
import 'database.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {

  TransactionDao(super.db);

  // =========================================================
  // 🔵 STREAM Semua transaksi user (untuk Dashboard)
  // =========================================================
  Stream<List<Transaction>> watchAllTransactionsForUser(String userId) {
    return (select(transactions)
          ..where((t) => t.supabaseUserId.equals(userId))
          ..orderBy([(t) => OrderingTerm.asc(t.tanggal)]))
        .watch();
  }

  // =========================================================
  // 🔵 STREAM dengan rentang tanggal
  // =========================================================
  Stream<List<Transaction>> watchTransactionsByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) {
    return (select(transactions)
          ..where((t) => t.supabaseUserId.equals(userId))
          ..where((t) => t.tanggal.isBetweenValues(start, end))
          ..orderBy([
            (t) => OrderingTerm.asc(t.tanggal),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  // =========================================================
  // 🔵 INSERT transaksi baru
  // =========================================================
  Future<int> insertTransaction(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }

  // =========================================================
  // 🔵 UPDATE transaksi
  // =========================================================
  Future<bool> updateTransaction(Transaction data) {
    return update(transactions).replace(data);
  }

  // =========================================================
  // 🔵 DELETE transaksi menggunakan transactionUid (string)
  // =========================================================
  Future<int> deleteTransaction(String transactionUid) {
    return (delete(transactions)
          ..where((t) => t.transactionUid.equals(transactionUid)))
        .go();
  }

  // =========================================================
  // 🔵 GET transaksi berdasarkan transactionUid
  // =========================================================
  Future<Transaction?> getByUid(String? uid) {
    if (uid == null) return Future.value(null);

    return (select(transactions)
          ..where((t) => t.transactionUid.equals(uid)))
        .getSingleOrNull();
  }

  // =========================================================
  // 🔵 Ambil semua transaksi user (untuk sync Cloud → Local)
  // =========================================================
  Future<List<Transaction>> getAllForUser(String userId) {
    return (select(transactions)
          ..where((t) => t.supabaseUserId.equals(userId))
          ..orderBy([(t) => OrderingTerm.asc(t.tanggal)]))
        .get();
  }

  // =========================================================
  // 🔵 Ambil transaksi yang belum ter-upload ke Supabase
  // =========================================================
  Future<List<Transaction>> getPendingUploads(String userId) {
    return (select(transactions)
          ..where((t) => t.supabaseUserId.equals(userId))
          ..where((t) => t.isUploaded.equals(false)))
        .get();
  }

  // =========================================================
  // 🔵 Update status isUploaded menjadi true/false
  // =========================================================
  Future<int> updateIsUploaded(String transactionUid, bool value) {
    return (update(transactions)
          ..where((t) => t.transactionUid.equals(transactionUid)))
        .write(
      TransactionsCompanion(
        isUploaded: Value(value),
      ),
    );
  }

  // =========================================================
  // 🔵 UPSERT: Sinkronisasi Cloud → Local
  // =========================================================
  Future<void> upsertFromCloud(Transaction cloudData) async {
    final txUid = cloudData.transactionUid;

    // Jika UID null → tidak valid → abaikan
    if (txUid == null || txUid.isEmpty) return;

    final local = await getByUid(txUid);

    if (local == null) {
      // Insert baru
      await into(transactions).insert(
        TransactionsCompanion(
          transactionUid: Value(txUid),
          supabaseUserId: Value(cloudData.supabaseUserId),
          kategori: Value(cloudData.kategori),
          nominal: Value(cloudData.nominal),
          tanggal: Value(cloudData.tanggal),
          isIncome: Value(cloudData.isIncome),
          catatan: Value(cloudData.catatan),
          buktiTransaksi: Value(cloudData.buktiTransaksi),
          isUploaded: const Value(true),
          updatedAt: Value(cloudData.updatedAt),
        ),
      );
    } else {
      // Update existing (gunakan copyWith + Value)
      await update(transactions).replace(
        local.copyWith(
          kategori: cloudData.kategori,
          nominal: cloudData.nominal,
          tanggal: cloudData.tanggal,
          isIncome: cloudData.isIncome,
          catatan: Value(cloudData.catatan),
          buktiTransaksi: Value(cloudData.buktiTransaksi),
          isUploaded: true,
          updatedAt: cloudData.updatedAt,
        ),
      );
    }
  }
}
