// File: lib/database/database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// TABLE definitions
import 'tables.dart';
export 'tables.dart';

// DAO
import 'transaction_dao.dart';

part 'database.g.dart';

/// Database utama aplikasi
@DriftDatabase(
  tables: [Transactions],
  daos: [TransactionDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Naikkan jika ada perubahan table
  @override
  int get schemaVersion => 2;

  /// Migration Drift modern (masih sama)
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(transactions, transactions.transactionUid);
            await m.addColumn(transactions, transactions.supabaseUserId);
            await m.addColumn(transactions, transactions.isUploaded);
            await m.addColumn(transactions, transactions.updatedAt);
          }
        },
      );
}

/// Connection Drift terbaru
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'smart_budget.sqlite'));

    // Drift Native database modern
    return NativeDatabase.createInBackground(
      file,
      logStatements: false,
    );
  });
}
