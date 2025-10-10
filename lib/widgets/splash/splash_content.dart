import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/bear.png",
            height: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            "Smart Budget",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5A4C43),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Catat Keuangan dengan Cerdas",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF7A6F6F),
            ),
          ),
        ],
      ),
    );
  }
}