import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../models/customer.dart';

class CustomerCard extends ConsumerWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerCard({super.key, required this.customer, required this.onTap});

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
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: _getStatusColor().withValues(alpha: 0.9), width: 6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                    color: AppColors.slateGray.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: (customer.imagePath != null && customer.imagePath!.isNotEmpty)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: customer.imagePath!,
                      fit: BoxFit.cover,
                      memCacheHeight: 200,  // Memory optimization
                      memCacheWidth: 200,
                      placeholder: (context, url) => Container(
                        color: AppColors.slateGray.withValues(alpha: 0.3),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported,
                        size: 32,
                        color: AppColors.slateGray,
                      ),
                    ),
                  )
                      : Icon(Icons.image, size: 32, color: AppColors.slateGray),
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTealOf(context).withValues(alpha: 0.9),
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
                              color: _getStatusColor().withValues(alpha: 0.2),
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
                          color: AppColors.darkGreyOf(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Item Name
                      Text(
                        customer.itemName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slateGrayOf(context),
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
                              color: AppColors.darkGreyOf(context),
                            ),
                          ),
                          Text(
                            'Rs. ${customer.monthlyInstallment}/mo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTealOf(context).withValues(alpha: 0.8),
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
