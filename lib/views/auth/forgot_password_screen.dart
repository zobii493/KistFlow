import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/helpers/fade_slide_transition.dart';
import 'package:kistflow/views/auth/OTP_verification_screen.dart';
import 'package:kistflow/widgets/auth/auth_container.dart';
import 'package:kistflow/widgets/auth/auth_text_field.dart';
import '../../core/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../viewmodels/auth_viewmodel/forgot_password_vm.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {

  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);
    final forgotVM = ref.read(forgotPasswordProvider.notifier);

    // Sync controller with state
    if (_emailController.text != forgotState.email) {
      _emailController.value = _emailController.value.copyWith(
        text: forgotState.email,
      );
    }

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
                      AppColors.primaryTealOf(context).withOpacity(0.2),
                      AppColors.primaryTealOf(context).withOpacity(0.1),
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
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slateGrayOffWhiteOf(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your email and we\'ll send you a verification code.',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.darkGreyOf(context).withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      AuthInputField(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        onChanged: forgotVM.setEmail,
                      ),
                      const SizedBox(height: 32),
                      AuthButton(
                        text: forgotState.isLoading
                            ? 'Sending...'
                            : 'Send Verification Code',
                        onPressed: forgotState.isLoading
                            ? null
                            : () async {
                                // FIXED: Properly await and handle result
                                final result = await forgotVM.sendCode();

                                if (!mounted) return;

                                // Show message to user
                                UIHelper.showSnackBar(
                                  context,
                                  result['message'],
                                  isError: !result['success'],
                                );

                                // ✅ ONLY navigate if success is true
                                if (result['success'] == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OTPVerificationScreen(
                                            email: forgotState.email,
                                          ),
                                    ),
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
                              Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: AppColors.primaryTealOf(context),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Back to Login',
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
