import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../core/app_colors.dart';
import '../models/dashboard.dart';

class DashboardViewModel extends StateNotifier<DashboardState> {
  DashboardViewModel()
      : super(DashboardState(
    cards: [
      {
        'title': 'Total\nCustomers',
        'value': '32',
        'icon': Icons.person_3_outlined,
        'bgColor': AppColors.skyBlue,
        'iconColor': AppColors.skyBlue,
      },
      {
        'title': 'Paid\nInstallments',
        'value': '58',
        'icon': Icons.check_circle,
        'bgColor': AppColors.coolMint,
        'iconColor': AppColors.slateGray.withOpacity(0.7),
      },
      {
        'title': 'Unpaid\nInstallments',
        'value': '12',
        'icon': Icons.warning,
        'bgColor': AppColors.warmAmber.withOpacity(0.2),
        'iconColor': AppColors.warmAmber,
      },
      {
        'title': 'Overdue\nInstallments',
        'value': '19',
        'icon': Icons.cancel,
        'bgColor': AppColors.lightPink,
        'iconColor': AppColors.lightPink,
      },
    ],
    barData: [15, 22, 10, 25, 18, 23],
    pieData: [70, 15, 15],
    lineData: [75, 82, 78, 90],
  ));

  // Example: update a card value
  void updateCardValue(int index, String value) {
    final updated = [...state.cards];
    updated[index]['value'] = value;
    state = DashboardState(
      cards: updated,
      barData: state.barData,
      pieData: state.pieData,
      lineData: state.lineData,
    );
  }
}

final dashboardProvider =
StateNotifierProvider<DashboardViewModel, DashboardState>(
        (ref) => DashboardViewModel());