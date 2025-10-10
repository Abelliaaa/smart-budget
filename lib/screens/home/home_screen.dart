import 'package:flutter/material.dart';
import 'package:smart_budget/widgets/navigation/persistent_bottom_bar.dart';
import 'package:smart_budget/screens/home/dashboard_page.dart';
import 'package:smart_budget/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Setiap tab membutuhkan GlobalKey untuk menjaga state navigasinya
  final _dashboardNavigatorKey = GlobalKey<NavigatorState>();
  final _profileNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        // Tab "Home" akan menampilkan konten dari DashboardPage
        PersistentTabItem(
          tab: const DashboardPage(),
          navigatorKey: _dashboardNavigatorKey,
          icon: Icons.home,
          title: 'Beranda',
        ),
        // Tab "Profil" akan menampilkan konten dari ProfileScreen
        PersistentTabItem(
          tab: const ProfileScreen(),
          navigatorKey: _profileNavigatorKey,
          icon: Icons.add,
          title: 'Tambah',
        ),
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
