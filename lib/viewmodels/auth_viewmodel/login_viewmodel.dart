import 'package:flutter_riverpod/legacy.dart';

import '../../models/auth_model/login.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState());

  void setEmail(String email) => state = state.copyWith(email: email);
  void setPassword(String password) => state = state.copyWith(password: password);

  Future<void> login() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2)); // Mock API call
    state = state.copyWith(isLoading: false);
  }
}

final loginProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});
