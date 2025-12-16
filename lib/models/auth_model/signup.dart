// lib/models/auth_model/signup.dart
class SignupState {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool isCheckingEmail;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final Map<String, bool> passwordValidations;

  SignupState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.isCheckingEmail = false,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.passwordValidations = const {
      'length': false,
      'hasNumber': false,
      'hasSpecial': false,
      'hasLowercase': false,
      'hasUppercase': false,
    },
  });

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    bool? isCheckingEmail,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    Map<String, bool>? passwordValidations,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      isCheckingEmail: isCheckingEmail ?? this.isCheckingEmail,
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      passwordValidations: passwordValidations ?? this.passwordValidations,
    );
  }
}