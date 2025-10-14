// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:pie_chart/pie_chart.dart';

// import '../../database/database.dart';
// // import '../../widgets/home/add_transaction_sheet.dart';

// // Dapatkan instance database untuk digunakan di halaman ini
// final AppDatabase database = AppDatabase();

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   final String userId = Supabase.instance.client.auth.currentUser!.id;
 
//   final List<String> _monthNames = [
//    'Januari',
//     'Februari',
//     'Maret',
//     'April',
//     'Mei',
//     'Juni',
//     'Juli',
//     'Agustus',
//     'September',
//     'Oktober',
//     'November',
//     'Desember', 
//   ];

//   late String _selectedPeriod;
//   late DateTime _startDate;
//   late DateTime _endDate;

//   @override
//   void initState() {
//     super.initState();
//     final now = DateTime.now();
//     _selectedPeriod = _monthNames[now.month - 1];
//     _updateDateRange();
//   }

//   void _updateDateRange() {
//     final now = DateTime.now();
//     final monthIndex = _monthNames.indexOf(_selectedPeriod);
//     final year = now.year;
//     final month = (monthIndex != -1) ? monthIndex + 1 : now.month;

//     _startDate = DateTime(year, month, 1);
//     _endDate = DateTime(year, month + 1, 0, 23, 59, 59);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userName = Supabase.instance.client.auth.currentUser?.userMetadata?['name'] ?? 'Pengguna';
    
//     return Scaffold(
//     appBar: AppBar(
//       title: Padding(
//         padding: const EdgeInsets.only(top: 10.0), // 🔹 atur nilai top sesuai selera
//         child: Text(
//          "Hai, ${userName.split(' ').first}!",
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       elevation: 0,
//     ),


//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//           child: StreamBuilder<List<Transaction>>(
//             stream: database.watchAllTransactionsForUser(userId, _startDate, _endDate),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               final transactions = snapshot.data ?? [];
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _FinancialSummaryCard(
//                     allTransactions: transactions,
//                     selectedPeriod: _selectedPeriod,
//                     onPeriodChanged: (newPeriod) {
//                       if (newPeriod != null) {
//                         setState(() {
//                           _selectedPeriod = newPeriod;
//                           _updateDateRange();
//                         });
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 24),
//                   _TransactionDetailsCard(allTransactions: transactions),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- SEMUA WIDGET PENDUKUNG ---

// class _FinancialSummaryCard extends StatelessWidget {
//   final List<Transaction> allTransactions;
//   final String selectedPeriod;
//   final ValueChanged<String?> onPeriodChanged;

//   const _FinancialSummaryCard({
//     required this.allTransactions,
//     required this.selectedPeriod,
//     required this.onPeriodChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final double totalIncome = allTransactions.where((t) => t.isIncome).fold(0, (sum, item) => sum + item.amount);
//     final double totalExpense = allTransactions.where((t) => !t.isIncome).fold(0, (sum, item) => sum + item.amount);
//     final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: const Color(0xFFFDECEC), borderRadius: BorderRadius.circular(20)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Rekapan Keuanganmu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: selectedPeriod,
//                 isExpanded: true,
//                 items: <String>['Bulan Kemarin', 'Bulan Ini', 'Bulan Depan'].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)));
//                 }).toList(),
//                 onChanged: onPeriodChanged,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _IncomeExpenseWidget(title: "Pemasukan", amount: currencyFormatter.format(totalIncome), color: Colors.green),
//               _IncomeExpenseWidget(title: "Pengeluaran", amount: currencyFormatter.format(totalExpense), color: Colors.red),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Center(
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.brown,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               ),
//               child: Text("Selisih\n${currencyFormatter.format(totalIncome - totalExpense)}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, height: 1.3)),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class _TransactionDetailsCard extends StatefulWidget {
//   final List<Transaction> allTransactions;
//   const _TransactionDetailsCard({required this.allTransactions});
//   @override
//   State<_TransactionDetailsCard> createState() => __TransactionDetailsCardState();
// }

