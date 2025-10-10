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

  // ... (method addTransaction dan getTransactionsForUser tetap ada)
  Future<List<Transaction>> getTransactionsForUser(String userId) {
    return (select(transactions)
          ..where((tbl) => tbl.supabaseUserId.equals(userId)))
        .get();
  }

  Future<int> addTransaction(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }

  Stream<List<Transaction>> watchAllTransactionsForUser(
      String userId, DateTime startDate, DateTime endDate) {
    return (select(transactions)
          ..where((tbl) =>
              tbl.supabaseUserId.equals(userId) &
              tbl.date.isBetween(Variable(startDate), Variable(endDate))))
        .watch();
  }

  // TAMBAHKAN METHOD INI
  Stream<List<Transaction>> watchTransactionsForUser(
      String userId, bool isIncome) {
    return (select(transactions)
          ..where((tbl) =>
              tbl.supabaseUserId.equals(userId) & tbl.isIncome.equals(isIncome))
          ..orderBy(
              [(t) => OrderingTerm.desc(t.date)])) // Urutkan dari yang terbaru
        .watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
