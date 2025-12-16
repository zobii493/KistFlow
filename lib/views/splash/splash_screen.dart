import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:kistflow/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Move to Login screen after 2 seconds
    Timer(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.bottomnavbar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF12121A), // ultra dark base
                    Color(0xFF1C1B2D), // depth layer
                    Color(0xFF2A2558), // deep purple tone
                    Color(0xFF3A3F87), // subtle highlight
                  ]
                : const [
                    Color(0xFF00B7FF), // Sky blue
                    Color(0xFFB4E4FF), // Light blue
                    Color(0xFFFFB6D9), // Light pink
                    Color(0xFFFFC8A8), // Peach
                  ],
            stops: const [0.0, 0.3, 0.6, 1.3],
          ),
        ),

        // Centered Logo
        child: Center(
          child: isDark
              ? Image.asset(
                  'assets/darkmode.png',
                  height: 180,
                  width: 180,
                )
              : Image.asset(
                  'assets/logo.png',
                  height: 180,
                  width: 180,
                ),
        ),
      ),
    );
  }
}
