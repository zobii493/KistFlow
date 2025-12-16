class AppPreferences {
  final String theme;
  final bool notificationsEnabled;
  final bool reminderAlerts;
  final bool overdueAlerts;

  AppPreferences({
    required this.theme,
    required this.notificationsEnabled,
    required this.reminderAlerts,
    required this.overdueAlerts,
  });

  AppPreferences copyWith({
    String? theme,
    bool? notificationsEnabled,
    bool? reminderAlerts,
    bool? overdueAlerts,
  }) {
    return AppPreferences(
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderAlerts: reminderAlerts ?? this.reminderAlerts,
      overdueAlerts: overdueAlerts ?? this.overdueAlerts,
    );
  }
}
