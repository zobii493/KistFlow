// lib/widgets/auth/google_button.dart
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback? onTap;

  const GoogleButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Note: You would need to add flutter_svg to your pubspec.yaml
    // and place a 'google.svg' file in 'assets/icons/'
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using a simple text for the icon stub, replace with SvgPicture.asset
            // const Icon(Icons.g_mobiledata, color: Colors.blue, size: 30),
            Image.asset(
              'assets/img.png',
              height: 30,
            ),
            const SizedBox(width: 8),
            Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}