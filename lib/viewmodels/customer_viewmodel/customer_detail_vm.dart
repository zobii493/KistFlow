import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/customer.dart';

class CustomerDetailViewModel extends ChangeNotifier {
  Customer customer;

  CustomerDetailViewModel(this.customer) {
    checkAndUpdateStatus(); // Auto update as soon as vm is created
  }

  // Auto Status Logic
  void checkAndUpdateStatus() {
    DateTime today = DateTime.now();
    DateTime nextDue = DateTime.parse(customer.nextDueDate);
    double paid = double.parse(customer.totalPaid);
    double total = double.parse(customer.totalPrice);

    // IF FULLY PAID → COMPLETE
    if (paid >= total) {
      customer.status = "Completed";
      notifyListeners();
      return;
    }

    // ----- MONTHLY STATUS LOGIC -----

    // 1–5 → UNPAID
    if (today.year == nextDue.year &&
        today.month == nextDue.month &&
        today.day <= 5) {
      customer.status = "Unpaid";
    }

    // 6 DATE SE AGAY → OVERDUE
    else if (today.year == nextDue.year &&
        today.month == nextDue.month &&
        today.day >= 6) {
      customer.status = "Overdue";
    }

    // Otherwise Upcoming (future due date)
    else if (today.isBefore(nextDue)) {
      customer.status = "Upcoming";
    }

    notifyListeners();
  }

  // -------------------------
  // 📌 PAY INSTALLMENT LOGIC
  // -------------------------
  void markInstallmentPaid() {
    double paid = double.parse(customer.totalPaid);
    double monthly = double.parse(customer.monthlyInstallment);
    double total = double.parse(customer.totalPrice);

    paid += monthly;
    if (paid > total) paid = total;

    customer.totalPaid = paid.toStringAsFixed(0);
    double remaining = total - paid;
    customer.remaining = remaining.toStringAsFixed(0);

    // Add Payment History
    customer.history.add({
      "paid": monthly.toStringAsFixed(0),
      "remaining": remaining.toStringAsFixed(0),
      "date": DateTime.now().toString().split(" ").first,
    });

    // NEXT MONTH DUE DATE UPDATE
    DateTime next = DateTime.parse(customer.nextDueDate);
    DateTime updated = DateTime(next.year, next.month + 1, next.day);
    customer.nextDueDate = updated.toString().split(" ").first;

    // Check if fully completed
    if (paid >= total) {
      customer.status = "Completed";
    } else {
      customer.status = "Paid"; // just paid for the month
    }

    notifyListeners();
  }
}


final customerDetailVMProvider =
ChangeNotifierProvider.family<CustomerDetailViewModel, Customer>(
      (ref, customer) => CustomerDetailViewModel(customer),
);
