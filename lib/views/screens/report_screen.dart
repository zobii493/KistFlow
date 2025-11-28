import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/app_colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedPeriod = 'This Year';

  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Total Revenue',
      'value': '329,099',
      'icon': Icons.attach_money,
      'bgColor': AppColors.coolMint,
      'status': '12% from last month',
      'statusColor': Colors.green,
      'statusIcon': Icons.arrow_upward,
    },
    {
      'title': 'Expected',
      'value': '232,099',
      'icon': Icons.trending_up,
      'bgColor': AppColors.skyBlue,
      'status': 'full payment',
      'statusColor': Colors.lightBlueAccent,
      'statusIcon': Icons.check_circle,
    },
    {
      'title': 'Collection Rate',
      'value': '80',
      'icon': Icons.percent,
      'bgColor': AppColors.warmAmber,
      'status': '5% improvement',
      'statusColor': Colors.deepOrange,
      'statusIcon': Icons.arrow_upward,
    },
    {
      'title': 'Pending',
      'value': '23,890',
      'icon': Icons.warning,
      'bgColor': AppColors.lightPink,
      'status': '3 overdue',
      'statusColor': Colors.redAccent,
      'statusIcon': Icons.watch_later_rounded,
    },
  ];

  final List<Map<String, dynamic>> topItems = [
    {
      'name': 'Samsung Galaxy S23',
      'units': '15 units sold',
      'revenue': '2.25M',
      'color': Color(0xFF6B7FFF).withValues(alpha: 0.7),
      'rank': '1',
    },
    {
      'name': 'iPhone 14 Pro',
      'units': '12 units sold',
      'revenue': '3.00M',
      'color': AppColors.primaryTeal.withValues(alpha: 0.7),
      'rank': '2',
    },
    {
      'name': 'MacBook Air M2',
      'units': '8 units sold',
      'revenue': '2.40M',
      'color': Color(0xFFFF6B9D).withValues(alpha: 0.7),
      'rank': '3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Reports & Analytics',
          style: TextStyle(
            color: AppColors.offWhite,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.slateGray,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Stats Cards
              Row(
                children: [
                  Expanded(child: buildCard(cards[0])),
                  const SizedBox(width: 12),
                  Expanded(child: buildCard(cards[1])),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: buildCard(cards[2])),
                  const SizedBox(width: 12),
                  Expanded(child: buildCard(cards[3])),
                ],
              ),
              const SizedBox(height: 24),

              // Revenue Trend Chart
              _buildRevenueTrendChart(),
              const SizedBox(height: 24),

              // Customer Growth Chart
              _buildCustomerGrowthChart(),
              const SizedBox(height: 24),

              // Product Categories Chart
              _buildProductCategoriesChart(),
              const SizedBox(height: 24),

              // Top Performing Items
              _buildTopPerformingItems(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> card) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
            decoration: BoxDecoration(
              color: card['bgColor'],
              shape: BoxShape.circle,
            ),
            child: Icon(
              card['icon'],
              color: AppColors.darkGrey,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            card['title'],
            style: TextStyle(
              color: AppColors.slateGray.withOpacity(0.7),
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
                    color: AppColors.slateGray,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Flexible(
                child: Text(
                  card['value'],
                  style: TextStyle(
                    color: AppColors.slateGray,
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
                    color: AppColors.slateGray,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                card['statusIcon'],
                color: card['statusColor'],
                size: 14,
              ),
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

  Widget _buildRevenueTrendChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                  Icon(
                    Icons.trending_up,
                    color: Color(0xFF6B7FFF),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Revenue Trend',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slateGray,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  dropdownColor: AppColors.offWhite,
                  value: selectedPeriod,
                  underline: SizedBox(),
                  isDense: true,
                  items: ['This Year', 'This Month', 'This Week']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPeriod = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          spot.y.toStringAsFixed(0), // Value
                          const TextStyle(
                            color: Colors.white, // <-- Yahan white set kiya gaya hai
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50000,
                      reservedSize: 50,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          '${(value / 1000).toInt()}k',
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 300000,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 120000),
                      FlSpot(1, 140000),
                      FlSpot(2, 155000),
                      FlSpot(3, 145000),
                      FlSpot(4, 135000),
                      FlSpot(5, 190000),
                      FlSpot(6, 200000),
                      FlSpot(7, 210000),
                      FlSpot(8, 230000),
                      FlSpot(9, 240000),
                      FlSpot(10, 250000),
                      FlSpot(11, 270000),
                    ],
                    isCurved: true,
                    color: Color(0xFF6B7FFF),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Color(0xFF6B7FFF),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFF6B7FFF).withOpacity(0.1),
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

  Widget _buildCustomerGrowthChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                color: AppColors.primaryTeal,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Customer Growth',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                        ) {
                      final value = rod.toY.toInt().toString();
                      return BarTooltipItem(
                        value,
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 5,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: AppColors.primaryTeal.withValues(alpha: 0.7), width: 45, borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)))]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12, color: AppColors.primaryTeal.withValues(alpha: 0.7), width: 45, borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)))]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 10, color: AppColors.primaryTeal.withValues(alpha: 0.7), width: 45, borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)))]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, color: AppColors.primaryTeal.withValues(alpha: 0.7), width: 45, borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)))]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13, color: AppColors.primaryTeal.withValues(alpha: 0.7), width: 45, borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)))]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 17, color: AppColors.primaryTeal.withValues(alpha: 0.7), width: 45, borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)))]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCategoriesChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                Icons.category,
                color: Color(0xFF6B7FFF),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Product Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGray,
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
                sections: [
                  PieChartSectionData(
                    color: Color(0xFF6B7FFF).withValues(alpha: 0.7),
                    value: 40,
                    title: '40%',
                    radius: 100,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppColors.primaryTeal.withValues(alpha: 0.7),
                    value: 25,
                    title: '25%',
                    radius: 100,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppColors.warmAmber.withValues(alpha: 0.7),
                    value: 20,
                    title: '20%',
                    radius: 100,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppColors.pink.withValues(alpha: 0.7),
                    value: 15,
                    title: '15%',
                    radius: 100,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem('Electronics', Color(0xFF6B7FFF).withValues(alpha: 0.7)),
              _buildLegendItem('Appliances', AppColors.primaryTeal),
              _buildLegendItem('Furniture', AppColors.warmAmber.withValues(alpha: 0.7)),
              _buildLegendItem('Others',AppColors.pink.withValues(alpha: 0.7)),
            ],
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
          style: TextStyle(
            fontSize: 12,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildTopPerformingItems() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                Icons.emoji_events,
                color: Color(0xFFFFB74D),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Top Performing Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...topItems.map((item) => _buildTopItemCard(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildTopItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item['color'],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item['rank'],
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
                  item['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slateGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['units'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rs. ${item['revenue']}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: item['color'],
            ),
          ),
        ],
      ),
    );
  }
}