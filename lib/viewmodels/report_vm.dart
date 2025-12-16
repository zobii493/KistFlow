import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/customer.dart';
import '../models/report.dart';

class ReportViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedPeriod = "This Year";
  ReportState? state;
  ReportViewModel() {
    loadReportData();
  }

  void updatePeriod(String value) {
    selectedPeriod = value;
    notifyListeners();
    loadReportData(); // Reload data based on period
  }

  Future<void> loadReportData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('customers')
        .snapshots()
        .listen((snapshot) {
      final customers = snapshot.docs
          .map((doc) => Customer.fromFirestore(doc.data(), doc.id))
          .toList();

      _calculateReportStats(customers);
    });
  }

  void _calculateReportStats(List<Customer> customers) {
    // Filter customers based on selected period
    final filteredCustomers = _filterByPeriod(customers);

    // 1. CARDS DATA
    final totalRev = _calculateTotalRevenue(filteredCustomers);
    final expectedRev = _calculateExpectedRevenue(filteredCustomers);
    final collRate = _calculateCollectionRate(totalRev, expectedRev);
    final pendingAmount = _calculatePending(filteredCustomers);

    // 2. REVENUE TREND DATA
    final revData = _calculateRevenueTrend(customers);

    // 3. CUSTOMER GROWTH DATA
    final custGrowth = _calculateCustomerGrowth(customers);

    // 4. CATEGORY DATA
    final categories = _calculateCategories(filteredCustomers);

    // 5. TOP PERFORMING ITEMS
    final topPerformers = _calculateTopItems(filteredCustomers);

    // Growth calculations
    final revenueGrowth = _calculateGrowth(customers, 'revenue');
    final collectionGrowth = _calculateGrowth(customers, 'collection');

    state = ReportState(
      totalRevenue: {
        'title': 'Total Revenue',
        'value': _formatNumber(totalRev),
        'status': revenueGrowth['text'],
        'statusColor': revenueGrowth['isPositive'] ? Colors.green : Colors.red,
        'statusIcon': revenueGrowth['isPositive'] ? Icons.arrow_upward : Icons.arrow_downward,
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
        'statusColor': collectionGrowth['isPositive'] ? Colors.deepOrange : Colors.red,
        'statusIcon': collectionGrowth['isPositive'] ? Icons.arrow_upward : Icons.arrow_downward,
      },
      pending: {
        'title': 'Pending',
        'value': _formatNumber(pendingAmount),
        'status': '${customers.where((c) => c.status == 'Overdue').length} overdue',
        'statusColor': Colors.redAccent,
        'statusIcon': Icons.watch_later_rounded,
      },
      revenueData: revData,
      customerGrowthData: custGrowth,
      categoryData: categories,
      topItems: topPerformers,
    );

    notifyListeners();
  }

  List<Customer> _filterByPeriod(List<Customer> customers) {
    final now = DateTime.now();

    return customers.where((customer) {
      final createdAt = customer.createdAt;

      switch (selectedPeriod) {
        case 'This Week':
          final weekAgo = now.subtract(Duration(days: 7));
          return createdAt.isAfter(weekAgo);
        case 'This Month':
          return createdAt.month == now.month && createdAt.year == now.year;
        case 'This Year':
        default:
          return createdAt.year == now.year;
      }
    }).toList();
  }

  double _calculateTotalRevenue(List<Customer> customers) {
    return customers.fold(0.0, (sum, customer) {
      return sum + double.parse(customer.totalPaid.replaceAll(',', ''));
    });
  }

  double _calculateExpectedRevenue(List<Customer> customers) {
    return customers.fold(0.0, (sum, customer) {
      return sum + double.parse(customer.totalPrice.replaceAll(',', ''));
    });
  }

  double _calculateCollectionRate(double total, double expected) {
    if (expected == 0) return 0;
    return (total / expected) * 100;
  }

  double _calculatePending(List<Customer> customers) {
    return customers.fold(0.0, (sum, customer) {
      return sum + double.parse(customer.remaining.replaceAll(',', ''));
    });
  }

  List<Map<String, dynamic>> _calculateRevenueTrend(List<Customer> customers) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> monthlyData = [];

    for (int i = 0; i < 12; i++) {
      final month = DateTime(now.year, i + 1);
      double revenue = 0.0;

      for (var customer in customers) {
        for (var payment in customer.history) {
          try {
            final paymentDate = DateTime.parse(payment['date']);
            if (paymentDate.month == month.month && paymentDate.year == month.year) {
              revenue += double.parse(payment['paid'].toString());
            }
          } catch (e) {
            // Skip invalid data
          }
        }
      }

      monthlyData.add({'month': i, 'revenue': revenue});
    }

    return monthlyData;
  }

  List<Map<String, dynamic>> _calculateCustomerGrowth(List<Customer> customers) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> growthData = [];

    for (int i = 0; i < 6; i++) {
      final month = DateTime(now.year, now.month - (5 - i));
      final count = customers.where((c) {
        return c.createdAt.month == month.month && c.createdAt.year == month.year;
      }).length;

      growthData.add({'month': i, 'count': count});
    }

    return growthData;
  }

  List<Map<String, dynamic>> _calculateCategories(List<Customer> customers) {
    final Map<String, int> categoryCount = {};

    for (var customer in customers) {
      final item = customer.itemName.toLowerCase();

      String category = 'Others';
      if (item.contains('phone') || item.contains('mobile') || item.contains('samsung') ||
          item.contains('iphone') || item.contains('tablet')) {
        category = 'Electronics';
      } else if (item.contains('fridge') || item.contains('ac') || item.contains('washing') ||
          item.contains('microwave')) {
        category = 'Appliances';
      } else if (item.contains('sofa') || item.contains('bed') || item.contains('table') ||
          item.contains('chair')) {
        category = 'Furniture';
      }

      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }

    final total = categoryCount.values.fold(0, (a, b) => a + b);
    if (total == 0) return [];

    return categoryCount.entries.map((entry) {
      return {
        'name': entry.key,
        'percentage': (entry.value / total) * 100,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _calculateTopItems(List<Customer> customers) {
    final Map<String, Map<String, dynamic>> itemStats = {};

    for (var customer in customers) {
      final itemName = customer.itemName;
      if (!itemStats.containsKey(itemName)) {
        itemStats[itemName] = {
          'name': itemName,
          'units': 0,
          'revenue': 0.0,
        };
      }
      itemStats[itemName]!['units']++;
      itemStats[itemName]!['revenue'] += double.parse(customer.totalPrice.replaceAll(',', ''));
    }

    final sortedItems = itemStats.values.toList()
      ..sort((a, b) => (b['revenue'] as double).compareTo(a['revenue'] as double));

    return sortedItems.take(3).toList();
  }

  Map<String, dynamic> _calculateGrowth(List<Customer> customers, String type) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    final twoMonthsAgo = DateTime(now.year, now.month - 2);

    double currentValue = 0;
    double previousValue = 0;

    if (type == 'revenue') {
      for (var customer in customers) {
        for (var payment in customer.history) {
          try {
            final date = DateTime.parse(payment['date']);
            final paid = double.parse(payment['paid'].toString());

            if (date.month == lastMonth.month && date.year == lastMonth.year) {
              currentValue += paid;
            } else if (date.month == twoMonthsAgo.month && date.year == twoMonthsAgo.year) {
              previousValue += paid;
            }
          } catch (e) {}
        }
      }
    } else {
      currentValue = customers.where((c) {
        return c.createdAt.month == lastMonth.month && c.createdAt.year == lastMonth.year;
      }).length.toDouble();

      previousValue = customers.where((c) {
        return c.createdAt.month == twoMonthsAgo.month && c.createdAt.year == twoMonthsAgo.year;
      }).length.toDouble();
    }

    if (previousValue == 0) {
      return {
        'text': currentValue > 0 ? 'New data this month' : 'No data yet',
        'isPositive': currentValue > 0,
      };
    }

    final growth = ((currentValue - previousValue) / previousValue) * 100;
    final isPositive = growth >= 0;

    return {
      'text': '${growth.abs().toStringAsFixed(0)}% from last month',
      'isPositive': isPositive,
    };
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}

final reportVMProvider = ChangeNotifierProvider.autoDispose<ReportViewModel>((ref) {
  return ReportViewModel();
});