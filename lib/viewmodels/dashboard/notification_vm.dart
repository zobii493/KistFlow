import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../models/notification.dart';

class NotificationViewModel extends StateNotifier<List<NotificationModel>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  NotificationViewModel(this.userId) : super([]) {
    _listenNotifications();
  }

  void _listenNotifications() {
    _firestore.collection('notifications')
        .doc(userId)
        .collection('userNotifications')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      state = snapshot.docs.map((doc) =>
          NotificationModel.fromFirestore(doc.data(), doc.id)
      ).toList();
    });
  }

  Future<void> addNotification(NotificationModel notification) async {
    await _firestore.collection('notifications')
        .doc(userId)
        .collection('userNotifications')
        .add(notification.toFirestore());
  }

  int get unreadCount => state.where((n) => !n.read).length;
}
final notificationProvider = StateNotifierProvider<NotificationViewModel, List<NotificationModel>>(
      (ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return NotificationViewModel(userId);
  },
);
