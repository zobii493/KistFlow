import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/auth_service.dart';
import '../../models/auth_model/signup.dart';

class SignupViewModel extends StateNotifier<SignupState> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SignupViewModel() : super(SignupState());

  void setName(String name) {
    state = state.copyWith(name: name);
    _validateName();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
    _validateEmail();
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
    _validatePassword();
    if (state.confirmPassword.isNotEmpty) {
      _validateConfirmPassword();
    }
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
    _validateConfirmPassword();
  }

  // Validate name
  void _validateName() {
    if (state.name.isEmpty) {
      state = state.copyWith(nameError: 'Name is required');
    } else if (state.name.length < 3) {
      state = state.copyWith(nameError: 'Name must be at least 3 characters');
    } else {
      state = state.copyWith(nameError: null);
    }
  }

  // Validate email
  Future<void> _validateEmail() async {
    final email = state.email.trim();

    if (email.isEmpty) {
      state = state.copyWith(emailError: 'Email is required');
      return;
    }

    if (!_authService.isValidEmail(email)) {
      state = state.copyWith(emailError: 'Invalid email format');
      return;
    }

    // Email valid format → Remove error now
    state = state.copyWith(emailError: null);
    // Show loader during checking
    state = state.copyWith(isCheckingEmail: true);
    state = state.copyWith(isCheckingEmail: false);
  }

  // Validate password
  void _validatePassword() {
    final validations = _authService.validatePassword(state.password);

    state = state.copyWith(passwordValidations: validations);

    if (state.password.isEmpty) {
      state = state.copyWith(passwordError: 'Password is required');
    } else if (!_authService.isPasswordValid(state.password)) {
      state = state.copyWith(passwordError: 'Password does not meet requirements');
    } else {
      state = state.copyWith(passwordError: null);
    }

    // Also validate confirm password if it's filled
    if (state.confirmPassword.isNotEmpty) {
      _validateConfirmPassword();
    }
  }

  // Validate confirm password
  void _validateConfirmPassword() {
    if (state.confirmPassword.isEmpty) {
      state = state.copyWith(confirmPasswordError: 'Please confirm password');
    } else if (state.password != state.confirmPassword) {
      state = state.copyWith(confirmPasswordError: 'Passwords do not match');
    } else {
      state = state.copyWith(confirmPasswordError: null);
    }
  }

  // Check if form is valid
  bool _isFormValid() {
    return state.name.isNotEmpty &&
        state.nameError == null &&
        state.email.isNotEmpty &&
        state.emailError == null &&
        state.password.isNotEmpty &&
        state.passwordError == null &&
        state.confirmPassword.isNotEmpty &&
        state.confirmPasswordError == null;
  }

  // Forward call to AuthService
  Future<UserCredential?> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _authService.signInWithGoogle();
      return result;
    } catch (e) {
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // UPDATED Sign up - Now stores password for reset functionality
  Future<Map<String, dynamic>> signup() async {
    if (!_isFormValid()) {
      return {"success": false, "message": "Please fix the errors first"};
    }

    state = state.copyWith(isLoading: true);

    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      final user = userCred.user;
      await user?.updateDisplayName(state.name);
      await user?.reload();

      if (user == null) {
        state = state.copyWith(isLoading: false);
        return {"success": false, "message": "Failed to create user account"};
      }

      // Save to BOTH collections
      final userData = {
        'uid': user.uid,
        'email': state.email,
        'name': state.name,
        'temp_password': state.password,
        'password': state.password,
        'created_at': FieldValue.serverTimestamp(),
        'email_verified': false,
      };

      // 1. Save to registered_emails
      await FirebaseFirestore.instance
          .collection('registered_emails')
          .doc(state.email)
          .set(userData);

      // 2. Save to users collection (by UID)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name': state.name,
        'email': state.email,
        'avatar': 'assets/avatars/avatar15.png',
        'created_at': FieldValue.serverTimestamp(),
      });

      await user.sendEmailVerification();

      state = state.copyWith(isLoading: false);
      return {
        "success": true,
        "message": "Account created successfully! Verification email sent."
      };

    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false);
      if (e.code == 'email-already-in-use') {
        return {"success": false, "message": "This email is already registered."};
      }
      return {"success": false, "message": e.message ?? "Signup failed."};
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return {"success": false, "message": "An unexpected error occurred: $e"};
    }
  }

  // Clear form
  void clearForm() {
    state = SignupState();
  }
}

final signupProvider = StateNotifierProvider<SignupViewModel, SignupState>((ref) {
  return SignupViewModel();
});