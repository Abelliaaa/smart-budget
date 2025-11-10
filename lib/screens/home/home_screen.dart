import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../database/database.dart';
import 'dashboard_page.dart';
import '../profile/profile_screen.dart';

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
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(database: widget.database),
      ProfileScreen(database: widget.database),
    ];
  }
  
  void _onItemTapped(int index) {
    if (index == 1) { // Tombol "Tambah"
      context.push(
        '/add-transaction',
        extra: {
          'onTransactionAdded': () {
            setState(() {});
          },
        },
      );
    } else {
      setState(() {
        _selectedIndex = (index > 1) ? 1 : index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: (_selectedIndex >= 1) ? _selectedIndex + 1 : _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.brown,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 32),
            activeIcon: Icon(Icons.add_circle, size: 32),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}