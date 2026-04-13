class DashboardInsight {
  final String title;
  final String message;
  final String routeName;
  final String actionLabel;
  final String severity;
  final String iconKey;

  const DashboardInsight({
    required this.title,
    required this.message,
    required this.routeName,
    required this.actionLabel,
    required this.severity,
    required this.iconKey,
  });
}

class FocusMetric {
  final String label;
  final String value;
  final String helperText;

  const FocusMetric({
    required this.label,
    required this.value,
    required this.helperText,
  });
}
