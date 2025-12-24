import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../utils/format_utils.dart';
import '../widgets/top_item_card.dart';

class TopPerformingItems extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const TopPerformingItems({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = [
      Color(0xFF6B7FFF).withValues(alpha:0.7),
      AppColors.primaryTealOf(context).withValues(alpha:0.7),
      Color(0xFFFF6B9D).withValues(alpha:0.7),
    ];

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Color(0xFFFFB74D), size: 20),
              const SizedBox(width: 8),
              Text(
                'Top Performing Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGrayOf(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return TopItemCard(
              name: item['name'],
              units: '${item['units']} units sold',
              revenue: FormatUtils.formatValue(item['revenue']),
              color: colors[index],
              rank: (index + 1).toString(),
            );
          }).toList(),
        ],
      ),
    );
  }
}