import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_colors.dart';
import '../../../viewmodels/dashboard/notification_vm.dart';
import '../../../viewmodels/customer_viewmodel/view_customer_vm.dart';
import '../../../widgets/appbar.dart';
import '../customer/customer_details_screen.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'unpaid':
        return const Color(0xFFEF4444);
      case 'overdue':
        return const Color(0xFFDC2626);
      case 'paid':
        return const Color(0xFF10B981);
      case 'completed':
        return const Color(0xFF2563EB);
      case 'upcoming':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'unpaid':
        return Icons.warning_rounded;
      case 'overdue':
        return Icons.error_rounded;
      case 'paid':
        return Icons.check_circle_rounded;
      case 'completed':
        return Icons.verified_rounded;
      case 'upcoming':
        return Icons.schedule_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _extractStatus(String title) {
    if (title.contains(':')) {
      return title.split(':').last.trim();
    }
    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final customers = ref.watch(customerProvider);

    // Filter: Only show notifications where customer status is Unpaid, Overdue, or Upcoming
    final filteredNotifications = notifications.where((n) {
      try {
        final customer = customers.firstWhere(
              (c) => c.id == n.customerId,
        );

        // Show notification only if status is Unpaid, Overdue, or Upcoming
        final status = customer.status.toLowerCase();
        return status == 'unpaid' || status == 'overdue' || status == 'upcoming';
      } catch (e) {
        // If customer not found, don't show notification
        return false;
      }
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: "Notifications"),
      body: filteredNotifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/mute.png',
              width: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'No Notifications Yet!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.slateGrayOf(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGreyOf(context),
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredNotifications.length,
        itemBuilder: (context, index) {
          final n = filteredNotifications[index];

          // Get CURRENT customer status from customerProvider
          final customer = customers.firstWhere(
                (c) => c.id == n.customerId,
            orElse: () => customers.first, // This won't be reached due to filter
          );

          // Use current customer status
          final currentStatus = customer.status;
          final statusColor = _getStatusColor(currentStatus);
          final statusIcon = _getStatusIcon(currentStatus);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.offBlackOf(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Navigate to customer detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerDetailScreen(
                        customerId: n.customerId,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Badge Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              statusIcon,
                              color: statusColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                currentStatus,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: AppColors.darkGreyOf(context),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Divider
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.darkGreyOf(context)
                                  .withValues(alpha: 0.1),
                              AppColors.darkGreyOf(context)
                                  .withValues(alpha: 0.05),
                              AppColors.darkGreyOf(context)
                                  .withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Message with customer name
                      Text(
                        "Customer ${customer.name} payment status is now $currentStatus",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.slateGrayOf(context),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Date
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: AppColors.darkGreyOf(context),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${n.date.day}/${n.date.month}/${n.date.year} • ${n.date.hour.toString().padLeft(2, '0')}:${n.date.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}