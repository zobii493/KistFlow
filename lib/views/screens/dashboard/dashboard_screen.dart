import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/views/screens/dashboard/widgets/bar_chart.dart';
import 'package:kistflow/views/screens/dashboard/widgets/line_chart.dart';
import 'package:kistflow/views/screens/dashboard/widgets/pie_chart.dart';

import '../../../core/app_colors.dart';
import '../../../services/status_update_service.dart';
import '../../../viewmodels/customer_viewmodel/view_customer_vm.dart';
import '../../../viewmodels/dashboard/dashboard_vm.dart';
import '../../../viewmodels/dashboard/notification_vm.dart';
import '../../../viewmodels/setting_viewmodel/user_profile_vm.dart';

class DashboardScreen extends ConsumerStatefulWidget { // StatefulWidget banao
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _statusUpdated = false;
  @override
  void initState() {
    super.initState();
    // App open hone pe status update karo
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_statusUpdated) {
        final service = ref.read(statusUpdateServiceProvider);
        await service.updateAllCustomerStatuses();
        _statusUpdated = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final userName = ref.watch(userProfileProvider);
    final notificationCount = ref.watch(notificationCountProvider);

    // Get filtered notification count (only Unpaid, Overdue, Upcoming)
    final notifications = ref.watch(notificationProvider);
    final customers = ref.watch(customerProvider);

    final filteredCount = notifications.where((n) {
      try {
        final customer = customers.firstWhere((c) => c.id == n.customerId);
        final status = customer.status.toLowerCase();
        return status == 'unpaid' || status == 'overdue' || status == 'upcoming';
      } catch (e) {
        return false;
      }
    }).length;

    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      body: RefreshIndicator(
        onRefresh: () async {
          final service = ref.read(statusUpdateServiceProvider);
          await service.updateAllCustomerStatuses();
          await ref.read(dashboardProvider.notifier).refreshDashboard();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header & Grid (cards)
              SizedBox(
                height: 375,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Header
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.slateGrayOf(context),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName.isEmpty ? 'Loading...' : userName,
                                    style: TextStyle(
                                      color: AppColors.offWhiteOf(context),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Welcome back!',
                                    style: TextStyle(
                                      color: AppColors.offWhiteOf(context),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/notifications',
                                  );
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.notifications,
                                        color: AppColors.offWhiteOf(context),
                                      ),
                                    ),

                                    // Use filtered count instead of total count
                                    if (filteredCount > 0)
                                      Positioned(
                                        right: -2,
                                        top: -2,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 2,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 18,
                                            minHeight: 18,
                                          ),
                                          child: Text(
                                            filteredCount > 9
                                                ? '9+'
                                                : '$filteredCount',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Cards Grid
                    Positioned(
                      top: 115,
                      left: 16,
                      right: 16,
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: state.cards.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 130,
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.4,
                        ),
                        itemBuilder: (context, index) {
                          final card = state.cards[index];
                          return _buildCard(card, context);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Bar Chart
              state.barData.isEmpty
                  ? _buildLoadingCard('Loading monthly data...', context)
                  : DashboardBarChart(state: state),

              const SizedBox(height: 24),

              // Pie Chart
              state.pieData.isEmpty
                  ? _buildLoadingCard('Loading payment status...', context)
                  : DashboardPieChart(state: state),

              const SizedBox(height: 24),

              // Line Chart
              state.lineData.isEmpty
                  ? _buildLoadingCard('Loading weekly trends...', context)
                  : DashboardLineChart(state: state),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> card, BuildContext context) {
    Color bgColor;
    Color iconColor;

    switch (card['type']) {
      case 'total':
        bgColor = AppColors.skyBlueOf(context);
        iconColor = AppColors.skyBlueOf(context);
        break;

      case 'paid':
        bgColor = AppColors.coolMintOf(context);
        iconColor = AppColors.primaryTealOf(context);
        break;

      case 'unpaid':
        bgColor = AppColors.warmAmberOf(context).withValues(alpha: 0.85);
        iconColor = AppColors.warmAmberOf(context);
        break;

      case 'overdue':
        bgColor = AppColors.lightPinkOf(context);
        iconColor = AppColors.pinkOf(context);
        break;

      default:
        bgColor = AppColors.offWhiteOf(context);
        iconColor = AppColors.primaryTealOf(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(card['icon'], color: iconColor, size: 24),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                card['title'],
                style: TextStyle(
                  color: AppColors.darkGreyOf(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                card['value'],
                style: TextStyle(
                  color: AppColors.darkGreyOf(context),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(String message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.offWhiteOf(context),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  color: AppColors.slateGray.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}