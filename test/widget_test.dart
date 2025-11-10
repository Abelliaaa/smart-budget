// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:smart_budget/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }


// test/widget_test.dart

// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Ganti 'smart_budget' dengan nama folder proyek Anda jika berbeda
import 'package:smart_budget/main.dart';
import 'package:smart_budget/services/auth_service.dart';
import 'package:smart_budget/database/database.dart';

// Mock Supabase client untuk testing agar tidak melakukan koneksi internet sungguhan
class MockSupabaseClient extends Fake implements SupabaseClient {
  @override
  GoTrueClient get auth => MockGoTrueClient();
}

class MockGoTrueClient extends Fake implements GoTrueClient {
  @override
  Stream<AuthState> get onAuthStateChange => Stream.value(
        // ================== PERBAIKAN DI SINI ==================
        // Constructor AuthState sekarang menggunakan 2 argumen posisi:
        // AuthState(event, session)
        const AuthState(AuthChangeEvent.initialSession, null),
        // =======================================================
      );
}

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // 1. Siapkan service yang dibutuhkan dengan data palsu (mock) untuk testing
    final mockSupabaseClient = MockSupabaseClient();
    final authService = AuthService(mockSupabaseClient);
    final appDatabase = AppDatabase(); // AppDatabase bisa dibuat langsung

    // 2. Bangun widget MyApp dan berikan service yang sudah disiapkan
    await tester.pumpWidget(MyApp(
      authService: authService,
      database: appDatabase,
    ));

    // 3. Verifikasi bahwa widget MyApp berhasil ditampilkan
    // Ini adalah tes dasar untuk memastikan tidak ada error saat membangun UI.
    expect(find.byType(MyApp), findsOneWidget);
  });
}