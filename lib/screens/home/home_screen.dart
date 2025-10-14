import 'package:flutter/material.dart';
import '../../database/database.dart';
import '../home/dashboard_page.dart';
import '../profile/profile_screen.dart';
import '../add_transaction/add_transaction.dart';
import '../../widgets/navigation/persistent_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  final AppDatabase database;
  final String userId;

  const HomeScreen({
    super.key,
    required this.database,
    required this.userId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dashboardNavigatorKey = GlobalKey<NavigatorState>();
  final _addNavigatorKey = GlobalKey<NavigatorState>();
  final _profileNavigatorKey = GlobalKey<NavigatorState>();

  void _refreshDashboard() {
    setState(() {}); // buat dashboard reload setelah tambah transaksi
  }

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        // ===================== TAB BERANDA =====================
        PersistentTabItem(
          tab: const DashboardPage(),
          navigatorKey: _dashboardNavigatorKey,
          icon: Icons.home,
          title: 'Beranda',
        ),

        // ===================== TAB TAMBAH TRANSAKSI =====================
        PersistentTabItem(
          tab: AddTransactionPage(
            database: widget.database,
            userId: widget.userId,
            onTransactionAdded: _refreshDashboard,
          ),
          navigatorKey: _addNavigatorKey,
          icon: Icons.add_circle_outline,
          title: 'Tambah',
        ),

        // ===================== TAB PROFIL =====================
        PersistentTabItem(
          tab: const ProfileScreen(),
          navigatorKey: _profileNavigatorKey,
          icon: Icons.person,
          title: 'Profil',
        ),
      ],
    );
  }
}
