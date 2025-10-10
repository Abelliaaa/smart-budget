// import 'package:flutter/material.dart';
// import '../auth/auth_screen.dart';
// import '../../widgets/common/custom_button.dart';
// import '../../widgets/onboarding/dot_indicator.dart';
// import '../../widgets/onboarding/onboarding_page.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   int _currentPage = 0;

//   final List<Map<String, String>> onboardingData = [
//     {
//       "image": "assets/images/bear-1.png",
//       "title": "Selamat datang di Smart Budget",
//       "desc": "Smart Budget untuk kelola keuanganmu lebih baik"
//     },
//     {
//       "image": "assets/images/bear-2.png",
//       "title": "Catat & Lacak Pengeluaran",
//       "desc":
//           "Pemasukan, pengeluaran, hingga tabungan bisa kamu kontrol dengan mudah"
//     },
//     {
//       "image": "assets/images/bear-3.png",
//       "title": "Atur Keuangan Jadi Lebih Terencana",
//       "desc": "Yuk mulai perjalanan finansialmu bersama Smart Budget!"
//     },
//   ];

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView.builder(
//                 controller: _controller,
//                 itemCount: onboardingData.length,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentPage = index;
//                   });
//                 },
//                 itemBuilder: (context, index) {
//                   // Menggunakan widget OnboardingPage yang sudah dipisah
//                   return OnboardingPage(
//                     image: onboardingData[index]["image"]!,
//                     title: onboardingData[index]["title"]!,
//                     desc: onboardingData[index]["desc"]!,
//                   );
//                 },
//               ),
//             ),

//             // Menggunakan widget DotIndicator yang sudah dipisah
//             DotIndicator(
//               itemCount: onboardingData.length,
//               currentPage: _currentPage,
//             ),

//             const SizedBox(height: 30),

//             // Menggunakan widget CustomButton yang sudah dipisah
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: CustomButton(
//                 text: _currentPage == onboardingData.length - 1
//                     ? "Mulai"
//                     : "Selanjutnya",
//                 onPressed: () {
//                   if (_currentPage == onboardingData.length - 1) {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const AuthScreen()),
//                     );
//                   } else {
//                     _controller.nextPage(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeIn,
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/onboarding/dot_indicator.dart';
import '../../widgets/onboarding/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Data untuk halaman onboarding (bisa Anda sesuaikan)
  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/bear-1.png",
      "title": "Selamat datang di Smart Budget",
      "desc": "Smart Budget untuk kelola keuanganmu lebih baik"
    },
    {
      "image": "assets/images/bear-2.png",
      "title": "Catat & Lacak Pengeluaran",
      "desc":
          "Pemasukan, pengeluaran, hingga tabungan bisa kamu kontrol dengan mudah"
    },
    {
      "image": "assets/images/bear-3.png",
      "title": "Atur Keuangan Jadi Lebih Terencana",
      "desc": "Yuk mulai perjalanan finansialmu bersama Smart Budget!"
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    image: onboardingData[index]["image"]!,
                    title: onboardingData[index]["title"]!,
                    desc: onboardingData[index]["desc"]!,
                  );
                },
              ),
            ),
            DotIndicator(
              itemCount: onboardingData.length,
              currentPage: _currentPage,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: CustomButton(
                text: _currentPage == onboardingData.length - 1
                    ? "Mulai"
                    : "Selanjutnya",
                onPressed: () {
                  if (_currentPage == onboardingData.length - 1) {
                    // Arahkan ke rute otentikasi
                    context.go('/auth');
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}