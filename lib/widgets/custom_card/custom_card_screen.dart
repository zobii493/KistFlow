import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../models/customer.dart';

class CustomerCard extends ConsumerWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (customer.status) {
      case 'Paid':
        return const Color(0xFF10B981);
      case 'Unpaid':
        return const Color(0xFFEF4444);
      case 'Upcoming':
        return const Color(0xFFF59E0B);
      case 'Overdue':
        return const Color(0xFFDC2626);
      case 'Completed':
        return const Color(0xFF2563EB);
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBackgroundColor() {
    switch (customer.status) {
      case 'Paid':
        return const Color(0xFFD1FAE5);
      case 'Unpaid':
        return const Color(0xFFFEE2E2);
      case 'Upcoming':
        return const Color(0xFFFEF3C7);
      case 'Overdue':
        return const Color(0xFFFEE2E2);
      case 'Completed':
        return const Color(0xFFFEEAE2);
      default:
        return Colors.grey.shade200;
    }
  }

  IconData _getStatusIcon() {
    switch (customer.status) {
      case 'Paid':
        return Icons.check_circle;
      case 'Unpaid':
        return Icons.cancel;
      case 'Upcoming':
        return Icons.schedule;
      case 'Overdue':
        return Icons.error;
      case 'Completed':
        return Icons.celebration;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: _getStatusColor(),
            width: 6,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // --- IMAGE DISPLAY ---
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.slateGray.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: customer.imagePath != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(customer.imagePath!),
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(
                    Icons.image,
                    size: 32,
                    color: AppColors.slateGray,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              customer.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.slateGray,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusBackgroundColor(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getStatusIcon(),
                                  size: 14,
                                  color: _getStatusColor(),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  customer.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Phone number
                      Text(
                        customer.phoneNumber,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Item Name
                      Text(
                        customer.itemName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slateGray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Next due & Monthly installment
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Next Due: ${customer.nextDueDate}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          Text(
                            'Rs. ${customer.monthlyInstallment}/mo',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
