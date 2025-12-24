import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/app_colors.dart';
import '../widgets/legend_item.dart';

class ProductCategoriesChart extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const ProductCategoriesChart({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = [
      Color(0xFF6B7FFF).withValues(alpha:0.7),
      AppColors.primaryTealOf(context).withValues(alpha:0.7),
      AppColors.warmAmberOf(context).withValues(alpha:0.7),
      AppColors.pinkOf(context).withValues(alpha:0.7),
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
              Icon(Icons.category, color: Color(0xFF6B7FFF), size: 20),
              const SizedBox(width: 8),
              Text(
                'Product Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGrayOf(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 0,
                sections: categories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: data['percentage'],
                    title: '${data['percentage'].toStringAsFixed(0)}%',
                    radius: 100,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: categories.asMap().entries.map((entry) {
              return LegendItem(
                label: entry.value['name'],
                color: colors[entry.key % colors.length],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}