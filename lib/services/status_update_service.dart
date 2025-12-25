// File: lib/services/status_update_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer.dart';
import '../models/notification.dart';

class StatusUpdateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Update all customers' status when app opens
  Future<void> updateAllCustomerStatuses() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Get all customers
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('customers')
          .get();

      final batch = _firestore.batch();
      final List<Map<String, dynamic>> notificationsToAdd = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final customer = _parseCustomer(data, doc.id);

        // Calculate new status
        final newStatus = _calculateStatus(customer);

        // If status changed, update in batch
        if (customer.status != newStatus) {
          final docRef = _firestore
              .collection('users')
              .doc(user.uid)
              .collection('customers')
              .doc(doc.id);

          batch.update(docRef, {'status': newStatus});

          // Prepare notification
          notificationsToAdd.add({
            'customerId': doc.id,
            'customerName': customer.name,
            'oldStatus': customer.status,
            'newStatus': newStatus,
          });
        }
      }

      // Commit batch update
      await batch.commit();

      // Add notifications for changed statuses
      for (var notif in notificationsToAdd) {
        await _addNotification(
          user.uid,
          notif['customerId']!,
          notif['customerName']!,
          notif['newStatus']!,
        );
      }

      print('Updated ${notificationsToAdd.length} customer statuses');
    } catch (e) {
      print('Error updating statuses: $e');
    }
  }

  /// Parse customer from Firestore data
  Customer _parseCustomer(Map<String, dynamic> data, String id) {
    return Customer(
      id: id,
      name: data['fullName'] ?? '',
      fatherName: data['fatherName'] ?? '',
      cnic: data['cnic'] ?? '',
      phoneNumber: data['mobile'] ?? '',
      address: data['address'] ?? '',
      itemName: data['item']['name'] ?? '',
      totalPrice: data['item']['totalPrice'].toString(),
      deposit: data['item']['deposit'].toString(),
      monthlyInstallment: data['monthlyInstallment']?.toString() ??
          data['item']['monthlyInstallment'].toString(),
      installmentMonths: data['item']['installmentMonths'].toString(),
      totalPaid: data['totalPaid'].toString(),
      remaining: data['remaining'].toString(),
      takenDate: data['item']['takenDate'] ?? '',
      endDate: data['item']['endDate'] ?? '',
      nextDueDate: data['nextDueDate'] ?? '',
      status: data['status'] ?? 'Upcoming',
      imagePath: data['item']['imageUrl'] ?? '',
      history: List<Map<String, dynamic>>.from(data['history'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Calculate status based on customer data
  String _calculateStatus(Customer customer) {
    double paid = double.parse(customer.totalPaid.replaceAll(',', ''));
    double total = double.parse(customer.totalPrice.replaceAll(',', ''));

    DateTime today = DateTime.now();
    DateTime nextDue = DateTime.parse(customer.nextDueDate);

    // Completed Customer
    if (paid >= total) {
      return "Completed";
    }

    // Already Paid for current cycle → check if new cycle has started
    if (customer.status == "Paid") {
      if (today.isAfter(nextDue)) {
        // New month cycle started → unpaid
        return "Unpaid";
      }
      return "Paid"; // Keep as Paid
    }

    // For unpaid cycle
    if (today.year == nextDue.year &&
        today.month == nextDue.month &&
        today.day >= 1 &&
        today.day <= 5) {
      return "Unpaid";
    } else if (today.year == nextDue.year &&
        today.month == nextDue.month &&
        today.day >= 6) {
      return "Overdue";
    } else if (today.isAfter(nextDue)) {
      return "Overdue";
    }

    return customer.status; // No change
  }

  /// Add notification for status change
  Future<void> _addNotification(
      String userId,
      String customerId,
      String customerName,
      String newStatus,
      ) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .add({
        'customerId': customerId,
        'title': 'Status Updated: $newStatus',
        'message': 'Customer $customerName payment status is now $newStatus',
        'date': DateTime.now(),
        'read': false,
        'paymentDetails': {},
      });
    } catch (e) {
      print('Error adding notification: $e');
    }
  }
}

final statusUpdateServiceProvider = Provider((ref) => StatusUpdateService());