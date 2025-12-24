import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserProfileVM extends StateNotifier<String> {
  UserProfileVM() : super('') {
    _listenUserName();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  StreamSubscription? _sub;

  void _listenUserName() {
    final user = _auth.currentUser;
    if (user == null) return;

    _sub = _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((doc) {
      state = doc.data()?['name'] ??
          user.displayName ??
          'User';
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
final userProfileProvider = StateNotifierProvider<UserProfileVM, String>((ref) { return UserProfileVM(); });