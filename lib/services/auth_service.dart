import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\$');
    return emailRegex.hasMatch(email);
  }

  Map<String, bool> validatePassword(String password) {
    return {
      'length': password.length >= 8,
      'hasNumber': password.contains(RegExp(r'[0-9]')),
      'hasSpecial': password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
      'hasLowercase': password.contains(RegExp(r'[a-z]')),
      'hasUppercase': password.contains(RegExp(r'[A-Z]')),
    };
  }

  bool isPasswordValid(String password) {
    return validatePassword(password).values.every((v) => v);
  }


  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  /// Always check Google sign in initialization before use
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();
    try {
      // Step 1: Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return null; // User cancelled

      // Step 2: Get Google authentication
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Step 3: Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in with Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
}


  Future<void> saveUserEmail(String email) async {
    await FirebaseFirestore.instance
        .collection('registered_emails')
        .doc(email)
        .set({
      "email": email,
      "createdAt": DateTime.now(),
    });
  }

  Future<void> syncUserDataAfterLogin(User user) async {
    try {
      // Firestore se latest data fetch karo
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;

        // SharedPreferences me save karo
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'userName', data['name'] ?? user.displayName ?? 'User');
        await prefs.setString('userEmail', user.email ?? '');
        await prefs.setString(
            'userAvatar', data['avatar'] ?? 'assets/avatars/avatar1.png');
        await prefs.setString('userId', user.uid);
      } else {
        // Agar Firestore me data nahi hai to Auth se save karo
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', user.displayName ?? 'User');
        await prefs.setString('userEmail', user.email ?? '');
        await prefs.setString('userAvatar', 'assets/avatars/avatar1.png');
        await prefs.setString('userId', user.uid);
      }
    } catch (e) {
      print('Error syncing user data: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
