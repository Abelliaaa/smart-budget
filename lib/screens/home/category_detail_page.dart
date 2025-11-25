// File: lib/screens/home/category_detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'dart:io'; // 🔑 WAJIB: Untuk memuat File gambar
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

  Color _withAlpha(Color color, double opacity) {
    return color.withAlpha((255 * opacity).round());
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final totalAmount =
        transactions.fold<int>(0, (sum, item) => sum + item.nominal);

    final groupedTransactions = groupBy<Transaction, DateTime>(
      transactions,
      (transaction) => transaction.tanggal,
    );

    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: _withAlpha(color, 0.2), 
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // ✅ Header Ringkasan
          Container(
            padding: const EdgeInsets.all(20),
            color: _withAlpha(color, 0.10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _withAlpha(color, 0.20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Transaksi",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      currencyFormatter.format(totalAmount),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Divider(height: 1),

          // ✅ List Transaksi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final transactionsOnDate = groupedTransactions[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Header tanggal
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Text(
                        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    ...transactionsOnDate.map(
                      (transaction) => _TransactionDetailRow(
                        transaction: transaction,
                        color: color,
                      ),
                    )
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

// ------------------------------------------------------------------
// WIDGET DETAIL ROW TRANSAKSI
// ------------------------------------------------------------------

class _TransactionDetailRow extends StatelessWidget {
  final Transaction transaction;
  final Color color;

  const _TransactionDetailRow({
    required this.transaction,
    required this.color,
  });

  // Fungsi untuk menampilkan gambar saat ikon diklik
  void _showImageDialog(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Bukti Transaksi"),
        content: path.toLowerCase().endsWith('.pdf') 
            ? const Text("File PDF tidak didukung untuk pratinjau.")
            : Image.file(
                File(path), // Memuat gambar dari path lokal
                fit: BoxFit.contain,
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final date = transaction.tanggal; 
    final hasAttachment = transaction.buktiTransaksi?.isNotEmpty == true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Hari & Bulan
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Text(
                  DateFormat('dd').format(date),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  DateFormat('MMM').format(date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
          Container(height: 40, width: 1, color: Colors.grey.shade300),
          const SizedBox(width: 12),

          // 🔑 AREA EXPANDED: Catatan dan Ikon Lampiran
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Text Catatan Utama
                Text(
                  transaction.catatan?.isNotEmpty == true
                      ? transaction.catatan!
                      : 'Tidak ada catatan',
                  style: TextStyle(
                    color: transaction.catatan?.isNotEmpty == true ? Colors.black87 : Colors.grey,
                    fontStyle: transaction.catatan?.isNotEmpty == true ? FontStyle.normal : FontStyle.italic,
                    fontWeight: FontWeight.bold, 
                  ),
                ),
                
                // 2. Ikon Lampiran (Hanya jika ada path)
                if (hasAttachment)
                  GestureDetector(
                    onTap: () => _showImageDialog(context, transaction.buktiTransaksi!),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🔑 Ikon Baru (Receipt/Struk)
                          Icon(
                            Icons.receipt_long, 
                            size: 16, 
                            color: Colors.brown.shade400, 
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Lihat Bukti",
                            style: TextStyle(
                              fontSize: 13, 
                              color: Colors.brown, 
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ✅ Jumlah uang (pakai nominal)
          Text(
            currencyFormatter.format(transaction.nominal),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}