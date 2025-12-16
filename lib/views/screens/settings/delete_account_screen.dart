import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/helpers/ui_helper.dart';
import 'package:kistflow/widgets/appbar.dart';

import '../../../core/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../viewmodels/setting_vm.dart';
import '../../../widgets/auth/auth_text_field.dart';
import '../../../widgets/auth/button.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;
  bool _confirmDelete = false;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateConfirm(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmError = 'Please type DELETE to confirm';
      } else if (value != 'DELETE') {
        _confirmError = 'You must type DELETE exactly';
      } else {
        _confirmError = null;
      }
    });
  }

  bool _isFormValid() {
    return _passwordController.text.isNotEmpty &&
        _confirmController.text == 'DELETE' &&
        _confirmDelete &&
        _passwordError == null &&
        _confirmError == null;
  }

  Future<void> _handleDeleteAccount() async {
    // Validate all fields
    _validatePassword(_passwordController.text);
    _validateConfirm(_confirmController.text);

    if (!_isFormValid()) {
      if (!_confirmDelete) {
        UIHelper.showSnackBar(context, 'Please confirm that you understand this action cannot be undone', isError: true);
      }
      return;
    }

    // Show final confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.pinkOf(context), size: 28),
            const SizedBox(width: 12),
            const Text('Final Warning'),
          ],
        ),
        content: const Text(
          'Are you absolutely sure? This action is permanent and cannot be reversed.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pinkOf(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Yes, Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    setState(() => _isLoading = true);

    try {
      final result = await ref.read(settingsViewModelProvider.notifier).deleteAccount(
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (result['success']) {
        // Navigate to login screen
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
              (route) => false,
        );

        // Show success message
        UIHelper.showSnackBar(context, 'Account deleted successfully', isError: false);
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

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.close,
            size: 16,
            color: AppColors.pinkOf(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.darkGreyOf(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Delete Account'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.pinkOf(context).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever,
                    size: 50,
                    color: AppColors.pinkOf(context),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Warning Title
              Text(
                'Delete Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pinkOf(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This action is permanent and cannot be undone.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreyOf(context),
                ),
              ),
              const SizedBox(height: 24),

              // Warning Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.pinkOf(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.pinkOf(context).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.pinkOf(context),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'What will be deleted:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pinkOf(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildWarningItem('All your kists and payment records'),
                    _buildWarningItem('Your profile information'),
                    _buildWarningItem('All app settings and preferences'),
                    _buildWarningItem('Your account and authentication data'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Password Field
              AuthInputField(
                hint: 'Enter your password',
                icon: Icons.lock,
                isPassword: true,
                controller: _passwordController,
                onChanged: _validatePassword,
                errorText: _passwordError,
              ),
              const SizedBox(height: 20),

              // Confirmation Field
              AuthInputField(
                hint: 'Type DELETE to confirm',
                icon: Icons.warning,
                controller: _confirmController,
                onChanged: _validateConfirm,
                errorText: _confirmError,
              ),
              const SizedBox(height: 20),

              // Checkbox Confirmation
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGreyOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _confirmDelete
                        ? AppColors.pinkOf(context).withOpacity(0.3)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _confirmDelete,
                      onChanged: (value) {
                        setState(() => _confirmDelete = value ?? false);
                      },
                      activeColor: AppColors.pinkOf(context),
                    ),
                    Expanded(
                      child: Text(
                        'I understand this action cannot be undone',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Delete Button
              AuthButton(
                text: 'Delete My Account',
                isLoading: _isLoading,
                onPressed: _handleDeleteAccount,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}