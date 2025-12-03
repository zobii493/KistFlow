import 'package:flutter/material.dart';
import 'package:kistflow/core/app_colors.dart';

class AuthInputField extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final TextEditingController controller;
  final bool isPassword;
  final Function(String)? onChanged;

  const AuthInputField({
    super.key,
    required this.hint,
    this.icon,
    required this.controller,
    this.isPassword = false,
    this.onChanged,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? hide : false,
      onChanged: widget.onChanged,
      cursorColor: AppColors.primaryTeal,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: AppColors.darkGrey),
        prefixIcon: Icon(widget.icon, color: AppColors.darkGrey),

        // Only show suffix icon if password field
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            hide ? Icons.visibility_off : Icons.visibility,
            color: AppColors.darkGrey,
          ),
          onPressed: () => setState(() => hide = !hide),
        )
            : null,

        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
