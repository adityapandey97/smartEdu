class Holiday {
  final String id;
  final String title;
  final DateTime date;
  final String? reason;

  Holiday({
    required this.id,
    required this.title,
    required this.date,
    this.reason,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date']),
      reason: json['reason'],
    );
  }
}
