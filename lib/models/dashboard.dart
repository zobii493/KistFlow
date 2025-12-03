class DashboardState {
  final List<Map<String, dynamic>> cards;
  final List<double> barData;
  final List<double> pieData;
  final List<double> lineData;

  DashboardState({
    required this.cards,
    required this.barData,
    required this.pieData,
    required this.lineData,
  });
}