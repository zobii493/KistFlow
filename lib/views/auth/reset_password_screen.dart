import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/helpers/fade_slide_transition.dart';
import '../../core/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../viewmodels/auth_viewmodel/reset_vm.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/auth_container.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/button.dart';
import '../../widgets/auth/password_strength_indicator.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {

  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(resetPasswordProvider);
    final resetVM = ref.read(resetPasswordProvider.notifier);

    return Scaffold(
      body: Stack(
        fit: .expand,
        children: [
          const AuthBackground(),
          Column(
            children: [
              const SizedBox(height: 60),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryTealOf(context).withValues(alpha:0.2),
                      AppColors.primaryTealOf(context).withValues(alpha:0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset,
                  size: 70,
                  color: AppColors.primaryTealOf(context),
                ),
              ),
              const SizedBox(height: 40),
              AuthContainer(
                child: FadeSlideTransition(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slateGrayOffWhiteOf(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Create a strong password for ${widget.email}',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.darkGreyOf(context).withValues(alpha:0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // New Password Field
                      Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hint: 'Enter new password',
                        icon: Icons.lock_outline,
                        controller: _newPasswordController,
                        isPassword: true,
                        onChanged: resetVM.setNewPassword,
                      ),
                      const SizedBox(height: 16),

                      // Password Strength Indicator
                      PasswordStrengthIndicator(
                        validations: resetState.passwordValidations,
                      ),
                      const SizedBox(height: 24),

                      // Confirm Password Field
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hint: 'Confirm new password',
                        icon: Icons.lock_outline,
                        controller: _confirmPasswordController,
                        isPassword: true,
                        onChanged: resetVM.setConfirmPassword,
                      ),

                      // Password Match Indicator
                      if (resetState.confirmPassword.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Icon(
                                resetState.newPassword ==
                                    resetState.confirmPassword
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                size: 16,
                                color: resetState.newPassword ==
                                    resetState.confirmPassword
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                resetState.newPassword ==
                                    resetState.confirmPassword
                                    ? 'Passwords match'
                                    : 'Passwords do not match',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: resetState.newPassword ==
                                      resetState.confirmPassword
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Reset Button
                      AuthButton(
                        text: resetState.isLoading
                            ? 'Resetting...'
                            : 'Reset Password',
                        onPressed: resetState.isLoading
                            ? null
                            : () async {
                          final result =
                          await resetVM.resetPassword(widget.email);

                          if (!mounted) return;

                          UIHelper.showSnackBar(
                            context,
                            result['message'],
                            isError: !result['success'],
                          );

                          if (result['success']) {
                            // Navigate to login screen
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                                  (route) => false,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back,
                                  size: 18, color: AppColors.primaryTealOf(context)),
                              SizedBox(width: 8),
                              Text(
                                'Back',
                                style: TextStyle(
                                  color: AppColors.primaryTealOf(context),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}