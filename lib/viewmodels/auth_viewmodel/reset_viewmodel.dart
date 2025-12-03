import 'package:flutter_riverpod/legacy.dart';

import '../../models/auth_model/reset.dart';

class ResetPasswordViewModel extends StateNotifier<ResetPasswordState> {
  ResetPasswordViewModel() : super(ResetPasswordState());

  void setNewPassword(String value) {
    state = state.copyWith(newPassword: value);
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  void toggleObscureNew() {
    state = state.copyWith(obscureNew: !state.obscureNew);
  }

  void toggleObscureConfirm() {
    state = state.copyWith(obscureConfirm: !state.obscureConfirm);
  }

  Future<bool> resetPassword() async {
    state = state.copyWith(isLoading: true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);

    // Return true if success
    return state.newPassword == state.confirmPassword && state.newPassword.isNotEmpty;
  }
}

final resetPasswordProvider =
StateNotifierProvider<ResetPasswordViewModel, ResetPasswordState>((ref) {
  return ResetPasswordViewModel();
});
