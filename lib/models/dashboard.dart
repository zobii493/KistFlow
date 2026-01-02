class DashboardState {
  final List<Map<String, dynamic>> cards;
  final List<double> barData;
  final List<double> pieData;
  final List<double> lineData;
  final Map<int, int> planCounts;

  DashboardState({
    required this.cards,
    required this.barData,
    required this.pieData,
    required this.lineData,
    required this.planCounts,
  });
}