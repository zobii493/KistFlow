// lib/widgets/auth/password_strength_indicator.dart
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final Map<String, bool> validations;

  const PasswordStrengthIndicator({
    Key? key,
    required this.validations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGreyOf(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreyOf(context).withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          _buildRequirement(
            'At least 8 characters',
            validations['length'] ?? false,
          ),
          _buildRequirement(
            'Contains number (0-9)',
            validations['hasNumber'] ?? false,
          ),
          _buildRequirement(
            'Contains special character (!@#\$%)',
            validations['hasSpecial'] ?? false,
          ),
          _buildRequirement(
            'Contains lowercase letter (a-z)',
            validations['hasLowercase'] ?? false,
          ),
          _buildRequirement(
            'Contains uppercase letter (A-Z)',
            validations['hasUppercase'] ?? false,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isValid ? Colors.green : Colors.grey.shade400,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isValid ? Colors.green.shade700 : Colors.grey.shade600,
                fontWeight: isValid ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}