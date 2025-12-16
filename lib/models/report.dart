class ReportState {
  final Map<String, dynamic> totalRevenue;
  final Map<String, dynamic> expected;
  final Map<String, dynamic> collectionRate;
  final Map<String, dynamic> pending;
  final List<Map<String, dynamic>> revenueData;
  final List<Map<String, dynamic>> customerGrowthData;
  final List<Map<String, dynamic>> categoryData;
  final List<Map<String, dynamic>> topItems;

  ReportState({
    required this.totalRevenue,
    required this.expected,
    required this.collectionRate,
    required this.pending,
    required this.revenueData,
    required this.customerGrowthData,
    required this.categoryData,
    required this.topItems,
  });
}