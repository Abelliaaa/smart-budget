// File: lib/screens/add_transaction/add_transaction.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:uuid/uuid.dart';
import '../../database/database.dart';

class AddTransactionPage extends StatefulWidget {
  final AppDatabase database;
  final String userId;
  final VoidCallback onTransactionAdded;

  const AddTransactionPage({
    super.key,
    required this.database,
    required this.userId,
    required this.onTransactionAdded,
  });

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _formatter = NumberFormat.decimalPattern('id');
  final _uuid = const Uuid();

  bool _isIncome = true;
  String? _selectedCategory;

  DateTime _selectedDate = DateTime.now();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);

    _amountController.addListener(() {
      final raw = _amountController.text.replaceAll('.', '');
      if (raw.isEmpty) return;

      final num = int.tryParse(raw);
      if (num == null) return;

      final formatted = _formatter.format(num);

      if (_amountController.text != formatted) {
        _amountController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _pickImage(ImageSource src) async {
    final XFile? picked = await _picker.pickImage(source: src);

    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Kamera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galeri"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTransaction() async {
    if (_selectedCategory == null || _amountController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi kategori dan nominal")),
      );
      return;
    }

    final rawNominal = _amountController.text.replaceAll('.', '');
    final nominalValue = int.tryParse(rawNominal);

    if (nominalValue == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nominal tidak valid")),
      );
      return;
    }

    final entry = TransactionsCompanion(
      transactionUid: drift.Value(_uuid.v4()),
      supabaseUserId: drift.Value(widget.userId),
      kategori: drift.Value(_selectedCategory!),
      nominal: drift.Value(nominalValue),
      tanggal: drift.Value(_selectedDate),
      isIncome: drift.Value(_isIncome),
      catatan: drift.Value(
        _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      ),
      buktiTransaksi: drift.Value(_imageFile?.path),
      isUploaded: const drift.Value(false), // INI YANG DIGUNAKAN UNTUK SYNC
    );

    try {
      await widget.database.transactionDao.insertTransaction(entry);

      widget.onTransactionAdded();

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaksi berhasil disimpan!")),
      );
    } catch (e) {
      log("Local insert error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan transaksi: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _isIncome
        ? ["Gaji", "Investasi", "Tabungan", "Hadiah", "Lainnya"]
        : [
            "Kesehatan",
            "Makan & Minum",
            "Rumah",
            "Kendaraan",
            "Pendidikan",
            "Kebutuhan pokok",
            "Pakaian",
            "Perawatan diri",
            "Hiburan",
            "Internet",
            "Elektronik",
            "Sosial",
            "Hadiah",
            "Lainnya"
          ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Transaksi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Switch Income/Expense
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    selected: _isIncome,
                    label: const Text("Pemasukan"),
                    onSelected: (_) => setState(() => _isIncome = true),
                  ),
                ),
                Expanded(
                  child: ChoiceChip(
                    selected: !_isIncome,
                    label: const Text("Pengeluaran"),
                    onSelected: (_) => setState(() => _isIncome = false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Categories
            Wrap(
              spacing: 8,
              children: categories.map((c) {
                final selected = c == _selectedCategory;
                return ChoiceChip(
                  selected: selected,
                  label: Text(c),
                  onSelected: (_) => setState(() => _selectedCategory = c),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Nominal
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: "Nominal",
                prefixIcon: Icon(Icons.money),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            // Catatan
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Catatan",
                prefixIcon: Icon(Icons.notes),
              ),
            ),

            const SizedBox(height: 20),

            // Date Picker
            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Tanggal",
                    prefixIcon: const Icon(Icons.calendar_today),
                    hintText: DateFormat("dd MMM yyyy").format(_selectedDate),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bukti
            GestureDetector(
              onTap: _showImagePicker,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Bukti Transaksi",
                    prefixIcon: const Icon(Icons.attach_file),
                    hintText: _imageFile != null
                        ? _imageFile!.path.split('/').last
                        : "",
                  ),
                ),
              ),
            ),

            if (_imageFile != null) ...[
              const SizedBox(height: 10),
              Image.file(_imageFile!, height: 150),
            ],

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Simpan", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
