import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

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
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00B7FF), // Sky blue
              Color(0xFFB4E4FF), // Light blue
              Color(0xFFFFB6D9), // Light pink
              Color(0xFFFFC8A8), // Peach
            ],
            stops: [0.0, 0.3, 0.6, 1.3],
          ),
        ),

        // Centered Logo
        child: Center(
          child: Image.asset(
            'assets/logo.png', // <-- YOUR LOGO PATH
            height: 180,
            width: 180,
          ),
        ),
      ),
    );
  }
}
