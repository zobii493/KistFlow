import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/auth_model/reset.dart';

class ResetPasswordViewModel extends StateNotifier<ResetPasswordState> {
  ResetPasswordViewModel() : super(ResetPasswordState());

  void setNewPassword(String value) {
    state = state.copyWith(
      newPassword: value,
      passwordValidations: _validatePassword(value),
    );
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  Map<String, bool> _validatePassword(String password) {
    return {
      'length': password.length >= 8,
      'hasNumber': password.contains(RegExp(r'[0-9]')),
      'hasSpecial': password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
      'hasLowercase': password.contains(RegExp(r'[a-z]')),
      'hasUppercase': password.contains(RegExp(r'[A-Z]')),
    };
  }

  bool _isPasswordValid() {
    final validations = state.passwordValidations;
    return validations.values.every((isValid) => isValid);
  }

  /// WORKING SOLUTION - Bina Deprecated Method Ke
  Future<Map<String, dynamic>> resetPassword(String email) async {
    state = state.copyWith(isLoading: true);

    // Validation 1: Empty fields
    if (state.newPassword.isEmpty || state.confirmPassword.isEmpty) {
      state = state.copyWith(isLoading: false);
      return {"success": false, "message": "Please fill all fields"};
    }

    // Validation 2: Password requirements
    if (!_isPasswordValid()) {
      state = state.copyWith(isLoading: false);
      return {"success": false, "message": "Password does not meet requirements"};
    }

    // Validation 3: Passwords match
    if (state.newPassword != state.confirmPassword) {
      state = state.copyWith(isLoading: false);
      return {"success": false, "message": "Passwords do not match"};
    }

    try {
      // Step 1: Verify OTP session (security check)
      final otpDoc = await FirebaseFirestore.instance
          .collection('password_reset_otps')
          .doc(email)
          .get();

      if (!otpDoc.exists) {
        state = state.copyWith(isLoading: false);
        return {
          "success": false,
          "message": "Invalid reset session. Please restart the process."
        };
      }

      // Step 2: Get user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('registered_emails')
          .doc(email)
          .get();

      if (!userDoc.exists) {
        state = state.copyWith(isLoading: false);
        return {"success": false, "message": "User account not found"};
      }

      final userData = userDoc.data();
      if (userData == null) {
        state = state.copyWith(isLoading: false);
        return {"success": false, "message": "User data is invalid"};
      }

      // Step 3: Get stored password
      final String? storedPassword = userData['temp_password'] ?? userData['password'];

      if (storedPassword == null || storedPassword.isEmpty) {
        state = state.copyWith(isLoading: false);
        return {
          "success": false,
          "message": "Password recovery data not found. Please contact support."
        };
      }
      // Step 4: Sign in with old password
      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: storedPassword,
        );
        // Step 5: Update password in Firebase Auth
        await userCredential.user?.updatePassword(state.newPassword);

        // Step 6: Update password in Firestore
        await FirebaseFirestore.instance
            .collection('registered_emails')
            .doc(email)
            .update({
          'temp_password': state.newPassword,
          'password': state.newPassword,
          'password_updated_at': FieldValue.serverTimestamp(),
        });

        // Step 7: Sign out user
        await FirebaseAuth.instance.signOut();

        // Step 8: Delete OTP session
        await FirebaseFirestore.instance
            .collection('password_reset_otps')
            .doc(email)
            .delete();

        state = state.copyWith(isLoading: false);
        return {
          "success": true,
          "message": "Password reset successful! Please login with your new password."
        };

      } on FirebaseAuthException catch (authError) {
        // Handle specific auth errors
        if (authError.code == 'wrong-password' || authError.code == 'invalid-credential') {

          await FirebaseFirestore.instance
              .collection('registered_emails')
              .doc(email)
              .update({
            'temp_password': state.newPassword,
            'password': state.newPassword,
            'password_updated_at': FieldValue.serverTimestamp(),
          });

          await FirebaseFirestore.instance
              .collection('password_reset_otps')
              .doc(email)
              .delete();

          state = state.copyWith(isLoading: false);
          return {
            "success": true,
            "message": "Password updated! Please login with your new password."
          };
        }

        // Other auth errors
        state = state.copyWith(isLoading: false);
        return {
          "success": false,
          "message": "Authentication error: ${authError.message}"
        };
      }

    } on FirebaseException catch (e) {
      state = state.copyWith(isLoading: false);
      return {
        "success": false,
        "message": "Database error: ${e.message}"
      };
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return {
        "success": false,
        "message": "An unexpected error occurred. Please try again."
      };
    }
  }
}

final resetPasswordProvider =
StateNotifierProvider<ResetPasswordViewModel, ResetPasswordState>((ref) {
  return ResetPasswordViewModel();
});