import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/helpers/ui_helper.dart';
import 'package:kistflow/widgets/appbar.dart';

import '../../../core/app_colors.dart';
import '../../../viewmodels/setting_vm.dart';
import '../../../widgets/auth/auth_text_field.dart';
import '../../../widgets/auth/button.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateCurrentPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _currentPasswordError = 'Current password is required';
      } else {
        _currentPasswordError = null;
      }
    });
  }

  void _validateNewPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _newPasswordError = 'New password is required';
      } else if (value.length < 8) {
        _newPasswordError = 'Password must be at least 8 characters';
      } else {
        _newPasswordError = null;
      }

      // Also validate confirm password if it's filled
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword(_confirmPasswordController.text);
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (value != _newPasswordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  bool _isFormValid() {
    return _currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _currentPasswordError == null &&
        _newPasswordError == null &&
        _confirmPasswordError == null;
  }

  Future<void> _handleChangePassword() async {
    // Validate all fields
    _validateCurrentPassword(_currentPasswordController.text);
    _validateNewPassword(_newPasswordController.text);
    _validateConfirmPassword(_confirmPasswordController.text);

    if (!_isFormValid()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ref.read(settingsViewModelProvider.notifier).changePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      if (!mounted) return;

      if (result['success']) {
        // Show success message
        UIHelper.showSnackBar(context, 'Password changed successfully', isError: false);

        // Go back to settings
        Navigator.pop(context);
      } else {
        // Show error message
        UIHelper.showSnackBar(context, 'Error: ${result['message']}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Change Password'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTealOf(context).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 50,
                    color: AppColors.primaryTealOf(context),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Description
              Text(
                'Create a strong password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGrayOffWhiteOf(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your password must be at least 8 characters long and include a mix of letters, numbers, and symbols.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGreyOf(context),
                ),
              ),
              const SizedBox(height: 32),

              // Current Password
              AuthInputField(
                hint: 'Current Password',
                icon: Icons.lock,
                isPassword: true,
                controller: _currentPasswordController,
                onChanged: _validateCurrentPassword,
                errorText: _currentPasswordError,
              ),
              const SizedBox(height: 20),

              // New Password
              AuthInputField(
                hint: 'New Password',
                icon: Icons.lock_open,
                isPassword: true,
                controller: _newPasswordController,
                onChanged: _validateNewPassword,
                errorText: _newPasswordError,
              ),
              const SizedBox(height: 20),

              // Confirm Password
              AuthInputField(
                hint: 'Confirm New Password',
                icon: Icons.lock_reset,
                isPassword: true,
                controller: _confirmPasswordController,
                onChanged: _validateConfirmPassword,
                errorText: _confirmPasswordError,
              ),
              const SizedBox(height: 24),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryTealOf(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryTealOf(context).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primaryTealOf(context),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Make sure to remember your new password. You\'ll need it to sign in.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Change Password Button
              AuthButton(
                text: 'Change Password',
                isLoading: _isLoading,
                onPressed: _handleChangePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}