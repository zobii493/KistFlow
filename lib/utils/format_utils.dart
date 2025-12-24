class FormatUtils {
  /// Format large numbers with K/M suffix
  static String formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  /// Format currency with Rs prefix
  static String formatCurrency(double value) {
    return 'Rs. ${formatValue(value)}';
  }

  /// Format percentage
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
}