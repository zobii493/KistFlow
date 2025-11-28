import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/auth_container.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/google_button.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackground(),

          Column(
            children: [
              const SizedBox(height: 60),
              Center(child: Image.asset('assets/logo.png', height: 160)),
              const SizedBox(height: 60),
              AuthContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AuthInputField(
                      hint: 'Full Name',
                      icon: Icons.person,
                      controller: name,
                    ),
                    SizedBox(height: 16),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AuthInputField(
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      controller: email,
                    ),
                    SizedBox(height: 16),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AuthInputField(
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      controller: password,
                      isPassword: true,
                    ),
                    SizedBox(height: 16),
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AuthInputField(
                      hint: 'Confirm Password',
                      icon: Icons.lock_outline,
                      controller: confirmPassword,
                      isPassword: true,
                    ),

                    const SizedBox(height: 20),

                    AuthButton(text: 'Sign Up', onPressed: () {}),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GoogleButton(onTap: () {}),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primaryTeal,
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
            ],
          ),
        ],
      ),
    );
  }
}
