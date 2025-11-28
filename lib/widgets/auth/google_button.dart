import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onTap;
  const GoogleButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Image.asset('assets/img.png', width: 20),
      label: const Text(
        'Continue with Google',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
