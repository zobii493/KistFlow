import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/app_colors.dart';
import '../../../../models/dashboard.dart';

class DashboardLineChart extends StatelessWidget {
  final DashboardState state;

  const DashboardLineChart({required this.state});

  @override
  Widget build(BuildContext context) {
    const weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

    // Calculate max value for better scaling
    final maxValue = state.lineData.isEmpty
        ? 100.0
        : state.lineData.reduce((a, b) => a > b ? a : b);
    final adjustedMaxY = maxValue < 50 ? 100.0 : maxValue + 20;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppColors.offBlackOf(context),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
        BoxShadow(
        color: Colors.black.withValues(alpha:0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.lineChart,
                  color: Colors.deepPurpleAccent,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Weekly Payment Collection',
                  style: TextStyle(
                    color: AppColors.darkGreyOf(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 8),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Text(
          //     'Percentage of total collection (Last 4 weeks)',
          //     style: TextStyle(
          //       color: AppColors.slateGray.withValues(alpha:0.6),
          //       fontSize: 12,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 16),
          // Line Chart
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(1)}%',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                minY: 0,
                maxY: adjustedMaxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withValues(alpha:0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < weeks.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              weeks[index],
                              style: TextStyle(
                                color: AppColors.darkGreyOf(context),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      interval: 1,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      weeks.length,
                          (i) => FlSpot(
                        i.toDouble(),
                        i < state.lineData.length ? state.lineData[i] : 0,
                      ),
                    ),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryTeal,
                        Colors.deepPurpleAccent,
                      ],
                    ),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: AppColors.primaryTeal,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryTeal.withValues(alpha:0.3),
                          Colors.deepPurpleAccent.withValues(alpha:0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}