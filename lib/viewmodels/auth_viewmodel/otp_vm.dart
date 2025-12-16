  import 'package:flutter_riverpod/legacy.dart';

import '../../models/auth_model/otp.dart';
class OTPViewModel extends StateNotifier<OTPState> {
  OTPViewModel() : super(OTPState());

  void updateOTP(int index, String value) {
    final updated = [...state.otp];
    updated[index] = value;
    state = state.copyWith(otp: updated);
  }

  void setTimer(int value) {
    state = state.copyWith(timer: value);
  }

  void enableResend(bool value) {
    state = state.copyWith(canResend: value);
  }

  Future<bool> verifyOTP(String originalOTP) async {
    state = state.copyWith(isVerifying: true);

    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(isVerifying: false);

    return fullOTP == originalOTP;
  }


  // You can keep this convenience getter in the ViewModel too
  String get fullOTP => state.otp.join();
}

final otpProvider =
StateNotifierProvider<OTPViewModel, OTPState>((ref) => OTPViewModel());