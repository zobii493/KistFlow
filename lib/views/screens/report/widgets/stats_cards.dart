import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class StatsCards extends StatelessWidget {
  final Map<String, dynamic> totalRevenue;
  final Map<String, dynamic> expected;
  final Map<String, dynamic> collectionRate;
  final Map<String, dynamic> pending;

  const StatsCards({
    Key? key,
    required this.totalRevenue,
    required this.expected,
    required this.collectionRate,
    required this.pending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                data: totalRevenue,
                icon: Icons.attach_money,
                bgColor: AppColors.coolMint,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                data: expected,
                icon: Icons.trending_up,
                bgColor: AppColors.skyBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                data: collectionRate,
                icon: Icons.percent,
                bgColor: AppColors.warmAmber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                data: pending,
                icon: Icons.warning,
                bgColor: AppColors.lightPink,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final IconData icon;
  final Color bgColor;

  const _StatCard({
    required this.data,
    required this.icon,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final isPercentage = data['title'] == 'Collection Rate';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.darkGrey, size: 24),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            data['title'],
            style: TextStyle(
              color: AppColors.slateGrayOf(context).withValues(alpha:0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),

          // Value
          Row(
            children: [
              if (!isPercentage)
                Text(
                  'Rs. ',
                  style: TextStyle(
                    color: AppColors.slateGrayOf(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Flexible(
                child: Text(
                  data['value'],
                  style: TextStyle(
                    color: AppColors.slateGrayOf(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isPercentage)
                Text(
                  '%',
                  style: TextStyle(
                    color: AppColors.slateGrayOf(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),

          // Status
          Row(
            children: [
              Icon(
                data['statusIcon'],
                color: data['statusColor'],
                size: 14,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  data['status'],
                  style: TextStyle(
                    color: data['statusColor'],
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}