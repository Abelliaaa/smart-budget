// // import 'package:flutter/material.dart';
// // import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'services/supabase_client.dart';
// // import 'screens/splash/splash_screen.dart';
// // import 'screens/home/home_screen.dart';

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await dotenv.load(fileName: ".env");
// //   await SupabaseClientService.init();
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Smart Budget',
// //       theme: ThemeData(
// //         primarySwatch: Colors.brown,
// //         scaffoldBackgroundColor: const Color.fromARGB(255, 228, 212, 212),
// //       ),
// //       home: StreamBuilder<AuthState>(
// //         stream: Supabase.instance.client.auth.onAuthStateChange,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Scaffold(
// //                 body: Center(child: CircularProgressIndicator()));
// //           }
// //           if (snapshot.hasData && snapshot.data!.session != null) {
// //             return const HomeScreen();
// //           }
// //           return const SplashScreen();
// //         },
// //       ),
// //     );
// //   }
// // }



// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'services/supabase_client.dart';
// import 'routes/app_router.dart'; // <-- Import router baru

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");
//   await SupabaseClientService.init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Smart Budget',
//       theme: ThemeData(
//         primaryColor: Colors.white,
//         scaffoldBackgroundColor: Colors.white,
//         fontFamily: 'Poppins',
//       ),
//       routerConfig: AppRouter.router, // go_router config
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'database/database.dart';
import 'services/supabase_client.dart';
import 'services/auth_service.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  // ==========================================================
  //   ⬇️ KITA AKAN MELACAK PROSESNYA DI SINI ⬇️
  // ==========================================================
  print("--- [MAIN] Aplikasi Mulai ---");

  try {
    print("--- [MAIN] 1. Inisialisasi Flutter Binding... ---");
    WidgetsFlutterBinding.ensureInitialized();
    print("--- [MAIN] ✅ Flutter Binding OK ---");

    print("--- [MAIN] 2. Memuat file .env... ---");
    await dotenv.load(fileName: ".env");
    print("--- [MAIN] ✅ File .env OK ---");

    print("--- [MAIN] 3. Inisialisasi Supabase... (Jika macet di sini, cek koneksi/kunci API) ---");
    await SupabaseClientService.init();
    print("--- [MAIN] ✅ Supabase OK ---");

    print("--- [MAIN] 4. Membuat instance AuthService... ---");
    final authService = AuthService(Supabase.instance.client);
    print("--- [MAIN] ✅ AuthService OK ---");
    
    print("--- [MAIN] 5. Membuat instance AppDatabase (database lokal)... ---");
    final appDatabase = AppDatabase();
    print("--- [MAIN] ✅ AppDatabase OK ---");

    print("--- [MAIN] 6. Menjalankan Aplikasi (runApp)... ---");
    runApp(MyApp(authService: authService, database: appDatabase));
    print("--- [MAIN] ✅ Aplikasi Berhasil Dijalankan ---");

  } catch (e) {
    print("--- 🚨 [MAIN] TERJADI ERROR KRITIS SAAT INISIALISASI: $e ---");
  }
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final AppDatabase database;

  const MyApp({
    super.key,
    required this.authService,
    required this.database,
  });

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(database: database);

    return MaterialApp.router(
      title: 'Smart Budget',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      locale: const Locale('id', 'ID'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
      routerConfig: appRouter.router,
    );
  }
}