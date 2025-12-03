import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/dashboard.dart';

class DashboardPieChart extends StatelessWidget {
  final DashboardState state;
  const DashboardPieChart({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 0.9),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart_rounded, color: AppColors.primaryTeal),
                const SizedBox(width: 8),
                Text(
                  'Paid vs Unpaid',
                  style: TextStyle(
                    color: AppColors.slateGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 35,
                        sectionsSpace: 2,
                        sections: List.generate(state.pieData.length, (i) {
                          final colors = [
                            AppColors.primaryTeal.withOpacity(0.7),
                            AppColors.warmAmber.withOpacity(0.7),
                            Colors.redAccent.withOpacity(0.7),
                          ];
                          return PieChartSectionData(
                            value: state.pieData[i],
                            title: '',
                            color: colors[i],
                            radius: 45,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend(AppColors.primaryTeal.withOpacity(0.7), 'Paid', state.pieData[0]),
                      const SizedBox(height: 8),
                      _buildLegend(AppColors.warmAmber.withOpacity(0.7), 'Unpaid', state.pieData[1]),
                      const SizedBox(height: 8),
                      _buildLegend(Colors.redAccent.withOpacity(0.7), 'Overdue', state.pieData[2]),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String title, double percent) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text('$title (${percent.toStringAsFixed(0)}%)'),
      ],
    );
  }
}
