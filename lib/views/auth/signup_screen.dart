import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../viewmodels/auth_viewmodel/signup_viewmodel.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/auth_container.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/google_button.dart';

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

    // Sync controllers with state
    _nameController.value = _nameController.value.copyWith(text: signupState.name);
    _emailController.value = _emailController.value.copyWith(text: signupState.email);
    _passwordController.value = _passwordController.value.copyWith(text: signupState.password);
    _confirmController.value = _confirmController.value.copyWith(text: signupState.confirmPassword);

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
                    const Text('Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                    const SizedBox(height: 8),
                    AuthInputField(
                      hint: 'Full Name',
                      icon: Icons.person,
                      controller: _nameController,
                      onChanged: signupVM.setName,
                    ),
                    const SizedBox(height: 16),
                    const Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                    const SizedBox(height: 8),
                    AuthInputField(
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      onChanged: signupVM.setEmail,
                    ),
                    const SizedBox(height: 16),
                    const Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                    const SizedBox(height: 8),
                    AuthInputField(
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      controller: _passwordController,
                      isPassword: true,
                      onChanged: signupVM.setPassword,
                    ),
                    const SizedBox(height: 16),
                    const Text('Confirm Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                    const SizedBox(height: 8),
                    AuthInputField(
                      hint: 'Confirm Password',
                      icon: Icons.lock_outline,
                      controller: _confirmController,
                      isPassword: true,
                      onChanged: signupVM.setConfirmPassword,
                    ),
                    const SizedBox(height: 20),
                    AuthButton(
                      text: signupState.isLoading ? 'Loading...' : 'Sign Up',
                      onPressed: () async {
                        await signupVM.signup();
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('or', style: TextStyle(color: Colors.grey))),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GoogleButton(onTap: () {}),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text('Login', style: TextStyle(color: AppColors.primaryTeal, fontSize: 14, fontWeight: FontWeight.w600)),
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
