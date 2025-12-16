import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import '../../models/auth_model/forgot_password.dart';

class ForgotPasswordViewModel extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordViewModel() : super(ForgotPasswordState());

  String generatedOTP = "";

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  /// Resend OTP - Returns Map for proper error handling
  Future<Map<String, dynamic>> resendOTP() async {
    return await sendCode();
  }

  /// Send Code - Returns Map with success/failure info
  Future<Map<String, dynamic>> sendCode() async {
    final email = state.email.trim();

    // Validation
    if (email.isEmpty) {
      state = state.copyWith(error: "Enter your email");
      return {
        "success": false,
        "message": "Please enter your email"
      };
    }

    if (!email.contains('@')) {
      state = state.copyWith(error: "Invalid email");
      return {
        "success": false,
        "message": "Please enter a valid email"
      };
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Firestore se check karo email registered hai ya nahi
      final doc = await FirebaseFirestore.instance
          .collection('registered_emails')
          .doc(email)
          .get();

      if (!doc.exists) {
        state = state.copyWith(
          isLoading: false,
          error: "No account found with this email!",
        );
        return {
          "success": false,
          "message": "No account found with this email. Please sign up first."
        };
      }

      // Email exists → OTP generate + email send
      generatedOTP = (1000 + Random().nextInt(8999)).toString();

      var url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

      var body = jsonEncode({
        "service_id": "service_0kuusbb",
        "template_id": "template_razahkj",
        "user_id": "B6Yk3ma2Ri2npLO5-",
        "template_params": {
          "otp": generatedOTP,
          "time": DateTime.now().add(const Duration(minutes: 15)).toString(),
          "email": email,
        }
      });

      final res = await http.post(
        url,
        headers: {
          "origin": "http://localhost",
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (res.statusCode != 200) {
        throw "EmailJS Failed: ${res.body}";
      }

      // Store OTP in Firestore for Cloud Function verification
      await FirebaseFirestore.instance
          .collection('password_reset_otps')
          .doc(email)
          .set({
        'otp': generatedOTP,
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      state = state.copyWith(
        isLoading: false,
        otp: generatedOTP,
        error: null,
      );

      return {
        "success": true,
        "message": "Verification code sent to your email"
      };

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Something went wrong: $e",
      );

      return {
        "success": false,
        "message": "Failed to send verification code. Please try again."
      };
    }
  }
}

final forgotPasswordProvider =
StateNotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>(
      (ref) => ForgotPasswordViewModel(),
);