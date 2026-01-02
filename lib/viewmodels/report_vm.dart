import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/customer.dart';
import '../models/report.dart';

class ReportViewModel extends StateNotifier<AsyncValue<ReportState>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedPeriod = "This Year";
  StreamSubscription<QuerySnapshot>? _subscription;

  ReportViewModel() : super(const AsyncLoading()) {
    _listenToCustomerChanges();
  }

  void updatePeriod(String value) {
    selectedPeriod = value;
    _listenToCustomerChanges(); // reload with new period
  }

  void _listenToCustomerChanges() {
    // Cancel previous subscription if exists
    _subscription?.cancel();

    state = const AsyncLoading();

    final user = _auth.currentUser;
    if (user == null) return;

    _subscription = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('customers')
        .snapshots()
        .listen(
          (snapshot) {
            final customers = snapshot.docs
                .map((doc) => Customer.fromFirestore(doc.data(), doc.id))
                .toList();

            final report = _calculateReportStats(customers);
            state = AsyncData(report);
          },
          onError: (error) {
            state = AsyncError(error, StackTrace.current);
          },
        );
  }

  ReportState _calculateReportStats(List<Customer> customers) {
    // OVERALL (ALL TIME) — NO FILTER
    final totalRev = _calculateTotalRevenue(customers);
    final expectedRev = _calculateExpectedRevenue(customers);
    final collRate = _calculateCollectionRate(totalRev, expectedRev);
    final pendingAmount = _calculatePending(customers);

    final custGrowth = _calculateCustomerGrowth(customers);
    final categories = _calculateCategories(customers);
    final topPerformers = _calculateTopItems(customers);

    final revenueGrowth = _calculateGrowth(customers, 'revenue');
    final collectionGrowth = _calculateGrowth(customers, 'collection');

    // FILTERED — ONLY FOR REVENUE TREND
    final filteredForTrend = _filterByPeriod(customers);
    final revData = _calculateRevenueTrend(filteredForTrend);

    return ReportState(
      totalRevenue: {
        'title': 'Total Revenue',
        'value': _formatNumber(totalRev),
        'status': revenueGrowth['text'],
        'statusColor': revenueGrowth['isPositive'] ? Colors.green : Colors.red,
        'statusIcon': revenueGrowth['isPositive']
            ? Icons.arrow_upward
            : Icons.arrow_downward,
      },
      expected: {
        'title': 'Expected',
        'value': _formatNumber(expectedRev),
        'status': 'full payment',
        'statusColor': Colors.lightBlueAccent,
        'statusIcon': Icons.check_circle,
      },
      collectionRate: {
        'title': 'Collection Rate',
        'value': collRate.toStringAsFixed(0),
        'status': collectionGrowth['text'],
        'statusColor': collectionGrowth['isPositive']
            ? Colors.deepOrange
            : Colors.red,
        'statusIcon': collectionGrowth['isPositive']
            ? Icons.arrow_upward
            : Icons.arrow_downward,
      },
      pending: {
        'title': 'Pending',
        'value': _formatNumber(pendingAmount),
        'status':
            '${customers.where((c) => c.status == 'Overdue').length} overdue',
        'statusColor': Colors.redAccent,
        'statusIcon': Icons.watch_later_rounded,
      },
      revenueData: revData,
      // filtered only here
      customerGrowthData: custGrowth,
      categoryData: categories,
      topItems: topPerformers,
    );
  }

  List<Customer> _filterByPeriod(List<Customer> customers) {
    final now = DateTime.now();

    return customers.where((customer) {
      final createdAt = customer.createdAt;

      switch (selectedPeriod) {
        case 'This Week':
          final weekAgo = now.subtract(const Duration(days: 7));
          return createdAt.isAfter(weekAgo);

        case 'This Month':
          return createdAt.month == now.month && createdAt.year == now.year;

        case 'This Year':
          return createdAt.year == now.year;

        case 'Last Year':
          return createdAt.year == now.year - 1;

        default:
          return true;
      }
    }).toList();
  }

  double _calculateTotalRevenue(List<Customer> customers) => customers.fold(
    0.0,
    (sum, c) => sum + double.parse(c.totalPaid.replaceAll(',', '')),
  );

  double _calculateExpectedRevenue(List<Customer> customers) => customers.fold(
    0.0,
    (sum, c) => sum + double.parse(c.totalPrice.replaceAll(',', '')),
  );

  double _calculateCollectionRate(double total, double expected) =>
      expected == 0 ? 0 : (total / expected) * 100;

  double _calculatePending(List<Customer> customers) => customers.fold(
    0.0,
    (sum, c) => sum + double.parse(c.remaining.replaceAll(',', '')),
  );

  List<Map<String, dynamic>> _calculateRevenueTrend(List<Customer> customers) {
    final now = DateTime.now();

    // Decide chart year
    int chartYear = now.year;
    if (selectedPeriod == 'Last Year') {
      chartYear = now.year - 1;
    }

    final List<Map<String, dynamic>> monthlyData = [];

    for (int i = 0; i < 12; i++) {
      final month = DateTime(chartYear, i + 1);
      double revenue = 0.0;

      for (var customer in customers) {
        for (var payment in customer.history) {
          try {
            final paymentDate = DateTime.parse(payment['date']);
            if (paymentDate.month == month.month &&
                paymentDate.year == month.year) {
              revenue += double.parse(payment['paid'].toString());
            }
          } catch (_) {}
        }
      }

      monthlyData.add({'month': i, 'revenue': revenue});
    }

    return monthlyData;
  }

  List<Map<String, dynamic>> _calculateCustomerGrowth(
    List<Customer> customers,
  ) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> growthData = [];

    for (int i = 0; i < 6; i++) {
      final month = DateTime(now.year, now.month - (5 - i));
      final count = customers
          .where(
            (c) =>
                c.createdAt.month == month.month &&
                c.createdAt.year == month.year,
          )
          .length;
      growthData.add({'month': i, 'count': count});
    }

    return growthData;
  }

  List<Map<String, dynamic>> _calculateCategories(List<Customer> customers) {
    final Map<String, int> categoryCount = {};

    for (var customer in customers) {
      final item = customer.itemName.toLowerCase();
      String category = 'Others';

      // Electronics
      if (item.contains('phone') ||
          item.contains('mobile') ||
          item.contains('mob') ||
          item.contains('samsung') ||
          item.contains('redmi') ||
          item.contains('vivo') ||
          item.contains('oppo') ||
          item.contains('realme') ||
          item.contains('laptop') ||
          item.contains('iphone') ||
          item.contains('tablet')) {
        category = 'Electronics';
      }
      // Motorcycle (NEW)
      else if (item.contains('bike') ||
          item.contains('motorcycle') ||
          item.contains('motor bike') ||
          item.contains('honda') ||
          item.contains('yamaha') ||
          item.contains('suzuki') ||
          item.contains('unique') ||
          item.contains('super power') ||
          item.contains('road prince') ||
          item.contains('cg125') ||
          item.contains('cd70')) {
        category = 'Motorcycle';
      }
      // Appliances
      else if (item.contains('fridge') ||
          item.contains('ac') ||
          item.contains('washing machine') ||
          item.contains('iron') ||
          item.contains('battery') ||
          item.contains('microwave')) {
        category = 'Appliances';
      }
      // Furniture
      else if (item.contains('sofa') ||
          item.contains('bed') ||
          item.contains('table') ||
          item.contains('chair')) {
        category = 'Furniture';
      }

      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }

    final total = categoryCount.values.fold(0, (a, b) => a + b);
    if (total == 0) return [];

    return categoryCount.entries
        .map((e) => {'name': e.key, 'percentage': (e.value / total) * 100})
        .toList();
  }

  List<Map<String, dynamic>> _calculateTopItems(List<Customer> customers) {
    final Map<String, Map<String, dynamic>> itemStats = {};

    for (var customer in customers) {
      final itemName = customer.itemName;
      itemStats[itemName] ??= {'name': itemName, 'units': 0, 'revenue': 0.0};
      itemStats[itemName]!['units']++;
      itemStats[itemName]!['revenue'] += double.parse(
        customer.totalPrice.replaceAll(',', ''),
      );
    }

    final sortedItems = itemStats.values.toList()
      ..sort(
        (a, b) => (b['revenue'] as double).compareTo(a['revenue'] as double),
      );

    return sortedItems.take(3).toList();
  }

  Map<String, dynamic> _calculateGrowth(List<Customer> customers, String type) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    final twoMonthsAgo = DateTime(now.year, now.month - 2);

    double currentValue = 0, previousValue = 0;

    if (type == 'revenue') {
      for (var customer in customers) {
        for (var payment in customer.history) {
          try {
            final date = DateTime.parse(payment['date']);
            final paid = double.parse(payment['paid'].toString());
            if (date.month == lastMonth.month && date.year == lastMonth.year)
              currentValue += paid;
            else if (date.month == twoMonthsAgo.month &&
                date.year == twoMonthsAgo.year)
              previousValue += paid;
          } catch (e) {}
        }
      }
    } else {
      currentValue = customers
          .where(
            (c) =>
                c.createdAt.month == lastMonth.month &&
                c.createdAt.year == lastMonth.year,
          )
          .length
          .toDouble();
      previousValue = customers
          .where(
            (c) =>
                c.createdAt.month == twoMonthsAgo.month &&
                c.createdAt.year == twoMonthsAgo.year,
          )
          .length
          .toDouble();
    }

    if (previousValue == 0)
      return {
        'text': currentValue > 0 ? 'New data this month' : 'No data yet',
        'isPositive': currentValue > 0,
      };

    final growth = ((currentValue - previousValue) / previousValue) * 100;
    return {
      'text': '${growth.abs().toStringAsFixed(0)}% from last month',
      'isPositive': growth >= 0,
    };
  }

  String _formatNumber(double value) {
    // Always return full number with commas
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

final reportVMProvider =
    StateNotifierProvider<ReportViewModel, AsyncValue<ReportState>>(
      (ref) => ReportViewModel(),
    );
