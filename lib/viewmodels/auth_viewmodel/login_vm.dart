import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/auth_model/login.dart';
import '../../services/auth_service.dart';
import '../../services/auth_storage.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState());
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void setEmail(String email) {
    state = state.copyWith(email: email);
    if (!email.contains('@')) {
      state = state.copyWith(emailError: "Invalid email");
    } else {
      state = state.copyWith(emailError: null);
    }
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
    if (password.isEmpty) {
      state = state.copyWith(passwordError: "Required");
    } else {
      state = state.copyWith(passwordError: null);
    }
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  Future<void> loadSavedCredentials() async {
    final creds = await AuthStorage.loadCredentials();
    state = state.copyWith(
      rememberMe: creds['rememberMe'] ?? false,
      email: creds['email'] ?? '',
      password: creds['password'] ?? '',
    );
  }

  Future<void> saveCredentials() async {
    await AuthStorage.saveCredentials(state.email, state.password, state.rememberMe);
  }

  bool _isFormValid() {
    return state.emailError == null &&
        state.passwordError == null &&
        state.email.isNotEmpty &&
        state.password.isNotEmpty;
  }

  Future<Map<String, dynamic>> login() async {
    setEmail(state.email);
    setPassword(state.password);

    if (!_isFormValid()) {
      return {"success": false, "message": "Fix all errors"};
    }

    state = state.copyWith(isLoading: true);

    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      await userCred.user?.reload();
      if (!userCred.user!.emailVerified) {
        await _auth.signOut();
        return {
          "success": false,
          "message": "Please verify your email",
          "needsVerification": true
        };
      }

      await saveCredentials();
      await _authService.syncUserDataAfterLogin(userCred.user!);

      return {"success": true, "message": "Login successful"};
    } catch (e) {
      return {"success": false, "message": "Invalid credentials"};
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

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
}

final loginProvider =
StateNotifierProvider<LoginViewModel, LoginState>((ref) => LoginViewModel());