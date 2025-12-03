
class ResetPasswordState {
  final String newPassword;
  final String confirmPassword;
  final bool obscureNew;
  final bool obscureConfirm;
  final bool isLoading;

  ResetPasswordState({
    this.newPassword = '',
    this.confirmPassword = '',
    this.obscureNew = true,
    this.obscureConfirm = true,
    this.isLoading = false,
  });

  ResetPasswordState copyWith({
    String? newPassword,
    String? confirmPassword,
    bool? obscureNew,
    bool? obscureConfirm,
    bool? isLoading,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}