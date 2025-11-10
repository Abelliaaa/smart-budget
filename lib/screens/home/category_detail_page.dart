import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart'; 
import '../../database/database.dart'; 

class CategoryDetailPage extends StatelessWidget {
  final String category;
  final List<Transaction> transactions;
  final Color color;
  final IconData icon;

  const CategoryDetailPage({
    super.key,
    required this.category,
    required this.transactions,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = transactions.fold<double>(0, (sum, item) => sum + item.amount);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // 1. Mengelompokkan transaksi berdasarkan tanggal (tanpa komponen waktu)
    final groupedTransactions = groupBy<Transaction, DateTime>(
      transactions,
      (transaction) => DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      ),
    );
    
    // 2. Ubah map menjadi daftar key (tanggal) yang sudah diurutkan (terbaru dulu)
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: const Color(0xFFFDECEC),
        elevation: 1,
        foregroundColor: Colors.black87,
        titleTextStyle: const 
        TextStyle(
          color: Colors.black87, 
          fontSize: 20,          
          fontWeight: FontWeight.bold, 
        ),
      ),
      body: Column(
        children: [
          // Header Ringkasan Kategori 
          Container(
            padding: const EdgeInsets.all(20.0),
            color: color.withOpacity(0.05),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total ${transactions.first.isIncome ? "Pemasukan" : "Pengeluaran"}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      currencyFormatter.format(totalAmount),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 1),

          // Daftar Detail Transaksi (Sekarang dikelompokkan)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: sortedDates.length, 
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final transactionsOnDate = groupedTransactions[date]!;

               
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Tanggal
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    // Daftar transaksi untuk tanggal tersebut
                    ...transactionsOnDate.map((transaction) {
                      return _TransactionDetailRow(transaction: transaction);
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk setiap baris detail transaksi
class _TransactionDetailRow extends StatelessWidget {
  final Transaction transaction;

  const _TransactionDetailRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final sign = transaction.isIncome ? '+' : '-';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Text(DateFormat('dd').format(transaction.date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(DateFormat('MMM').format(transaction.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Garis Vertikal
          Container(height: 40, width: 1, color: Colors.grey.shade300),
          const SizedBox(width: 12),
          
          // Kolom Catatan
          Expanded(
            child: Text(
              transaction.note != null && transaction.note!.isNotEmpty ? transaction.note! : 'Tidak ada catatan',
              style: TextStyle(
                color: transaction.note != null && transaction.note!.isNotEmpty ? Colors.black87 : Colors.grey,
                fontStyle: transaction.note != null && transaction.note!.isNotEmpty ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Kolom Nominal
          Text(
            '$sign ${currencyFormatter.format(transaction.amount)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}