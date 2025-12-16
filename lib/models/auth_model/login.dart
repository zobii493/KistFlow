class LoginState {
  final String email;
  final String password;
  final bool isLoading;

  final String? emailError;
  final String? passwordError;
  final bool rememberMe;

  LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.emailError,
    this.passwordError,
    this.rememberMe = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? emailError,
    String? passwordError,
    bool? rememberMe,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError,
      passwordError: passwordError,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}