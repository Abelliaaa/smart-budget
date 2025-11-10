import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:collection/collection.dart';

import '../../database/database.dart';
import 'category_detail_page.dart';

class DashboardPage extends StatefulWidget {
  final AppDatabase database;
  const DashboardPage({super.key, required this.database});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // State untuk dropdown
  late int _selectedYear;
  late int _selectedMonth;

  // Opsi untuk dropdown
  late List<int> _yearOptions;
  final List<String> _monthNames = [
    'Januari', 
    'Februari', 
    'Maret', 
    'April', 
    'Mei', 
    'Juni', 
    'Juli',
    'Agustus', 
    'September', 
    'Oktober', 
    'November', 
    'Desember',
  ];

  // State untuk query database
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    _yearOptions = List.generate(11, (index) => now.year - 5 + index);
    _selectedYear = now.year;
    _selectedMonth = now.month;
    _updateDateRange();
    
    Intl.defaultLocale = 'id_ID';
  }

  void _updateDateRange() {
    setState(() {
      _startDate = DateTime(_selectedYear, _selectedMonth, 1);
      _endDate = DateTime(_selectedYear, _selectedMonth + 1, 0, 23, 59, 59);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final userId = currentUser.id;
    final userName = currentUser.userMetadata?['name'] ?? 'Pengguna';

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "Hai, ${userName.split(' ').first}!",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: StreamBuilder<List<Transaction>>(
            stream: widget.database.watchAllTransactionsForUser(userId, _startDate, _endDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final transactions = snapshot.data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FinancialSummaryCard(
                    allTransactions: transactions,
                    yearOptions: _yearOptions,
                    monthNames: _monthNames,
                    selectedYear: _selectedYear,
                    selectedMonth: _selectedMonth,
                    onYearChanged: (newYear) {
                      if (newYear != null) {
                        setState(() {
                          _selectedYear = newYear;
                          _updateDateRange();
                        });
                      }
                    },
                    onMonthChanged: (newMonth) {
                      if (newMonth != null) {
                        setState(() {
                          _selectedMonth = newMonth;
                          _updateDateRange();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  _TransactionDetailsCard(allTransactions: transactions),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// --- WIDGET ---

class _FinancialSummaryCard extends StatelessWidget {
  final List<Transaction> allTransactions;
  final List<int> yearOptions;
  final List<String> monthNames;
  final int selectedYear;
  final int selectedMonth;
  final ValueChanged<int?> onYearChanged;
  final ValueChanged<int?> onMonthChanged;

  const _FinancialSummaryCard({
    required this.allTransactions,
    required this.yearOptions,
    required this.monthNames,
    required this.selectedYear,
    required this.selectedMonth,
    required this.onYearChanged,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double totalIncome = allTransactions.where((t) => t.isIncome).fold(0, (sum, item) => sum + item.amount);
    final double totalExpense = allTransactions.where((t) => !t.isIncome).fold(0, (sum, item) => sum + item.amount);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    Widget buildDropdown({
      required int value,
      required List<DropdownMenuItem<int>> items,
      required ValueChanged<int?> onChanged,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,
            menuMaxHeight: 200.0,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFFDECEC), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Rekapan Keuanganmu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 12),
          Column(
            children: [
              buildDropdown(
                value: selectedYear,
                items: yearOptions.map((year) {
                  return DropdownMenuItem(value: year, child: Text(year.toString()));
                }).toList(),
                onChanged: onYearChanged,
              ),
              const SizedBox(height: 12),
              buildDropdown(
                value: selectedMonth,
                items: List.generate(12, (index) {
                  return DropdownMenuItem(value: index + 1, child: Text(monthNames[index]));
                }),
                onChanged: onMonthChanged,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _IncomeExpenseWidget(title: "Pemasukan", amount: currencyFormatter.format(totalIncome), color: Colors.green),
              _IncomeExpenseWidget(title: "Pengeluaran", amount: currencyFormatter.format(totalExpense), color: Colors.red),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text("Selisih\n${currencyFormatter.format(totalIncome - totalExpense)}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, height: 1.3)),
            ),
          )
        ],
      ),
    );
  }
}

class _TransactionDetailsCard extends StatefulWidget {
  final List<Transaction> allTransactions;
  const _TransactionDetailsCard({required this.allTransactions});

  @override
  State<_TransactionDetailsCard> createState() => __TransactionDetailsCardState();
}

class __TransactionDetailsCardState extends State<_TransactionDetailsCard> {
  bool _isIncome = true;

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = widget.allTransactions.where((t) => t.isIncome == _isIncome).toList();
    
    Map<String, double> pieDataMap = {};
    if (filteredTransactions.isNotEmpty) {
      for (var transaction in filteredTransactions) {
        pieDataMap[transaction.description] = (pieDataMap[transaction.description] ?? 0) + transaction.amount;
      }
    } else {
      pieDataMap["Belum ada data"] = 1;
    }

    final groupedByCategory = groupBy(filteredTransactions, (Transaction t) => t.description);
    final sortedCategories = groupedByCategory.keys.toList();

    final Map<String, Color> categoryColors = { 
      "Gaji": const Color.fromARGB(255, 44, 122, 47), 
      "Investasi": const Color.fromARGB(255, 197, 219, 68), 
      "Tabungan": const Color.fromARGB(255, 15, 223, 29), 
      "Hadiah": const Color.fromARGB(255, 132, 233, 135), 
      "Kesehatan": const Color.fromARGB(255, 227, 125, 88), 
      "Makan & Minum": const Color.fromARGB(255, 212, 176, 57), 
      "Cicilan/sewa rumah": const Color.fromARGB(255, 255, 77, 22), 
      "Kendaraan": const Color.fromARGB(255, 255, 143, 7), 
      "Pendidikan": const Color.fromARGB(255, 224, 153, 94), 
      "Kebutuhan Pokok": const Color.fromARGB(255, 254, 83, 83), 
      "Pakaian": const Color.fromARGB(255, 225, 140, 109), 
      "Perawatan diri": const Color.fromARGB(255, 225, 120, 120), 
      "Hiburan": const Color.fromARGB(255, 245, 136, 132), 
      "Kouta/Internet": const Color.fromARGB(255, 255, 146, 139), 
      "Kebutuhan elektronik": const Color.fromARGB(255, 241, 139, 115), 
      "Pengeluaran sosial": const Color.fromARGB(255, 245, 136, 69), 
      "Lainnya": Colors.grey, };
      
    final Map<String, IconData> categoryIcons = { 
      "Gaji": Icons.wallet, 
      "Investasi": Icons.trending_up, 
      "Tabungan": Icons.savings, 
      "Hadiah": Icons.card_giftcard, 
      "Kesehatan": Icons.local_hospital, 
      "Makan & Minum": Icons.restaurant, 
      "Cicilan/sewa rumah": Icons.home, 
      "Kendaraan": Icons.directions_car, 
      "Pendidikan": Icons.school, 
      "Kebutuhan Pokok": Icons.shopping_basket, 
      "Pakaian": Icons.checkroom, 
      "Perawatan diri": Icons.spa, 
      "Hiburan": Icons.movie, 
      "Kouta/Internet": Icons.wifi, 
      "Kebutuhan elektronik": Icons.devices, 
      "Pengeluaran sosial": Icons.people, 
      "Lainnya": Icons.more_horiz, };

    return Card(
      elevation: 5,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFFDECEC),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _TransactionTypeSwitcher(
              isIncome: _isIncome,
              onIncomeTap: () => setState(() => _isIncome = true),
              onExpenseTap: () => setState(() => _isIncome = false),
            ),
            const SizedBox(height: 24),
            
            if (pieDataMap.isNotEmpty && pieDataMap.keys.first != "Belum ada data")
              PieChart(
                dataMap: pieDataMap, animationDuration: const Duration(milliseconds: 800), chartLegendSpacing: 42,
                chartRadius: MediaQuery.of(context).size.width / 3.2, chartType: ChartType.ring, ringStrokeWidth: 32,
                colorList: pieDataMap.keys.map((key) => categoryColors[key] ?? Colors.grey).toList(),
                legendOptions: const LegendOptions( showLegends: true, legendPosition: LegendPosition.right, legendTextStyle: TextStyle(fontWeight: FontWeight.bold),),
                chartValuesOptions: const ChartValuesOptions( showChartValueBackground: false, showChartValuesInPercentage: true,),
              )
            else
              const SizedBox(height: 150, child: Center(child: Text("Data chart tidak tersedia."))),
            const SizedBox(height: 24),
            const Divider(),

            if (filteredTransactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text("Belum ada data ${_isIncome ? 'pemasukan' : 'pengeluaran'}."),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedCategories.length,
                itemBuilder: (context, index) {
                  final category = sortedCategories[index];
                  final transactionsInCategory = groupedByCategory[category]!;
                  
                  return _CategoryGroupTile(
                    category: category,
                    transactions: transactionsInCategory,
                    color: categoryColors[category] ?? Colors.grey,
                    icon: categoryIcons[category] ?? Icons.category,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}


class _CategoryGroupTile extends StatelessWidget {
  final String category;
  final List<Transaction> transactions;
  final Color color;
  final IconData icon;

  const _CategoryGroupTile({
    required this.category,
    required this.transactions,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = transactions.fold<double>(0, (sum, item) => sum + item.amount);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final sign = transactions.first.isIncome ? '+' : '-';

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell( // <-- Menggunakan InkWell agar bisa di-tap
        onTap: () {
          // Aksi untuk navigasi ke halaman detail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailPage(
                category: category,
                transactions: transactions,
                color: color,
                icon: icon,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(
                      '${transactions.length} Transaksi',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                '$sign ${currencyFormatter.format(totalAmount)}',
                style: TextStyle(fontWeight: FontWeight.bold, color: transactions.first.isIncome ? Colors.green : Colors.red),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey), // Indikator panah
            ],
          ),
        ),
      ),
    );
  }
}

// Widget lainnya (_IncomeExpenseWidget, _TransactionTypeSwitcher) tidak berubah
class _IncomeExpenseWidget extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const _IncomeExpenseWidget({
    required this.title, 
    required this.amount, 
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 4),
        Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
      ],
    );
  }
}

class _TransactionTypeSwitcher extends StatelessWidget {
  final bool isIncome;
  final VoidCallback onIncomeTap;
  final VoidCallback onExpenseTap;

  const _TransactionTypeSwitcher({
    required this.isIncome, 
    required this.onIncomeTap, 
    required this.onExpenseTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onIncomeTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(color: isIncome ? Colors.green : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                child: Center(child: Text("Pemasukan", style: TextStyle(fontWeight: FontWeight.bold, color: isIncome ? Colors.white : Colors.black54))),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onExpenseTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(color: !isIncome ? Colors.red : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                child: Center(child: Text("Pengeluaran", style: TextStyle(fontWeight: FontWeight.bold, color: !isIncome ? Colors.white : Colors.black54))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

