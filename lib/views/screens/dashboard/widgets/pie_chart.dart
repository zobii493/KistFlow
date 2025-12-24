import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../models/dashboard.dart';

class DashboardPieChart extends StatelessWidget {
  final DashboardState state;
  const DashboardPieChart({required this.state});

  @override
  Widget build(BuildContext context) {
    // Filter out zero values for cleaner display
    final nonZeroData = <int>[];
    for (int i = 0; i < state.pieData.length; i++) {
      if (state.pieData[i] > 0) {
        nonZeroData.add(i);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.offBlackOf(context),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.1),
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
                  'Payment Status Distribution',
                  style: TextStyle(
                    color: AppColors.darkGreyOf(context),
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
                        sections: nonZeroData.map((i) {
                          final colors = [
                            AppColors.primaryTeal.withValues(alpha:0.8), // Paid
                            AppColors.warmAmber.withValues(alpha:0.8),   // Unpaid
                            Colors.redAccent.withValues(alpha:0.8),       // Overdue
                            Colors.blueAccent.withValues(alpha:0.8),      // Upcoming
                            Colors.greenAccent.withValues(alpha:0.8),     // Completed
                          ];
                          return PieChartSectionData(
                            value: state.pieData[i],
                            title: '${state.pieData[i].toStringAsFixed(0)}%',
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            color: colors[i],
                            radius: 50,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.pieData[0] > 0)
                        _buildLegend(
                          AppColors.primaryTeal.withValues(alpha:0.8),
                          'Paid',
                          state.pieData[0],
                        ),
                      if (state.pieData[0] > 0) const SizedBox(height: 8),
                      if (state.pieData[1] > 0)
                        _buildLegend(
                          AppColors.warmAmber.withValues(alpha:0.8),
                          'Unpaid',
                          state.pieData[1],
                        ),
                      if (state.pieData[1] > 0) const SizedBox(height: 8),
                      if (state.pieData[2] > 0)
                        _buildLegend(
                          Colors.redAccent.withValues(alpha:0.8),
                          'Overdue',
                          state.pieData[2],
                        ),
                      if (state.pieData[2] > 0) const SizedBox(height: 8),
                      if (state.pieData[3] > 0)
                        _buildLegend(
                          Colors.blueAccent.withValues(alpha:0.8),
                          'Upcoming',
                          state.pieData[3],
                        ),
                      if (state.pieData[3] > 0) const SizedBox(height: 8),
                      if (state.pieData[4] > 0)
                        _buildLegend(
                          Colors.greenAccent.withValues(alpha:0.8),
                          'Completed',
                          state.pieData[4],
                        ),
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
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            '$title (${percent.toStringAsFixed(0)}%)',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}