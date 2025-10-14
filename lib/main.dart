// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'services/supabase_client.dart';
// import 'screens/splash/splash_screen.dart';
// import 'screens/home/home_screen.dart';

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
//     return MaterialApp(
//       title: 'Smart Budget',
//       theme: ThemeData(
//         primarySwatch: Colors.brown,
//         scaffoldBackgroundColor: const Color.fromARGB(255, 228, 212, 212),
//       ),
//       home: StreamBuilder<AuthState>(
//         stream: Supabase.instance.client.auth.onAuthStateChange,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()));
//           }
//           if (snapshot.hasData && snapshot.data!.session != null) {
//             return const HomeScreen();
//           }
//           return const SplashScreen();
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_client.dart';
import 'routes/app_router.dart'; // <-- Import router baru

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SupabaseClientService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Budget',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      routerConfig: AppRouter.router, // go_router config
    );
  }
}
