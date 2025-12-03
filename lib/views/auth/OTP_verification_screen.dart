import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/widgets/auth/auth_container.dart';
import '../../core/app_colors.dart';
import '../../viewmodels/auth_viewmodel/otp_viewmodel.dart';
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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Timer? _timer;

  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startTimer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, .3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
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
    _animationController.dispose();
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
      backgroundColor: AppColors.offWhite,
      body: Stack(
        children: [
          const AuthBackground(),
          Column(
            children: [
              const SizedBox(height: 60),
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryTeal.withOpacity(.2),
                        AppColors.primaryTeal.withOpacity(.1),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.verified_user,
                    size: 70,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              AuthContainer(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        const Text(
                          "Verification Code",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slateGray,
                          ),
                        ),

                        const SizedBox(height: 12),

                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.darkGrey.withOpacity(0.8),
                            ),
                            children: [
                              const TextSpan(text: "We sent a 4-digit code to\n"),
                              TextSpan(
                                text: widget.email,
                                style: const TextStyle(
                                  color: AppColors.primaryTeal,
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
                                  onPressed: () {
                                    // Wrap in Future to avoid build-time modification
                                    Future.microtask(() => _startTimer());
                                  },
                                  child: const Text(
                                    "Resend Code",
                                    style: TextStyle(
                                      color: AppColors.primaryTeal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Resend code in ${otpState.timer}s",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.darkGrey.withOpacity(.6),
                                  ),
                                ),
                        ),

                        const SizedBox(height: 32),

                        /// ================== VERIFY BUTTON ==================
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: otpState.fullOTP.length == 4
                                ? () async {
                                    await otpVM.verifyOTP();
                                    final updatedState = ref.read(otpProvider);
                                    if (!updatedState.isVerifying) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ResetPasswordScreen(),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            child: otpState.isVerifying
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
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
                            child: const Text(
                              "Change Email Address",
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryTeal, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
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
        cursorColor: AppColors.primaryTeal,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.slateGray,
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
