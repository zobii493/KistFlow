import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/helpers/fade_slide_transition.dart';

import '../../core/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../viewmodels/auth_viewmodel/login_vm.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/button.dart';
import '../../widgets/auth/auth_container.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/google_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Load saved credentials after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(loginProvider.notifier).loadSavedCredentials();
      final state = ref.read(loginProvider);
      _emailController.text = state.email;
      _passwordController.text = state.password;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final loginVM = ref.read(loginProvider.notifier);
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
                    mainAxisSize: .min,
                    children: [
                      const SizedBox(height: 24),
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
                        onChanged: loginVM.setEmail,
                        errorText: loginState.emailError,
                      ),
                      const SizedBox(height: 16),
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
                        onChanged: loginVM.setPassword,
                        errorText: loginState.passwordError,
                      ),
                      const SizedBox(height: 12),

                      // Remember Me Checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              loginVM.toggleRememberMe();
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: loginState.rememberMe
                                      ? Icon(
                                    Icons.check,
                                    size: 18,
                                    color: AppColors.primaryTealOf(context),
                                  )
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Remember Me",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkGreyOf(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/forgotpassword'),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTealOf(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      AuthButton(
                        text: loginState.isLoading ? 'Loading...' : 'Login',
                        onPressed: loginState.isLoading ? null : () async {
                          final result = await loginVM.login();
                          if (!mounted) return;
                          UIHelper.showSnackBar(
                            context,
                            result['message'],
                            isError: !result['success'],
                          );
                          if (result['success']) {
                            Navigator.pushReplacementNamed(
                                context, '/bottomnavbar');
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                              child: Divider(color: AppColors.darkGreyOf(context))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('or',
                                style: TextStyle(color: AppColors.darkGreyOf(context))),
                          ),
                          Expanded(
                              child: Divider(color: AppColors.darkGreyOf(context))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GoogleButton(
                        isLoading: loginState.isLoading,
                        onTap: loginState.isLoading
                            ? null
                            : () async {
                          final userCredential = await loginVM.signInWithGoogle();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.darkGreyOf(context),
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/signup'),
                            child: Text(
                              'Sign up',
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