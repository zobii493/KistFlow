// lib/models/auth_model/reset.dart
class ResetPasswordState {
  final String newPassword;
  final String confirmPassword;
  final bool obscureNew;
  final bool obscureConfirm;
  final bool isLoading;
  final Map<String, bool> passwordValidations;

  ResetPasswordState({
    this.newPassword = '',
    this.confirmPassword = '',
    this.obscureNew = true,
    this.obscureConfirm = true,
    this.isLoading = false,
    Map<String, bool>? passwordValidations,
  }) : passwordValidations = passwordValidations ?? {
    'length': false,
    'hasNumber': false,
    'hasSpecial': false,
    'hasLowercase': false,
    'hasUppercase': false,
  };

  ResetPasswordState copyWith({
    String? newPassword,
    String? confirmPassword,
    bool? obscureNew,
    bool? obscureConfirm,
    bool? isLoading,
    Map<String, bool>? passwordValidations,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      isLoading: isLoading ?? this.isLoading,
      passwordValidations: passwordValidations ?? this.passwordValidations,
    );
  }
}