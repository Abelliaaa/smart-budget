import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Menambah satu transaksi baru
  Future<int> addTransaction(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }

  // Mengambil semua transaksi untuk user tertentu 
  Future<List<Transaction>> getTransactionsForUser(String userId) {
    return (select(transactions)
          ..where((tbl) => tbl.supabaseUserId.equals(userId)))
        .get();
  }
  
  // Mengawasi semua transaksi untuk user dalam rentang tanggal
  Stream<List<Transaction>> watchAllTransactionsForUser(
      String userId, DateTime startDate, DateTime endDate) {
    return (select(transactions)
          ..where((tbl) =>
              tbl.supabaseUserId.equals(userId) &
              tbl.date.isBetween(Variable(startDate), Variable(endDate))))
        .watch();
  }

  // Mengawasi transaksi (pemasukan/pengeluaran) untuk user
  Stream<List<Transaction>> watchTransactionsForUser(
      String userId, bool isIncome) {
    return (select(transactions)
          ..where((tbl) =>
              tbl.supabaseUserId.equals(userId) & tbl.isIncome.equals(isIncome))
          ..orderBy(
              [(t) => OrderingTerm.desc(t.date)])) // Urutkan dari yang terbaru
        .watch();
  }

  Stream<double> watchTotalIncome(String userId, DateTime startDate, DateTime endDate) {
    final amount = transactions.amount;
    final query = select(transactions)
      ..where((tbl) => tbl.supabaseUserId.equals(userId))
      ..where((tbl) => tbl.isIncome.equals(true))
      ..where((tbl) => tbl.date.isBetween(Variable(startDate), Variable(endDate)));
      
    // Menjumlahkan semua nilai 'amount' dari baris yang cocok
    return query.map((row) => row.amount).watch().map((amounts) => amounts.fold(0.0, (prev, curr) => prev + curr));
  }

  Stream<double> watchTotalExpense(String userId, DateTime startDate, DateTime endDate) {
    final amount = transactions.amount;
    final query = select(transactions)
      ..where((tbl) => tbl.supabaseUserId.equals(userId))
      ..where((tbl) => tbl.isIncome.equals(false))
      ..where((tbl) => tbl.date.isBetween(Variable(startDate), Variable(endDate)));
      
    // Menjumlahkan semua nilai 'amount' dari baris yang cocok
    return query.map((row) => row.amount).watch().map((amounts) => amounts.fold(0.0, (prev, curr) => prev + curr));
  }

  Stream<List<Transaction>> watchRecentTransactions(String userId, int limit) {
    final query = select(transactions)
      ..where((tbl) => tbl.supabaseUserId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
      ..limit(limit);
      
    return query.watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}