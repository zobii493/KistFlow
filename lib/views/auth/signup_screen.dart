import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/helpers/fade_slide_transition.dart';

import '../../core/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../viewmodels/auth_viewmodel/signup_vm.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/button.dart';
import '../../widgets/auth/auth_container.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/google_button.dart';
import '../../widgets/auth/password_strength_indicator.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();

    // Reset SignupState on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(signupProvider.notifier).clearForm();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);
    final signupVM = ref.read(signupProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: .expand,
        children: [
          const AuthBackground(),
          Column(
            children: [
              const SizedBox(height: 60),
              Center(child: isDark?
              Image.asset(
                'assets/darkmode.png', // <-- YOUR LOGO PATH
                height: 180,
                width: 180,
              )
              :Image.asset('assets/logo.png', height: 160)),
              const SizedBox(height: 60),
              AuthContainer(
                child: FadeSlideTransition(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      // Name
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hint: 'Full Name',
                        icon: Icons.person,
                        controller: _nameController,
                        onChanged: signupVM.setName,
                        errorText: signupState.nameError,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        onChanged: signupVM.setEmail,
                        errorText: signupState.emailError,
                        suffixIcon: signupState.isCheckingEmail
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: true,
                        onChanged: signupVM.setPassword,
                        errorText: signupState.passwordError,
                      ),
                      if (signupState.password.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        PasswordStrengthIndicator(
                          validations: signupState.passwordValidations,
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Confirm Password
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
                        hint: 'Confirm Password',
                        icon: Icons.lock_outline,
                        controller: _confirmController,
                        isPassword: true,
                        onChanged: signupVM.setConfirmPassword,
                        errorText: signupState.confirmPasswordError,
                      ),
                      const SizedBox(height: 24),

                      // Sign Up Button
                      AuthButton(
                        text: signupState.isLoading
                            ? 'Creating Account...'
                            : 'Sign Up',
                        onPressed: signupState.isLoading
                            ? null
                            : () async {
                                final result = await signupVM.signup();
                                if (!mounted) return;
                                UIHelper.showSnackBar(
                                  context,
                                  result['message'],
                                  isError: !result['success'],
                                );

                                if (result['success']) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                }
                              },
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.darkGreyOf(context))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: TextStyle(color: AppColors.darkGreyOf(context)),
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.darkGreyOf(context))),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Google Sign In
                      GoogleButton(
                        isLoading: signupState.isLoading,
                        onTap: signupState.isLoading
                            ? null
                            : () async {
                          final userCredential = await signupVM.signInWithGoogle();
                          if (!mounted) return;

                          if (userCredential != null && userCredential.user != null) {
                            UIHelper.showSnackBar(
                              context,
                              "Signed in as ${userCredential.user!.displayName}",
                              isError: false,
                            );
                            Navigator.pushReplacementNamed(context, '/bottomnavbar');
                          } else {
                            UIHelper.showSnackBar(
                              context,
                              "Google Sign-In cancelled or failed",
                              isError: true,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: AppColors.darkGreyOf(context),
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.primaryTealOf(context),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
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
