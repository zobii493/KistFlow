import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/customer.dart';
import '../../viewmodels/customer_viewmodel/view_customer_vm.dart';

class CustomerDetailViewModel extends ChangeNotifier {
  Customer customer;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref ref;

  CustomerDetailViewModel(this.customer, this.ref) {
    // Schedule status update AFTER build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateStatusOnScreenLoad();
    });
  }

  /// ==========================================================
  /// Status Update Logic Every Time Screen Opens
  /// ==========================================================
  void updateStatusOnScreenLoad() {
    double paid = double.parse(customer.totalPaid.replaceAll(',', ''));
    double total = double.parse(customer.totalPrice.replaceAll(',', ''));

    DateTime today = DateTime.now();
    DateTime nextDue = DateTime.parse(customer.nextDueDate);

    // Completed Customer
    if (paid >= total) {
      _setStatus("Completed");
      return;
    }

    // Already Paid for current cycle → check if new cycle has started
    if (customer.status == "Paid") {
      if (today.isAfter(nextDue)) {
        // New month cycle started → unpaid
        _setStatus("Unpaid");
      }
      return; // else show Paid as is
    }

    // For unpaid cycle
    if (today.year == nextDue.year &&
        today.month == nextDue.month &&
        today.day >= 1 &&
        today.day <= 5) {
      _setStatus("Unpaid");
    } else if (today.year == nextDue.year &&
        today.month == nextDue.month &&
        today.day >= 6) {
      _setStatus("Overdue");
    } else if (today.isAfter(nextDue)) {
      _setStatus("Overdue");
    }
  }

  /// ==========================================================
  /// MARK INSTALLMENT AS PAID
  /// ==========================================================
  Future<void> markInstallmentPaid() async {
    double paid = double.parse(customer.totalPaid.replaceAll(',', ''));
    double monthly = double.parse(customer.monthlyInstallment.replaceAll(',', ''));
    double total = double.parse(customer.totalPrice.replaceAll(',', ''));

    paid += monthly;
    if (paid > total) paid = total;

    customer.totalPaid = paid.toStringAsFixed(0);
    double remaining = total - paid;
    customer.remaining = remaining.toStringAsFixed(0);

    // Add history
    customer.history.add({
      "paid": monthly.toStringAsFixed(0),
      "remaining": remaining.toStringAsFixed(0),
      "date": DateTime.now().toString().split(" ").first,
    });

    // Next due date → 1 month forward
    DateTime currentDue = DateTime.parse(customer.nextDueDate);
    DateTime nextDue = DateTime(currentDue.year, currentDue.month + 1, currentDue.day);
    customer.nextDueDate = nextDue.toString().split(" ").first;

    // Status logic
    if (paid >= total) {
      customer.status = "Completed";
    } else {
      customer.status = "Paid"; // Only for current month
    }

    await _updateFirebase();
    ref.read(customerProvider.notifier).updateCustomer(customer);
    notifyListeners();
  }

  /// ==========================================================
  /// Update Firebase Helper
  /// ==========================================================
  Future<void> _updateFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('customers')
        .doc(customer.id)
        .update({
      'totalPaid': double.parse(customer.totalPaid),
      'remaining': double.parse(customer.remaining),
      'nextDueDate': customer.nextDueDate,
      'status': customer.status,
      'history': customer.history,
    });
  }

  void _setStatus(String status) {
    if (customer.status == status) return;
    customer.status = status;
    _updateFirebase();
    ref.read(customerProvider.notifier).updateCustomer(customer);
    notifyListeners();
  }
}

/// Provider
final customerDetailVMProvider =
ChangeNotifierProvider.family<CustomerDetailViewModel, Customer>(
      (ref, customer) => CustomerDetailViewModel(customer, ref),
);