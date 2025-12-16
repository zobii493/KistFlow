
class OTPState {
  final List<String> otp;
  final int timer;
  final bool canResend;
  final bool isVerifying;

  OTPState({
    this.otp = const ['', '', '', ''],
    this.timer = 60,
    this.canResend = false,
    this.isVerifying = false,
  });

  // Add this getter to OTPState
  String get fullOTP => otp.join();

  OTPState copyWith({
    List<String>? otp,
    int? timer,
    bool? canResend,
    bool? isVerifying,
  }) {
    return OTPState(
      otp: otp ?? this.otp,
      timer: timer ?? this.timer,
      canResend: canResend ?? this.canResend,
      isVerifying: isVerifying ?? this.isVerifying,
    );
  }
}
