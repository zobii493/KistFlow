import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/views/auth/OTP_verification_screen.dart';
import 'package:kistflow/views/auth/reset_password_screen.dart';
import 'package:kistflow/widgets/auth/auth_container.dart';
import 'package:kistflow/widgets/auth/auth_text_field.dart';
import '../../core/app_colors.dart';
import '../../viewmodels/auth_viewmodel/forgot_password_viewmodel.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/auth_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

// 2️⃣ State class (tumhara existing code)
class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);
    final forgotVM = ref.read(forgotPasswordProvider.notifier);

    // Sync controller with state
    _emailController.value =
        _emailController.value.copyWith(text: forgotState.email);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Stack(
        children: [
          const AuthBackground(),
          Column(
            children: [
              const SizedBox(height: 60),
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryTeal.withOpacity(0.2),
                        AppColors.primaryTeal.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 70,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              AuthContainer(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slateGray,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Enter your email and we’ll send you a verification code.',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.darkGrey.withOpacity(0.8),
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
                          onPressed: () async {
                            await forgotVM.sendCode();
                            if (!forgotState.isLoading) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  // return ResetPasswordScreen();
                                  return OTPVerificationScreen(email:forgotState.email);
                                },
                              ),);
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back,
                                    size: 18, color: AppColors.primaryTeal),
                                SizedBox(width: 8),
                                Text(
                                  'Back to Login',
                                  style: TextStyle(
                                    color: AppColors.primaryTeal,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
