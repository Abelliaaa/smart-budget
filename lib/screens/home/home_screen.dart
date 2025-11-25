// File: lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer';
import '../../database/database.dart';
import '../../services/supabase_service.dart';
import 'dashboard_page.dart';
import '../profile/profile_page.dart';

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
  late final SupabaseService _supabaseService;

  bool _isSyncing = true;

  @override
  void initState() {
    super.initState();

    _supabaseService = SupabaseService(widget.database);

    _pages = [
      DashboardPage(
        database: widget.database,
        userId: widget.userId,
      ),
      ProfilePage(
        database: widget.database,
      ),
    ];

    _initialSync();
  }

  // =============================
  // 🔥 SYNC BARU — menggunakan syncOnLogin()
  // =============================
  Future<void> _initialSync() async {
    log("▶ Memulai sinkronisasi (syncOnLogin) untuk user: ${widget.userId}");

    try {
      await _supabaseService.syncOnLogin();
      log("✅ Sinkronisasi awal selesai.");
    } catch (e) {
      log("❌ Gagal syncOnLogin: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal sinkronisasi data: $e")),
        );
      }
    }

    if (mounted) {
      setState(() => _isSyncing = false);
    }
  }

  // =============================
  // 🔥 HANDLER BOTTOM NAV
  // =============================
  void _onItemTapped(int index) {
    if (index == 1) {
      context.push(
        '/add-transaction',
        extra: {
          'onTransactionAdded': () {
            if (mounted) setState(() {});
          },
          'userId': widget.userId,
          'database': widget.database,
        },
      );
    } else {
      setState(() {
        _selectedIndex = (index == 2) ? 1 : index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSyncing) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.brown),
              SizedBox(height: 12),
              Text("Sinkronisasi data dari Cloud…"),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex == 1 ? 2 : _selectedIndex,
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
      ),
    );
  }
}
