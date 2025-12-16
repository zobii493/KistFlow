class ForgotPasswordState {
  final String email;
  final bool isLoading;
  final String otp;
  final String? error;

  ForgotPasswordState({
    this.email = '',
    this.isLoading = false,
    this.otp = '',
    this.error,
  });

  ForgotPasswordState copyWith({
    String? email,
    bool? isLoading,
    String? otp,
    String? error,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      otp: otp ?? this.otp,
      error: error ?? this.error,
    );
  }
}