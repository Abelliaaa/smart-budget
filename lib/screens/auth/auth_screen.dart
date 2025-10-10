// import 'dart:async'; // 1. Tambahkan import untuk Timeout
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../services/supabase_client.dart';
// import '../../widgets/auth/auth_tab_switcher.dart';
// import '../../widgets/common/custom_button.dart';
// import '../../widgets/common/custom_text_field.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   bool isLogin = true;
//   bool _loading = false;
//   String _loadingText = "Masuk"; // Teks default

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final supabase = SupabaseClientService.client;

//   Future<void> _handleAuth() async {
//     // Memberikan feedback teks yang lebih baik
//     setState(() {
//       _loading = true;
//       _loadingText = isLogin ? "Mencoba Masuk..." : "Mendaftarkan...";
//     });

//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     try {
//       if (isLogin) {
//         // 2. Tambahkan .timeout() pada pemanggilan Supabase
//         await supabase.auth
//             .signInWithPassword(email: email, password: password)
//             .timeout(const Duration(seconds: 15));
//         // Jika berhasil, StreamBuilder akan menangani navigasi
//         // Loading akan berhenti saat halaman ini dihancurkan
//       } else {
//         // Proses daftar juga diberi timeout
//         await supabase.auth.signUp(
//           email: email,
//           password: password,
//           data: {"name": nameController.text.trim()},
//         ).timeout(const Duration(seconds: 15));

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text("Registrasi berhasil! Silakan coba login.")),
//           );
//           // Hentikan loading setelah daftar berhasil
//           setState(() {
//             _loading = false;
//             _loadingText = "Masuk";
//           });
//         }
//       }
//     } on TimeoutException {
//       // 3. Tangani error jika waktu tunggu habis
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text("Koneksi terlalu lama. Periksa internet Anda.")),
//         );
//         setState(() {
//           _loading = false;
//           _loadingText = "Masuk";
//         });
//       }
//     } on AuthException catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(e.message)));
//         setState(() {
//           _loading = false;
//           _loadingText = "Masuk";
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//           child: Column(
//             children: [
//               Image.asset("assets/images/bear-2.png", height: 180),
//               const SizedBox(height: 16),
//               const Text("Selamat Datang!",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.brown)),
//               const SizedBox(height: 4),
//               const Text("Masuk atau buat akun baru",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.brown)),
//               const SizedBox(height: 24),
//               AuthTabSwitcher(
//                 isLogin: isLogin,
//                 onLoginTap: () => setState(() {
//                   isLogin = true;
//                   _loadingText = "Masuk";
//                 }),
//                 onRegisterTap: () => setState(() {
//                   isLogin = false;
//                   _loadingText = "Daftar";
//                 }),
//               ),
//               const SizedBox(height: 24),
//               if (!isLogin) ...[
//                 CustomTextField(
//                     controller: nameController,
//                     label: "Nama",
//                     icon: Icons.person_outline),
//                 const SizedBox(height: 16),
//               ],
//               CustomTextField(
//                   controller: emailController,
//                   label: "Email",
//                   icon: Icons.email_outlined),
//               const SizedBox(height: 16),
//               CustomTextField(
//                   controller: passwordController,
//                   label: "Kata Sandi",
//                   icon: Icons.lock_outline,
//                   isPassword: true),
//               const SizedBox(height: 30),
//               // Gunakan teks dinamis pada tombol
//               CustomButton(
//                 text: isLogin ? "Masuk" : "Daftar",
//                 loadingText: _loadingText,
//                 isLoading: _loading,
//                 onPressed: _handleAuth,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_client.dart';
import '../../widgets/auth/auth_tab_switcher.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool _loading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final supabase = SupabaseClientService.client;

  Future<void> _handleAuth() async {
    setState(() => _loading = true);
    print("===== DEBUG: 1. Tombol ditekan, loading dimulai. =====");

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    print("===== DEBUG: 2. Mencoba login dengan email: $email =====");

    try {
      if (isLogin) {
        await supabase.auth.signInWithPassword(email: email, password: password);
        
        // Jika kode sampai di sini, artinya AWAIT berhasil
        print("===== DEBUG: 3. Login BERHASIL di sisi klien. Menunggu go_router... =====");

      } else {
        await supabase.auth.signUp(
          email: email,
          password: password,
          data: {"name": nameController.text.trim()},
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registrasi berhasil! Silakan login.")),
          );
          setState(() => _loading = false);
        }
      }
    } on AuthException catch (e) {
      print("===== DEBUG ERROR: Terjadi AuthException: ${e.message} =====");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
        setState(() => _loading = false);
      }
    } catch (e) {
      print("===== DEBUG ERROR: Terjadi kesalahan lain yang tidak terduga: ${e.toString()} =====");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Terjadi kesalahan.")));
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UI tidak berubah
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Image.asset("assets/images/bear-2.png", height: 180),
              const SizedBox(height: 16),
              const Text("Selamat Datang!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
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
                text: isLogin ? "Masuk" : "Daftar",
                isLoading: _loading,
                onPressed: _handleAuth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}