import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../models/auth_model/signup.dart';

class SignupViewModel extends StateNotifier<SignupState> {
  SignupViewModel() : super(SignupState());

  void setName(String name) => state = state.copyWith(name: name);
  void setEmail(String email) => state = state.copyWith(email: email);
  void setPassword(String password) => state = state.copyWith(password: password);
  void setConfirmPassword(String confirmPassword) => state = state.copyWith(confirmPassword: confirmPassword);

  Future<void> signup() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2)); // Mock API call
    state = state.copyWith(isLoading: false);
  }
}

final signupProvider = StateNotifierProvider<SignupViewModel, SignupState>((ref) {
  return SignupViewModel();
});
