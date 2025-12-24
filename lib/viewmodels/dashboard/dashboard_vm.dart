import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/app_colors.dart';
import '../../models/customer.dart';
import '../../models/dashboard.dart';

class DashboardViewModel extends StateNotifier<DashboardState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DashboardViewModel()
      : super(DashboardState(
    cards: [],
    barData: [],
    pieData: [],
    lineData: [],
  )) {
    loadDashboardData();
  }

  /// Main method to load all dashboard data
  Future<void> loadDashboardData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Listen to customers collection for real-time updates
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('customers')
        .snapshots()
        .listen((snapshot) {
      final customers = snapshot.docs
          .map((doc) => Customer.fromFirestore(doc.data(), doc.id))
          .toList();

      _calculateDashboardStats(customers);
    });
  }

  /// Calculate all dashboard statistics
  void _calculateDashboardStats(List<Customer> customers) {
    // 1. CARDS DATA
    final totalCustomers = customers.length;
    final paidCount = customers.where((c) => c.status == 'Paid').length;
    final unpaidCount = customers.where((c) => c.status == 'Unpaid').length;
    final overdueCount = customers.where((c) => c.status == 'Overdue').length;
    final upcomingCount = customers.where((c) => c.status == 'Upcoming').length;
    final completedCount = customers.where((c) => c.status == 'Completed').length;

    final cards = [
      {
        'title': 'Total\nCustomers',
        'value': totalCustomers.toString(),
        'icon': Icons.person_3_outlined,
        'type': 'total',
      },
      {
        'title': 'Paid\nInstallments',
        'value': paidCount.toString(),
        'icon': Icons.check_circle,
        'type': 'paid',
      },
      {
        'title': 'Unpaid\nInstallments',
        'value': unpaidCount.toString(),
        'icon': Icons.warning,
        'type': 'unpaid',
      },
      {
        'title': 'Overdue\nInstallments',
        'value': overdueCount.toString(),
        'icon': Icons.cancel,
        'type': 'overdue',
      },
    ];

    // 2. BAR CHART DATA - Last 6 months collection
    final barData = _calculateMonthlyCollection(customers);

    // 3. PIE CHART DATA - Paid vs Unpaid vs Overdue percentage
    final pieData = _calculatePieChartData(customers);

    // 4. LINE CHART DATA - Last 4 weeks payment rate
    final lineData = _calculateWeeklyPaymentRate(customers);

    // Update state
    state = DashboardState(
      cards: cards,
      barData: barData,
      pieData: pieData,
      lineData: lineData,
    );
  }

  /// Calculate monthly collection for last 6 months
  List<double> _calculateMonthlyCollection(List<Customer> customers) {
    final now = DateTime.now();
    final List<double> monthlyCollection = List.filled(6, 0.0);

    for (var customer in customers) {
      for (var payment in customer.history) {
        try {
          final paymentDate = DateTime.parse(payment['date']);
          final monthsDiff = _monthsDifference(paymentDate, now);

          // Only last 6 months
          if (monthsDiff >= 0 && monthsDiff < 6) {
            final paid = double.parse(payment['paid'].toString());
            monthlyCollection[5 - monthsDiff] += paid;
          }
        } catch (e) {
          // Skip invalid dates
        }
      }
    }

    return monthlyCollection;
  }

  /// Calculate pie chart percentages
  List<double> _calculatePieChartData(List<Customer> customers) {
    if (customers.isEmpty) return [0, 0, 0, 0, 0];

    final total = customers.length.toDouble();
    final paid = customers.where((c) => c.status == 'Paid').length;
    final unpaid = customers.where((c) => c.status == 'Unpaid').length;
    final overdue = customers.where((c) => c.status == 'Overdue').length;
    final upcoming = customers.where((c) => c.status == 'Upcoming').length;
    final completed = customers.where((c) => c.status == 'Completed').length;

    return [
      (paid / total) * 100,
      (unpaid / total) * 100,
      (overdue / total) * 100,
      (upcoming / total) * 100,
      (completed / total) * 100,
    ];
  }

  /// Calculate weekly payment rate for last 4 weeks
  List<double> _calculateWeeklyPaymentRate(List<Customer> customers) {
    final now = DateTime.now();
    final List<double> weeklyCollection = List.filled(4, 0.0);

    // Get start of current week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    for (var customer in customers) {
      // Check each payment in history
      for (var payment in customer.history) {
        try {
          final paymentDate = DateTime.parse(payment['date']);
          final daysDiff = startOfWeek.difference(paymentDate).inDays;

          // Determine which week this payment belongs to (0-3 for last 4 weeks)
          int weekIndex = -1;
          if (daysDiff < 0) {
            // Current week
            weekIndex = 3;
          } else if (daysDiff < 7) {
            // Last week
            weekIndex = 2;
          } else if (daysDiff < 14) {
            // 2 weeks ago
            weekIndex = 1;
          } else if (daysDiff < 21) {
            // 3 weeks ago
            weekIndex = 0;
          }

          if (weekIndex >= 0) {
            final paid = double.parse(payment['paid'].toString());
            weeklyCollection[weekIndex] += paid;
          }
        } catch (e) {
          // Skip invalid dates/amounts
        }
      }
    }

    // Calculate total collection for normalization
    final totalCollection = weeklyCollection.reduce((a, b) => a + b);

    // If no collection at all, return zeros
    if (totalCollection == 0) {
      return [0, 0, 0, 0];
    }

    // Convert to percentage of total
    return weeklyCollection.map((amount) {
      final percent = (amount / totalCollection) * 100;
      return percent;
    }).toList();
  }

  /// Helper: Calculate months difference
  int _monthsDifference(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }

  /// Helper: Calculate weeks difference
  int _weeksDifference(DateTime from, DateTime to) {
    return to.difference(from).inDays ~/ 7;
  }

  /// Refresh dashboard manually
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

}

final notificationCountProvider = Provider<int>((ref) {
  return 2; // Firebase se ayega
});

final dashboardProvider =
StateNotifierProvider<DashboardViewModel, DashboardState>(
      (ref) => DashboardViewModel(),
);