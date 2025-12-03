class ForgotPasswordState {
  final String email;
  final bool isLoading;

  ForgotPasswordState({
    this.email = '',
    this.isLoading = false,
  });

  ForgotPasswordState copyWith({
    String? email,
    bool? isLoading,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}