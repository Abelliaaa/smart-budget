// File: lib/screens/auth/auth_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart'; // Wajib untuk context.go
import '../../services/supabase_client.dart';
import '../../services/supabase_service.dart'; // Import service untuk sinkronisasi
import '../../database/database.dart'; // Import database
import '../../widgets/auth/auth_tab_switcher.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  final AppDatabase database; // ✅ Menerima instance database

  const AuthScreen({super.key, required this.database});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool _loading = false;
  bool _isSyncing = false; 
  String _loadingText = "Masuk";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final supabase = SupabaseClientService.client;
  late final SupabaseService _supabaseService; 

  @override
  void initState() {
    super.initState();
    // Inisialisasi service
    _supabaseService = SupabaseService(widget.database);
  }

  Future<void> _handleAuth() async {
    setState(() {
      _loading = true;
      _loadingText = isLogin ? "Mencoba Masuk..." : "Mendaftarkan...";
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    String? userId; 

    try {
      // --- LOGIC OTENTIKASI ---
      if (isLogin) {
        final AuthResponse response = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        ).timeout(const Duration(seconds: 15));
        userId = response.user?.id;
      } else {
        final AuthResponse response = await supabase.auth.signUp(
          email: email,
          password: password,
        ).timeout(const Duration(seconds: 15));
        userId = response.user?.id;
        
        // Asumsi Anda perlu menambahkan nama ke profiles/metadata setelah signup
      }

      if (!mounted) return;

      if (userId == null) {
        throw const AuthException("Gagal mendapatkan User ID setelah otentikasi.");
      }
      
      // 🟢 LANGKAH SINKRONISASI UTAMA
      setState(() {
        _isSyncing = true; // Mulai syncing UI
        _loadingText = "Sinkronisasi data...";
      });

      // Panggil fungsi sinkronisasi (Cloud -> Drift)
      await _supabaseService.syncOnLogin(); 

      // 4. NAVIGASI KE HOME SCREEN SETELAH SINKRONISASI SELESAI
      if (mounted) {
        // Navigasi ke /home, passing AppDatabase dan userId
        context.go('/home', extra: {
          'database': widget.database, // Meneruskan instance database
          'userId': userId, // Meneruskan userId yang baru login
        });
      }

    } on AuthException catch (error) {
      if (!mounted) return;
      _showErrorSnackbar(error.message);
    } on TimeoutException {
      if (!mounted) return;
      _showErrorSnackbar("Waktu permintaan habis. Periksa koneksi internet Anda.");
    } catch (error) {
      if (!mounted) return;
      _showErrorSnackbar("Terjadi kesalahan tak terduga: ${error.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _isSyncing = false; 
          _loadingText = isLogin ? "Masuk" : "Daftar";
        });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 5. Tampilkan UI Loading/Syncing
    if (_isSyncing) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.brown),
              const SizedBox(height: 16),
              Text(_loadingText),
            ],
          ),
        ),
      );
    }

    // Tampilan Auth normal
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Asumsi widget gambar Anda ada di sini, saya menggunakan placeholder
              Image.asset("assets/images/bear-2.png", height: 180),
              const SizedBox(height: 16), 
              const Text("Selamat Datang!", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 4),
              const Text("Masuk atau buat akun baru", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.brown)),
              const SizedBox(height: 24),
              AuthTabSwitcher(
                isLogin: isLogin,
                onLoginTap: () => setState(() => isLogin = true),
                onRegisterTap: () => setState(() => isLogin = false),
              ),
              const SizedBox(height: 24),
              if (!isLogin) ...[
                CustomTextField(
                    controller: nameController,
                    label: "Nama",
                    icon: Icons.person_outline),
                const SizedBox(height: 16),
              ],
              CustomTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email_outlined),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: passwordController,
                  label: "Kata Sandi",
                  icon: Icons.lock_outline,
                  isPassword: true),
              const SizedBox(height: 30),
              CustomButton(
                text: _loading ? _loadingText : (isLogin ? "Masuk" : "Daftar"),
                isLoading: _loading,
                onPressed: _loading ? null : _handleAuth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}