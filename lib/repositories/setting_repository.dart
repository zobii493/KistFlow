import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/setting/app_preference.dart';
import '../models/setting/user_profile.dart';

class SettingsRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Load user profile from Firebase
  Future<UserProfile> loadUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    try {
      // ALWAYS fetch fresh data from Firestore using current user's UID
      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)  // Current user ki UID use karo
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;

        // Save to SharedPreferences for offline access
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', data['name'] ?? user.displayName ?? 'User');
        await prefs.setString('userEmail', user.email ?? '');
        await prefs.setString('userAvatar', data['avatar'] ?? 'assets/avatars/avatar1.png');
        await prefs.setString('userId', user.uid);

        return UserProfile(
          name: data['name'] ?? user.displayName ?? 'User',
          email: user.email ?? '',
          avatar: data['avatar'] ?? 'assets/avatars/avatar1.png',
        );
      } else {
        // Agar Firestore me data nahi hai, to create karo
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName ?? 'User',
          'email': user.email,
          'avatar': 'assets/avatars/avatar1.png',
          'created_at': FieldValue.serverTimestamp(),
        });

        return UserProfile(
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          avatar: 'assets/avatars/avatar1.png',
        );
      }
    } catch (e) {
      print('Error loading from Firestore: $e');
      rethrow;
    }
  }

  // Update username in Firebase Auth, Firestore users, and registered_emails
  Future<void> updateUserName(String name) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    // 1. Update Firebase Auth displayName
    await user.updateDisplayName(name);
    await user.reload();

    // 2. Update Firestore 'users' collection
    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': user.email,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 3. Update Firestore 'registered_emails' collection
    if (user.email != null) {
      await _firestore.collection('registered_emails').doc(user.email).update({
        'name': name,
        'updated_at': FieldValue.serverTimestamp(),
      });
    }

    // 4. Update local cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  Future<void> saveUserAvatar(String avatar) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('users').doc(user.uid).set({
      'avatar': avatar,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAvatar', avatar);
  }

  // =================== PASSWORD METHODS ===================

  // Change password (requires current password for security)
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      return {"success": false, "message": "No user logged in"};
    }

    try {
      // Step 1: Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Step 2: Update password in Firebase Auth
      await user.updatePassword(newPassword);

      // Step 3: Update password in Firestore registered_emails (for reset functionality)
      if (user.email != null) {
        await _firestore.collection('registered_emails').doc(user.email).update({
          'temp_password': newPassword,
          'password': newPassword,
          'password_updated_at': FieldValue.serverTimestamp(),
        });
      }

      return {
        "success": true,
        "message": "Password changed successfully!"
      };

    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return {
          "success": false,
          "message": "Current password is incorrect"
        };
      } else if (e.code == 'weak-password') {
        return {
          "success": false,
          "message": "New password is too weak"
        };
      } else if (e.code == 'requires-recent-login') {
        return {
          "success": false,
          "message": "Please log in again before changing password"
        };
      }
      return {
        "success": false,
        "message": e.message ?? "Failed to change password"
      };
    } catch (e) {
      return {
        "success": false,
        "message": "An error occurred: $e"
      };
    }
  }

  // =================== DELETE ACCOUNT METHODS ===================

  // Delete user account (requires password for security)
  Future<Map<String, dynamic>> deleteAccount(String password) async {
    final user = _auth.currentUser;
    if (user == null) {
      return {"success": false, "message": "No user logged in"};
    }

    try {
      // Step 1: Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // Step 2: Delete user data from Firestore
      final batch = _firestore.batch();

      // Delete from 'users' collection
      batch.delete(_firestore.collection('users').doc(user.uid));

      // Delete from 'registered_emails' collection
      if (user.email != null) {
        batch.delete(_firestore.collection('registered_emails').doc(user.email));
      }

      // Optional: Delete user's other data (kists, payments, etc.)
      // You can add more collections here if needed
      final kistsSnapshot = await _firestore
          .collection('kists')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in kistsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // Step 3: Delete Firebase Auth account
      await user.delete();

      // Step 4: Clear local data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      return {
        "success": true,
        "message": "Account deleted successfully"
      };

    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return {
          "success": false,
          "message": "Incorrect password"
        };
      } else if (e.code == 'requires-recent-login') {
        return {
          "success": false,
          "message": "Please log in again before deleting account"
        };
      }
      return {
        "success": false,
        "message": e.message ?? "Failed to delete account"
      };
    } catch (e) {
      return {
        "success": false,
        "message": "An error occurred: $e"
      };
    }
  }

  // App Preferences methods
  Future<AppPreferences> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferences(
      theme: prefs.getString('theme') ?? 'light',
      notificationsEnabled: prefs.getBool('notificationsEnabled') ?? true,
      reminderAlerts: prefs.getBool('reminderAlerts') ?? true,
      overdueAlerts: prefs.getBool('overdueAlerts') ?? true,
    );
  }

  Future<void> savePreferences(AppPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', preferences.theme);
    await prefs.setBool('notificationsEnabled', preferences.notificationsEnabled);
    await prefs.setBool('reminderAlerts', preferences.reminderAlerts);
    await prefs.setBool('overdueAlerts', preferences.overdueAlerts);
  }
}