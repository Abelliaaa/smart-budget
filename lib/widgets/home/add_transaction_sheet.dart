import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../database/database.dart'; // Import database

class AddTransactionSheet extends StatefulWidget {
  final AppDatabase database;
  final String userId;
  final VoidCallback onTransactionAdded;

  const AddTransactionSheet(
      {super.key,
      required this.database,
      required this.userId,
      required this.onTransactionAdded});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = true;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan data ke Drift
  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final entry = TransactionsCompanion(
        description: drift.Value(_descriptionController.text),
        amount: drift.Value(double.parse(_amountController.text)),
        date: drift.Value(DateTime.now()),
        isIncome: drift.Value(_isIncome),
        supabaseUserId: drift.Value(widget.userId),
      );

      await widget.database.addTransaction(entry); // Simpan ke database

      if (mounted) {
        Navigator.of(context).pop(); // Tutup bottom sheet
        widget.onTransactionAdded(); // Panggil callback untuk refresh UI
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (UI form tetap sama, hanya fungsi _submitData yang diperbarui)
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Tambah Transaksi",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Simpan"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
