// File: lib/database/tables.dart
import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  // UUID global untuk identifikasi lintas-device / cloud
  TextColumn get transactionUid => text().nullable().unique()();

  DateTimeColumn get tanggal => dateTime()();

  TextColumn get kategori => text()();
  BoolColumn get isIncome => boolean()();
  TextColumn get catatan => text().nullable()();

  IntColumn get nominal => integer()();

  TextColumn get buktiTransaksi => text().nullable()();

  // user id dari Supabase (auth.users.id)
  TextColumn get supabaseUserId => text()();

  // Tandai sudah ter-upload ke Supabase
  BoolColumn get isUploaded => boolean().withDefault(const Constant(false))();

  // Waktu updated lokal terakhir (digunakan merge resolution)
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
