// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../core/app_colors.dart';
//
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final double headerHeight = 140;
//     final double gridTopPosition = 115;
//
//     final List<Map<String, dynamic>> cards = [
//       {
//         'title': 'Total\nCustomers',
//         'value': '32',
//         'icon': CupertinoIcons.person_3_fill,
//         'bgColor': AppColors.skyBlue,
//         'iconColor': AppColors.skyBlue,
//       },
//       {
//         'title': 'Paid\nInstallments',
//         'value': '58',
//         'icon': CupertinoIcons.check_mark_circled_solid,
//         'bgColor': AppColors.coolMint,
//         'iconColor': AppColors.slateGray.withValues(alpha: 0.7),
//       },
//       {
//         'title': 'Unpaid\nInstallments',
//         'value': '12',
//         'icon': Icons.warning,
//         'bgColor': AppColors.warmAmber.withValues(alpha: 0.2),
//         'iconColor': AppColors.warmAmber,
//       },
//       {
//         'title': 'Overdue\nInstallments',
//         'value': '19',
//         'icon': CupertinoIcons.xmark_circle_fill,
//         'bgColor': AppColors.lightPink,
//         'iconColor': AppColors.lightPink,
//       },
//     ];
//
//     return Scaffold(
//       backgroundColor: AppColors.offWhite,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: headerHeight + 230,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Container(
//                     height: headerHeight,
//                     decoration: BoxDecoration(
//                       color: AppColors.slateGray,
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(30),
//                         bottomRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: SafeArea(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 10,
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: const [
//                                 Text(
//                                   'Zohaib Hassan',
//                                   style: TextStyle(
//                                     color: AppColors.offWhite,
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   'Welcome back!',
//                                   style: TextStyle(
//                                     color: AppColors.offWhite,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const Spacer(),
//                             Container(
//                               width: 45,
//                               height: 45,
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.2),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Icon(
//                                 Icons.notifications,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: gridTopPosition,
//                     left: 16,
//                     right: 16,
//                     child: SizedBox(
//                       height: 320,
//                       child: GridView.builder(
//                         padding: const EdgeInsets.only(top: 0, bottom: 20),
//                         // physics: const BouncingScrollPhysics(),
//                         itemCount: cards.length,
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               mainAxisSpacing: 12,
//                               crossAxisSpacing: 12,
//                               childAspectRatio: 1.4,
//                             ),
//                         itemBuilder: (context, index) {
//                           final card = cards[index];
//                           return Container(
//                             decoration: BoxDecoration(
//                               color: card['bgColor'],
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withValues(alpha: 0.05),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             padding: const EdgeInsets.all(16),
//                             child: Row(
//                               mainAxisAlignment: .center,
//                               children: [
//                                 Column(
//                                   mainAxisAlignment: .center,
//                                   crossAxisAlignment: .center,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(8),
//                                       decoration: const BoxDecoration(
//                                         color: Colors.white,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                         card['icon'],
//                                         color: card['iconColor'],
//                                         size: 24,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(width: 8),
//                                 Column(
//                                   crossAxisAlignment: .start,
//                                   mainAxisAlignment: .center,
//                                   children: [
//                                     Text(
//                                       card['title'],
//                                       style: TextStyle(
//                                         color: AppColors.slateGray.withValues(alpha: 0.7),
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       card['value'],
//                                       style: TextStyle(
//                                         color: AppColors.slateGray,
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 40),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: .start,
//                 children: [
//                   Text(
//                     'Performance Insight',
//                     style: TextStyle(
//                       color: AppColors.slateGray,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: AppColors.offWhite,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 0.9),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 16,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: .start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: .start,
//                                 spacing: 4,
//                                 children: [
//                                   Icon(
//                                     Icons.bar_chart_rounded,
//                                     color: Colors.indigoAccent,
//                                   ),
//                                   Text(
//                                     'Monthly Collection (Last 6 Months)',
//                                     style: TextStyle(
//                                       color: AppColors.slateGray,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 16),
//                               SizedBox(
//                                 height: 200,
//                                 child: BarChart(
//                                   BarChartData(
//                                     barTouchData: BarTouchData(
//                                       enabled: true,
//                                       touchTooltipData: BarTouchTooltipData(
//                                         // Tooltip ka background color
//                                         getTooltipItem: (
//                                             BarChartGroupData group,
//                                             int groupIndex,
//                                             BarChartRodData rod,
//                                             int rodIndex,
//                                             ) {
//                                           // Y value ko string mein convert karein
//                                           final value = rod.toY.toInt().toString();
//                                           return BarTooltipItem(
//                                             value,
//                                             // === TEXT COLOR WHITE SET KIYA GAYA HAI ===
//                                             const TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 14,
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     alignment: BarChartAlignment.spaceAround,
//                                     borderData: FlBorderData(show: false),
//                                     gridData: FlGridData(show: false),
//                                     titlesData: FlTitlesData(
//                                       leftTitles: AxisTitles(
//                                         sideTitles: SideTitles(
//                                           showTitles: false,
//                                         ),
//                                       ),
//                                       rightTitles: AxisTitles(
//                                         sideTitles: SideTitles(
//                                           showTitles: false,
//                                         ),
//                                       ),
//                                       topTitles: AxisTitles(
//                                         sideTitles: SideTitles(
//                                           showTitles: false,
//                                         ),
//                                       ),
//                                       bottomTitles: AxisTitles(
//                                         sideTitles: SideTitles(
//                                           showTitles: true,
//                                           getTitlesWidget: (value, meta) {
//                                             const months = [
//                                               'Jul',
//                                               'Aug',
//                                               'Sep',
//                                               'Oct',
//                                               'Nov',
//                                               'Dec',
//                                             ];
//                                             return Text(
//                                               months[value.toInt()],
//                                               style: TextStyle(
//                                                 color: AppColors.slateGray,
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 12,
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                     barGroups: [
//                                       _bar(0, 15),
//                                       _bar(1, 22),
//                                       _bar(2, 10),
//                                       _bar(3, 25),
//                                       _bar(4, 18),
//                                       _bar(5, 23),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: AppColors.offWhite,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 0.9),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 16,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: .start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: .start,
//                             spacing: 4,
//                             children: [
//                               Icon(
//                                 Icons.pie_chart_rounded,
//                                 color: AppColors.primaryTeal,
//                               ),
//                               Text(
//                                 'Paid vs Unpaid',
//                                 style: TextStyle(
//                                   color: AppColors.slateGray,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             crossAxisAlignment: .center,
//                             mainAxisAlignment: .center,
//                             children: [
//                               // Pie Chart
//                               Expanded(
//                                 flex: 2,
//                                 child: SizedBox(
//                                   height: 200,
//                                   child: PieChart(
//                                     PieChartData(
//                                       centerSpaceRadius: 35,
//                                       sectionsSpace: 2,
//                                       sections: [
//                                         PieChartSectionData(
//                                           value: 70,
//                                           title: '',
//                                           color: AppColors.primaryTeal
//                                               .withValues(alpha: 0.7),
//                                           radius: 45,
//                                         ),
//                                         PieChartSectionData(
//                                           value: 15,
//                                           title: '',
//                                           color: AppColors.warmAmber
//                                             .withValues(alpha: 0.7),
//                                           radius: 45,
//                                         ),
//                                         PieChartSectionData(
//                                           value: 15,
//                                           title: '',
//                                           color: Colors.redAccent.withValues(alpha: 0.7),
//                                           radius: 45,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               // Legend
//                               Expanded(
//                                 flex: 2,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     _buildLegend(
//                                       AppColors.primaryTeal.withValues(alpha: 0.7),
//                                       'Paid',
//                                       70,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     _buildLegend(
//                                       AppColors.warmAmber.withValues(alpha: 0.7),
//                                       'Unpaid',
//                                       15,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     _buildLegend(
//                                       Colors.redAccent.withValues(alpha: 0.7),
//                                       'Overdue',
//                                       15,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Container(
//                 height: 230,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: AppColors.offWhite,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: .start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: .start,
//                       spacing: 4,
//                       children: [
//                         Icon(
//                           FontAwesomeIcons.lineChart,
//                           color: Colors.deepPurpleAccent,
//                         ),
//                         Text(
//                           'Payment Trend',
//                           style: TextStyle(
//                             color: AppColors.slateGray,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Expanded(
//                       child: LineChart(
//                         LineChartData(
//                           lineTouchData: LineTouchData(
//                             touchTooltipData: LineTouchTooltipData(
//                               // ...
//                               getTooltipItems: (touchedSpots) {
//                                 return touchedSpots.map((spot) {
//                                   return LineTooltipItem(
//                                     spot.y.toStringAsFixed(0), // Value
//                                     const TextStyle(
//                                       color: Colors.white, // <-- Yahan white set kiya gaya hai
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                     ),
//                                   );
//                                 }).toList();
//                               },
//                             ),
//                           ),
//                           minY: 0,
//                           maxY: 100,
//                           gridData: FlGridData(
//                             show: true,
//                             horizontalInterval: 20,
//                             drawVerticalLine: false,
//                             getDrawingHorizontalLine: (value) {
//                               return FlLine(
//                                 color: Colors.grey.withValues(alpha: 0.2),
//                                 strokeWidth: 1,
//                               );
//                             },
//                           ),
//                           titlesData: FlTitlesData(
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: 20,
//                                 reservedSize: 20,
//                                 getTitlesWidget: (value, meta) {
//                                   return Text(
//                                     value.toInt().toString(),
//                                     style: TextStyle(
//                                       color: AppColors.slateGray.withValues(alpha:
//                                         0.7,
//                                       ),
//                                       fontSize: 10,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 reservedSize: 40,
//                                 getTitlesWidget: (value, meta) {
//                                   const weeks = [
//                                     'Week 1',
//                                     'Week 2',
//                                     'Week 3',
//                                     'Week 4',
//                                   ];
//                                   if (value.toInt() >= 0 &&
//                                       value.toInt() < weeks.length) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(
//                                         top: 8.0,right: 20
//                                       ),
//                                       child: Text(
//                                         weeks[value.toInt()],
//                                         style: TextStyle(
//                                           color: AppColors.slateGray,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                   return const Text('');
//                                 },
//                                 interval: 1,
//                               ),
//                             ),
//                             topTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                             rightTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                           ),
//                           borderData: FlBorderData(show: false),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: const [
//                                 FlSpot(0, 75),
//                                 FlSpot(1, 82),
//                                 FlSpot(2, 78),
//                                 FlSpot(3, 90),
//                               ],
//                               isCurved: true,
//                               color: AppColors.primaryTeal,
//                               barWidth: 3,
//                               dotData: FlDotData(show: true),
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 color: AppColors.primaryTeal.withValues(alpha: 0.2),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 100),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLegend(Color color, String title, double percent) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           '$title ($percent%)',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: AppColors.slateGray,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// BarChartGroupData _bar(int x, double y) {
//   return BarChartGroupData(
//     x: x,
//     barRods: [
//       BarChartRodData(
//         toY: y,
//         width: 48,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(5),
//           topRight: Radius.circular(5),
//         ),
//         color: Colors.indigoAccent.withValues(alpha:0.7),
//       ),
//     ],
//   );
// }
//


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/dashboard_widgets/bar_chart.dart';
import '../../widgets/dashboard_widgets/pie_chart.dart';
import '../../widgets/dashboard_widgets/line_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header & Grid (cards)
            SizedBox(
              height: 375,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Header
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.slateGray,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Zohaib Hassan',
                                  style: TextStyle(
                                    color: AppColors.offWhite,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Welcome back!',
                                  style: TextStyle(
                                    color: AppColors.offWhite,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Cards Grid
                  Positioned(
                    top: 115,
                    left: 16,
                    right: 16,
                    child: SizedBox(
                      height: 320,
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: state.cards.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.4,
                        ),
                        itemBuilder: (context, index) {
                          final card = state.cards[index];
                          return _buildCard(card);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            DashboardBarChart(state: state),

            const SizedBox(height: 24),

            // Paid vs Unpaid - Pie Chart
            DashboardPieChart(state: state),

            const SizedBox(height: 24),

            // Payment Trend - Line Chart
            DashboardLineChart(state: state),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> card) {
    return Container(
      decoration: BoxDecoration(
        color: card['bgColor'],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              card['icon'],
              color: card['iconColor'],
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                card['title'],
                style: TextStyle(
                  color: AppColors.slateGray.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                card['value'],
                style: const TextStyle(
                  color: AppColors.slateGray,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}