// class __TransactionDetailsCardState extends State<_TransactionDetailsCard> {
//   bool _isIncome = true;
//   @override
//   Widget build(BuildContext context) {
//     final filteredTransactions = widget.allTransactions.where((t) => t.isIncome == _isIncome).toList();
//     Map<String, double> pieDataMap = {};
//     if (filteredTransactions.isNotEmpty) {
//       for (var transaction in filteredTransactions) {
//         pieDataMap[transaction.description] = (pieDataMap[transaction.description] ?? 0) + transaction.amount;
//       }
//     } else {
//       pieDataMap["Belum ada data"] = 1;
//     }
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withAlpha(25), blurRadius: 10, offset: const Offset(0, 5))]),
//       child: Column(
//         children: [
//           _TransactionTypeSwitcher(isIncome: _isIncome, onIncomeTap: () => setState(() => _isIncome = true), onExpenseTap: () => setState(() => _isIncome = false)),
//           const SizedBox(height: 24),
//           if (pieDataMap.isNotEmpty && pieDataMap.keys.first != "Belum ada data")
//             PieChart(
//               dataMap: pieDataMap,
//               animationDuration: const Duration(milliseconds: 800),
//               chartLegendSpacing: 42,
//               chartRadius: MediaQuery.of(context).size.width / 3.2,
//               chartType: ChartType.ring,
//               ringStrokeWidth: 32,
//               legendOptions: const LegendOptions(showLegends: true, legendPosition: LegendPosition.right, legendTextStyle: TextStyle(fontWeight: FontWeight.bold)),
//               chartValuesOptions: const ChartValuesOptions(showChartValueBackground: false, showChartValuesInPercentage: true),
//             )
//           else 
//             const SizedBox(height: 150, child: Center(child: Text("Data chart tidak tersedia."))),
//           const SizedBox(height: 24),
//           const Divider(),
//           if (filteredTransactions.isEmpty)
//             Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Text("Belum ada data ${_isIncome ? 'pemasukan' : 'pengeluaran'}.")))
//           else
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: filteredTransactions.length,
//               itemBuilder: (context, index) {
//                 final transaction = filteredTransactions[index];
//                 final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
//                 return _TransactionListItem(
//                   icon: transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
//                   category: transaction.description,
//                   amount: "${transaction.isIncome ? '+' : '-'} ${currencyFormatter.format(transaction.amount)}",
//                   color: transaction.isIncome ? Colors.green : Colors.red,
//                   iconBgColor: (transaction.isIncome ? Colors.green : Colors.red).withAlpha(25),
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _IncomeExpenseWidget extends StatelessWidget {
//   final String title;
//   final String amount;
//   final Color color;
//   const _IncomeExpenseWidget({required this.title, required this.amount, required this.color});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(title, style: const TextStyle(color: Colors.black54)),
//         const SizedBox(height: 4),
//         Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
//       ],
//     );
//   }
// }

// class _TransactionTypeSwitcher extends StatelessWidget {
//   final bool isIncome;
//   final VoidCallback onIncomeTap;
//   final VoidCallback onExpenseTap;
//   const _TransactionTypeSwitcher({required this.isIncome, required this.onIncomeTap, required this.onExpenseTap});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
//       child: Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: onIncomeTap,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 decoration: BoxDecoration(color: isIncome ? Colors.green : Colors.transparent, borderRadius: BorderRadius.circular(20)),
//                 child: Center(child: Text("Pemasukan", style: TextStyle(fontWeight: FontWeight.bold, color: isIncome ? Colors.white : Colors.black54))),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: onExpenseTap,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 decoration: BoxDecoration(color: !isIncome ? Colors.red : Colors.transparent, borderRadius: BorderRadius.circular(20)),
//                 child: Center(child: Text("Pengeluaran", style: TextStyle(fontWeight: FontWeight.bold, color: !isIncome ? Colors.white : Colors.black54))),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TransactionListItem extends StatelessWidget {
//   final IconData icon;
//   final String category;
//   final String amount;
//   final Color color;
//   final Color iconBgColor;
//   const _TransactionListItem({required this.icon, required this.category, required this.amount, required this.color, required this.iconBgColor});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(12)),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Text(category, style: const TextStyle(fontWeight: FontWeight.w600)),
//           const Spacer(),
//           Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
//           const SizedBox(width: 8),
//           const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../database/database.dart';

// Instance database
final AppDatabase database = AppDatabase();

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final String userId = Supabase.instance.client.auth.currentUser!.id;

  // 🔹 Daftar nama bulan
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

  late String _selectedPeriod;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedPeriod = _monthNames[now.month - 1]; // otomatis bulan sekarang
    _updateDateRange();
  }

  // 🔹 Update rentang tanggal sesuai bulan yang dipilih
  void _updateDateRange() {
    final now = DateTime.now();
    final monthIndex = _monthNames.indexOf(_selectedPeriod);
    final year = now.year;
    final month = (monthIndex != -1) ? monthIndex + 1 : now.month;

    _startDate = DateTime(year, month, 1);
    _endDate = DateTime(year, month + 1, 0, 23, 59, 59);
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        Supabase.instance.client.auth.currentUser?.userMetadata?['name'] ??
            'Pengguna';

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
            stream: database.watchAllTransactionsForUser(
                userId, _startDate, _endDate),
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
                    selectedPeriod: _selectedPeriod,
                    onPeriodChanged: (newPeriod) {
                      if (newPeriod != null) {
                        setState(() {
                          _selectedPeriod = newPeriod;
                          _updateDateRange();
                        });
                      }
                    },
                    monthNames: _monthNames, // 👈 tambahkan ini
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

// --- SEMUA WIDGET PENDUKUNG ---

class _FinancialSummaryCard extends StatelessWidget {
  final List<Transaction> allTransactions;
  final String selectedPeriod;
  final ValueChanged<String?> onPeriodChanged;
  final List<String> monthNames;

  const _FinancialSummaryCard({
    required this.allTransactions,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.monthNames,
  });

  @override
  Widget build(BuildContext context) {
    final double totalIncome = allTransactions
        .where((t) => t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);
    final double totalExpense = allTransactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);

    final currencyFormatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rekapan Keuanganmu",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedPeriod,
                isExpanded: true,
                items: monthNames
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ))
                    .toList(),
                onChanged: onPeriodChanged,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _IncomeExpenseWidget(
                  title: "Pemasukan",
                  amount: currencyFormatter.format(totalIncome),
                  color: Colors.green),
              _IncomeExpenseWidget(
                  title: "Pengeluaran",
                  amount: currencyFormatter.format(totalExpense),
                  color: Colors.red),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                "Selisih\n${currencyFormatter.format(totalIncome - totalExpense)}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, height: 1.3),
              ),
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
  State<_TransactionDetailsCard> createState() =>
      __TransactionDetailsCardState();
}

