import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/app_colors.dart';
import '../../../../utils/format_utils.dart';

class RevenueTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const RevenueTrendChart({
    Key? key,
    required this.data,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxRevenue = _calculateMaxRevenue();
    final adjustedMax = maxRevenue < 50000 ? 100000.0 : maxRevenue + (maxRevenue * 0.2);

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
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildChart(context, adjustedMax),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up, color: Color(0xFF6B7FFF), size: 20),
            const SizedBox(width: 8),
            Text(
              'Revenue Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.slateGrayOf(context),
              ),
            ),
          ],
        ),
        _buildPeriodDropdown(context),
      ],
    );
  }

  Widget _buildPeriodDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightGreyOf(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        dropdownColor: AppColors.offWhiteOf(context),
        value: selectedPeriod,
        underline: SizedBox(),
        isDense: true,
        items: ['This Year', 'Last Year','This Month', 'This Week'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(fontSize: 12)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) onPeriodChanged(newValue);
        },
      ),
    );
  }

  Widget _buildChart(BuildContext context, double maxY) {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          lineTouchData: _buildTouchData(),
          gridData: _buildGridData(),
          titlesData: _buildTitlesData(context),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 11,
          minY: 0,
          maxY: maxY,
          lineBarsData: [_buildLineData()],
        ),
      ),
    );
  }

  LineTouchData _buildTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (spots) => spots.map((spot) {
          return LineTooltipItem(
            'Rs ${FormatUtils.formatValue(spot.y)}',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          );
        }).toList(),
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withValues(alpha:0.2),
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    return FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) => _buildBottomTitle(context, value),
        ),
      ),
    );
  }

  Widget _buildBottomTitle(BuildContext context, double value) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    if (value.toInt() >= 0 && value.toInt() < 12) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          months[value.toInt()],
          style: TextStyle(
            color: AppColors.slateGrayOf(context),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return Text('');
  }

  LineChartBarData _buildLineData() {
    return LineChartBarData(
      spots: data.map((e) => FlSpot(
        (e['month'] as int).toDouble(),
        e['revenue'] as double,
      )).toList(),
      isCurved: true,
      gradient: LinearGradient(
        colors: [Color(0xFF6B7FFF), Colors.deepPurpleAccent],
      ),
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: Colors.white,
            strokeWidth: 2,
            strokeColor: Color(0xFF6B7FFF),
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            Color(0xFF6B7FFF).withValues(alpha:0.3),
            Colors.deepPurpleAccent.withValues(alpha:0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  double _calculateMaxRevenue() {
    if (data.isEmpty) return 100000.0;
    return data
        .map((e) => e['revenue'] as double)
        .reduce((a, b) => a > b ? a : b);
  }
}