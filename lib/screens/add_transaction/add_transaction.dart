import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../database/database.dart'; // Sesuaikan path jika perlu

class AddTransactionPage extends StatefulWidget {
  final AppDatabase database;
  final String userId;
  final VoidCallback onTransactionAdded;

  AddTransactionPage({
    super.key,
    required this.database,
    required this.userId,
    required this.onTransactionAdded,
  });

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = false; // Default ke Pengeluaran

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final entry = TransactionsCompanion(
        description: drift.Value(_descriptionController.text),
        amount: drift.Value(double.parse(_amountController.text)),
        date: drift.Value(DateTime.now()),
        isIncome: drift.Value(_isIncome),
        supabaseUserId: drift.Value(widget.userId),
      );

      await widget.database.addTransaction(entry);

      if (mounted) {
        // Kembali ke halaman sebelumnya setelah data disimpan
        Navigator.of(context).pop();
        widget.onTransactionAdded();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dibungkus dengan Scaffold untuk menjadi halaman penuh
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Transaksi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        // Tombol kembali akan muncul secara otomatis
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Deskripsi"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukkan angka yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Pengeluaran"),
                    Switch(
                      value: _isIncome,
                      onChanged: (newValue) {
                        setState(() {
                          _isIncome = newValue;
                        });
                      },
                    ),
                    const Text("Pemasukan"),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white),
                  child: const Text("Simpan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}