class __TransactionDetailsCardState extends State<_TransactionDetailsCard> {
  bool _isIncome = true;

  @override
  Widget build(BuildContext context) {
    final filteredTransactions =
        widget.allTransactions.where((t) => t.isIncome == _isIncome).toList();

    Map<String, double> pieDataMap = {};
    if (filteredTransactions.isNotEmpty) {
      for (var transaction in filteredTransactions) {
        pieDataMap[transaction.description] =
            (pieDataMap[transaction.description] ?? 0) + transaction.amount;
      }
    } else {
      pieDataMap["Belum ada data"] = 1;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
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
              dataMap: pieDataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 42,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              legendOptions: const LegendOptions(
                  showLegends: true,
                  legendPosition: LegendPosition.right,
                  legendTextStyle: TextStyle(fontWeight: FontWeight.bold)),
              chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValuesInPercentage: true),
            )
          else
            const SizedBox(
                height: 150,
                child: Center(child: Text("Data chart tidak tersedia."))),
          const SizedBox(height: 24),
          const Divider(),
          if (filteredTransactions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                    "Belum ada data ${_isIncome ? 'pemasukan' : 'pengeluaran'}."),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                final currencyFormatter = NumberFormat.currency(
                    locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
                return _TransactionListItem(
                  icon: transaction.isIncome
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  category: transaction.description,
                  amount:
                      "${transaction.isIncome ? '+' : '-'} ${currencyFormatter.format(transaction.amount)}",
                  color: transaction.isIncome ? Colors.green : Colors.red,
                  iconBgColor:
                      (transaction.isIncome ? Colors.green : Colors.red)
                          .withAlpha(25),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _IncomeExpenseWidget extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  const _IncomeExpenseWidget(
      {required this.title, required this.amount, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 4),
        Text(amount,
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
      ],
    );
  }
}

class _TransactionTypeSwitcher extends StatelessWidget {
  final bool isIncome;
  final VoidCallback onIncomeTap;
  final VoidCallback onExpenseTap;
  const _TransactionTypeSwitcher(
      {required this.isIncome,
      required this.onIncomeTap,
      required this.onExpenseTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onIncomeTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    color: isIncome ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text("Pemasukan",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isIncome ? Colors.white : Colors.black54))),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onExpenseTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    color: !isIncome ? Colors.red : Colors.transparent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text("Pengeluaran",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                !isIncome ? Colors.white : Colors.black54))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionListItem extends StatelessWidget {
  final IconData icon;
  final String category;
  final String amount;
  final Color color;
  final Color iconBgColor;
  const _TransactionListItem(
      {required this.icon,
      required this.category,
      required this.amount,
      required this.color,
      required this.iconBgColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: iconBgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(category, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(amount,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
