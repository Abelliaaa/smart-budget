import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
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
  final _formatter = NumberFormat.decimalPattern('id'); // 🔹 Formatter untuk IDR

  // Memilih tipe transaksi
  bool _isIncome = true;
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  // Listener untuk format IDR otomatis
  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      final text = _amountController.text.replaceAll('.', '');
      if (text.isEmpty) return;
      final number = int.tryParse(text);
      if (number == null) return;

      final formatted = _formatter.format(number);
      if (_amountController.text != formatted) {
        final selectionIndex = formatted.length;
        _amountController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: selectionIndex),
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

  // 🔹 Fungsi pilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: "Pilih Tanggal Transaksi",
      locale: const Locale('id', 'ID'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 🔹 Fungsi bantu ubah tanggal jadi teks (format Indonesia)
  String _formatDate(DateTime date) {
    const bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return "${date.day} ${bulan[date.month - 1]} ${date.year}";
  }

  // Simpan transaksi ke Drift
  Future<void> _submitData() async {
    if (_selectedCategory == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi kategori dan nominal")),
      );
      return;
    }

    // Hapus titik agar bisa dikonversi ke double
    final cleanedAmount = _amountController.text.replaceAll('.', '');

    final entry = TransactionsCompanion(
      description: drift.Value(_selectedCategory!),
      note: drift.Value(_descriptionController.text),
      amount: drift.Value(double.parse(cleanedAmount)),
      date: drift.Value(_selectedDate),
      isIncome: drift.Value(_isIncome),
      supabaseUserId: drift.Value(widget.userId),
    );

    await widget.database.addTransaction(entry);

    _descriptionController.clear();
    _amountController.clear();
    setState(() {
      _selectedCategory = null;
      _isIncome = false;
      _selectedDate = DateTime.now();
    });

    widget.onTransactionAdded();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaksi berhasil disimpan")),
    );
  }

  // 🔹 Daftar kategori
  final List<Map<String, dynamic>> expenseCategories = [
    {"name": "Kesehatan", "icon": Icons.local_hospital},
    {"name": "Makan & Minum", "icon": Icons.restaurant},
    {"name": "Cicilan/sewa rumah", "icon": Icons.home},
    {"name": "Kendaraan", "icon": Icons.directions_car},
    {"name": "Pendidikan", "icon": Icons.school},
    {"name": "Kebutuhan pokok", "icon": Icons.shopping_basket},
    {"name": "Pakaian", "icon": Icons.checkroom},
    {"name": "Perawatan diri", "icon": Icons.spa},
    {"name": "Hiburan", "icon": Icons.movie},
    {"name": "Kuota/Internet", "icon": Icons.wifi},
    {"name": "Kebutuhan elektronik", "icon": Icons.devices},
    {"name": "Pengeluaran sosial", "icon": Icons.people},
    {"name": "Hadiah", "icon": Icons.card_giftcard},
    {"name": "Lainnya", "icon": Icons.more_horiz},
  ];

  final List<Map<String, dynamic>> incomeCategories = [
    {"name": "Gaji", "icon": Icons.wallet},
    {"name": "Investasi", "icon": Icons.trending_up},
    {"name": "Tabungan", "icon": Icons.savings},
    {"name": "Hadiah", "icon": Icons.card_giftcard},
    {"name": "Lainnya", "icon": Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    final categories = _isIncome ? incomeCategories : expenseCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambahkan Transaksi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFDECEC),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔹 SWITCH PEMASUKAN / PENGELUARAN
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isIncome = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isIncome ? Colors.brown : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Pemasukan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isIncome ? Colors.white : Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isIncome = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isIncome ? Colors.brown : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Pengeluaran",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isIncome ? Colors.white : Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // GRID KATEGORI
            Card(
              color: const Color(0xFFFDECEC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = _selectedCategory == category["name"];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category["name"];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.brown[200]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(category["icon"],
                                color: isSelected
                                    ? Colors.white
                                    : Colors.brown),
                            const SizedBox(height: 5),
                            Text(
                              category["name"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            // FORM CATATAN & NOMINAL
            Card(
              color: const Color(0xFFFDECEC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          locale: const Locale('id', 'ID'),
                          helpText: "Pilih Tanggal Transaksi",
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: TextEditingController(
                              text: _formatDate(_selectedDate)),
                          decoration: const InputDecoration(
                            labelText: "Tanggal Transaksi",
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Catatan",
                        prefixIcon: Icon(Icons.notes),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Nominal",
                        prefixIcon: Icon(Icons.money),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // TOMBOL SIMPAN
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Simpan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

