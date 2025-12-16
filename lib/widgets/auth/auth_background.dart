import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: screenHeight * 0.38,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: isDark
              ? const [
            Color(0xFF12121A), // ultra dark base
            Color(0xFF1C1B2D), // depth layer
            Color(0xFF2A2558), // deep purple tone
            Color(0xFF3A3F87), // subtle highlight
          ]
              : const [
            Color(0xFFA4E3FC), // Sky blue
            Color(0xFFC5E9FD), // Light blue
            Color(0xFFFCD4E6), // Light pink
            Color(0xFFFCD6C1), // Peach
          ],
        ),
      ),
    );
  }
}
