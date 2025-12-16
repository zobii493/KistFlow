import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kistflow/widgets/appbar.dart';

import '../../core/app_colors.dart';
import '../../viewmodels/report_vm.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(reportVMProvider);
    final state = vm.state;

    if (state == null) {
      return Scaffold(
        backgroundColor: AppColors.offWhiteOf(context),
        appBar: Appbar(text: 'Report & Analytics'),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryTealOf(context),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.offWhiteOf(context),
      appBar: Appbar(text: 'Report & Analytics'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: buildCard(
                      state.totalRevenue,
                      Icons.attach_money,
                      AppColors.coolMint,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildCard(
                      state.expected,
                      Icons.trending_up,
                      AppColors.skyBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: buildCard(
                      state.collectionRate,
                      Icons.percent,
                      AppColors.warmAmber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildCard(
                      state.pending,
                      Icons.warning,
                      AppColors.lightPink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Revenue Trend Chart
              _buildRevenueTrendChart(state.revenueData, vm),
              const SizedBox(height: 24),

              // Customer Growth Chart
              _buildCustomerGrowthChart(state.customerGrowthData),
              const SizedBox(height: 24),

              // Product Categories Chart
              if (state.categoryData.isNotEmpty)
                _buildProductCategoriesChart(state.categoryData),
              if (state.categoryData.isNotEmpty) const SizedBox(height: 24),

              // Top Performing Items
              if (state.topItems.isNotEmpty)
                _buildTopPerformingItems(state.topItems),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> card, IconData icon, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.darkGrey, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            card['title'],
            style: TextStyle(
              color: AppColors.slateGrayOf(context).withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (card['title'] != 'Collection Rate')
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
                  card['value'],
                  style: TextStyle(
                    color: AppColors.slateGrayOf(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (card['title'] == 'Collection Rate')
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
          Row(
            children: [
              Icon(card['statusIcon'], color: card['statusColor'], size: 14),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  card['status'],
                  style: TextStyle(
                    color: card['statusColor'],
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

  Widget _buildRevenueTrendChart(
    List<Map<String, dynamic>> data,
    ReportViewModel vm,
  ) {
    final maxRevenue = data.isEmpty
        ? 100000.0
        : data
              .map((e) => e['revenue'] as double)
              .reduce((a, b) => a > b ? a : b);
    final adjustedMax = maxRevenue < 50000
        ? 100000.0
        : maxRevenue + (maxRevenue * 0.2);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGreyOf(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  dropdownColor: AppColors.offWhiteOf(context),
                  value: vm.selectedPeriod,
                  underline: SizedBox(),
                  isDense: true,
                  items: ['This Year', 'This Month', 'This Week'].map((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) => vm.updatePeriod(newValue!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots.map((spot) {
                      return LineTooltipItem(
                        'Rs ${_formatValue(spot.y)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
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
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec',
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
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: adjustedMax,
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .map(
                          (e) => FlSpot(
                            (e['month'] as int).toDouble(),
                            e['revenue'] as double,
                          ),
                        )
                        .toList(),
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
                          Color(0xFF6B7FFF).withOpacity(0.3),
                          Colors.deepPurpleAccent.withOpacity(0.1),
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
    );
  }

  Widget _buildCustomerGrowthChart(List<Map<String, dynamic>> data) {
    final maxCount = data.isEmpty
        ? 20.0
        : data
              .map((e) => e['count'] as int)
              .reduce((a, b) => a > b ? a : b)
              .toDouble();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(
                Icons.people,
                color: AppColors.primaryTealOf(context),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Customer Growth',
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
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: maxCount + 5,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toInt().toString(),
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
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
                        final now = DateTime.now();
                        final months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec',
                        ];
                        final monthIndex = (now.month - 6 + value.toInt()) % 12;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[monthIndex],
                            style: TextStyle(
                              color: AppColors.slateGrayOf(context),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                alignment: BarChartAlignment.spaceAround,
                barGroups: data.map((e) {
                  return BarChartGroupData(
                    x: e['month'],
                    barRods: [
                      BarChartRodData(
                        toY: (e['count'] as int).toDouble(),
                        width: 40,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryTealOf(context).withOpacity(0.7),
                            AppColors.primaryTealOf(context),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCategoriesChart(List<Map<String, dynamic>> categories) {
    final colors = [
      Color(0xFF6B7FFF).withOpacity(0.7),
      AppColors.primaryTealOf(context).withOpacity(0.7),
      AppColors.warmAmberOf(context).withOpacity(0.7),
      AppColors.pinkOf(context).withOpacity(0.7),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              return _buildLegendItem(
                entry.value['name'],
                colors[entry.key % colors.length],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformingItems(List<Map<String, dynamic>> items) {
    final colors = [
      Color(0xFF6B7FFF).withOpacity(0.7),
      AppColors.primaryTealOf(context).withOpacity(0.7),
      Color(0xFFFF6B9D).withOpacity(0.7),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.offBlackOf(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            return _buildTopItemCard(
              item['name'],
              '${item['units']} units sold',
              _formatValue(item['revenue']),
              colors[index],
              (index + 1).toString(),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTopItemCard(
    String name,
    String units,
    String revenue,
    Color color,
    String rank,
  ) {
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.darkGreyOf(context)),
        ),
      ],
    );
  }

  String _formatValue(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(2)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toStringAsFixed(0);
  }
}
