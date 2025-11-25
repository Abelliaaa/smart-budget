import 'package:flutter/material.dart';

class AuthTabSwitcher extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  const AuthTabSwitcher({
    // ✅ PERBAIKAN 1: Menggunakan super.key
    super.key, 
    required this.isLogin,
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  // Helper untuk mengubah opacity menjadi alpha (untuk perbaikan linter)
  Color _withAlpha(Color color, double opacity) {
    return color.withAlpha((255 * opacity).round());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            // ✅ PERBAIKAN 2: Mengganti withOpacity dengan _withAlpha
            color: _withAlpha(Colors.black, 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          _buildTab("Masuk", isLogin, onLoginTap),
          _buildTab("Daftar", !isLogin, onRegisterTap),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.brown : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}