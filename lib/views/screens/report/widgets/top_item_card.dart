import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';

class TopItemCard extends StatelessWidget {
  final String name;
  final String units;
  final String revenue;
  final Color color;
  final String rank;

  const TopItemCard({
    required this.name,
    required this.units,
    required this.revenue,
    required this.color,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGreyOf(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                rank,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slateGrayOf(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  units,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGreyOf(context),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rs. $revenue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}