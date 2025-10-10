import 'package:drift/drift.dart';

// Tabel untuk menyimpan data transaksi keuangan
@DataClassName('Transaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(min: 1)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isIncome => boolean()(); // True for income, false for expense

  // INI ADALAH KUNCINYA: Kolom untuk menyimpan ID unik dari Supabase
  TextColumn get supabaseUserId => text()();
}