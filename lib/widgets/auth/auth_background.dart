import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00B7FF),
            Color(0xFFB4E4FF),
            Color(0xFFFFB6D9),
            Color(0xFFFFC8A8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
