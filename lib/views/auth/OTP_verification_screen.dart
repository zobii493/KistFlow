import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/helpers/fade_slide_transition.dart';
import 'package:kistflow/widgets/auth/auth_container.dart';
import '../../core/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../viewmodels/auth_viewmodel/forgot_password_vm.dart';
import '../../viewmodels/auth_viewmodel/otp_vm.dart';
import '../../widgets/auth/auth_background.dart';
import 'reset_password_screen.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const OTPVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  ConsumerState<OTPVerificationScreen> createState() =>
      _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen>
    with SingleTickerProviderStateMixin {

  Timer? _timer;

  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Wrap provider updates in a microtask to avoid modifying during build
    Future.microtask(() {
      ref.read(otpProvider.notifier).enableResend(false);
      ref.read(otpProvider.notifier).setTimer(60);
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = ref.read(otpProvider).timer;

      if (current > 0) {
        ref.read(otpProvider.notifier).setTimer(current - 1);
      } else {
        ref.read(otpProvider.notifier).enableResend(true);
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpProvider);
    final otpVM = ref.read(otpProvider.notifier);

    return Scaffold(
      body: Stack(
        fit: .expand,
        children: [
          const AuthBackground(),
          Column(
            children: [
              const SizedBox(height: 60),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryTealOf(context).withValues(alpha:.2),
                      AppColors.primaryTealOf(context).withValues(alpha:.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.verified_user,
                  size: 70,
                  color: AppColors.primaryTealOf(context),
                ),
              ),
              const SizedBox(height: 40),
              AuthContainer(
                child: FadeSlideTransition(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Verification Code",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slateGrayOffWhiteOf(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.darkGreyOf(context).withValues(alpha:0.8),
                          ),
                          children: [
                            TextSpan(
                                text: "We sent a 4-digit code to\n",style: TextStyle(
                              color: AppColors.darkGreyOf(context),
                            ),),
                            TextSpan(
                              text: widget.email,
                              style: TextStyle(
                                color: AppColors.primaryTealOf(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      /// ================== OTP INPUT FIELDS ==================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return _buildOtpBox(
                            index,
                            otpState.otp[index],
                                (val) => otpVM.updateOTP(index, val),
                          );
                        }),
                      ),

                      const SizedBox(height: 32),
                      Center(
                        child: otpState.canResend
                            ? TextButton(
                          onPressed: () async {
                            final forgotVM = ref.read(
                                forgotPasswordProvider.notifier);

                            try {
                              final result = await forgotVM.resendOTP();

                              if (result['success'] == true) {
                                _startTimer(); // Timer reset
                                UIHelper.showSnackBar(
                                  context,
                                  result['message'] ?? "OTP resent successfully!",
                                  isError: false,
                                );
                              } else {
                                UIHelper.showSnackBar(
                                  context,
                                  result['message'] ?? "Failed to resend OTP",
                                  isError: true,
                                );
                              }
                            } catch (e) {
                              UIHelper.showSnackBar(
                                context,
                                "Failed to resend OTP",
                                isError: true,
                              );
                            }
                          },
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                              color: AppColors.primaryTealOf(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        )
                            : Text(
                          "Resend code in ${otpState.timer}s",
                          style: TextStyle(
                            fontSize: 15,
                            color:
                            AppColors.darkGreyOf(context).withValues(alpha:.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: otpState.isVerifying
                              ? null
                              : () async {
                            final forgotState =
                            ref.read(forgotPasswordProvider);
                            final isValid = await otpVM
                                .verifyOTP(forgotState.otp);

                            if (!mounted) return;

                            if (isValid) {
                              UIHelper.showSnackBar(
                                context,
                                "OTP verified successfully",
                                isError: false,
                              );

                              // FIXED: Pass email parameter
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ResetPasswordScreen(
                                    email: widget.email,
                                  ),
                                ),
                              );
                            } else {
                              UIHelper.showSnackBar(
                                context,
                                "Invalid OTP, try again",
                                isError: true,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTealOf(context).withValues(alpha: 0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          child: otpState.isVerifying
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            "Verify Code",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Change Email Address",
                            style: TextStyle(
                              color: AppColors.darkGreyOf(context),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBox(int index, String value, Function(String) onChanged) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: AppColors.offWhiteOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryTealOf(context), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        cursorColor: AppColors.primaryTealOf(context),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color:AppColors.darkGreyOf(context),
        ),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          onChanged(val);

          if (val.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (val.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}