
import 'package:flutter_riverpod/legacy.dart';

import '../../models/auth_model/forgot_password.dart';


class ForgotPasswordViewModel extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordViewModel() : super(ForgotPasswordState());

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  Future<void> sendCode() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 2)); // MOCK API

    state = state.copyWith(isLoading: false);
  }
}

final forgotPasswordProvider =
StateNotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>(
      (ref) => ForgotPasswordViewModel(),
);
