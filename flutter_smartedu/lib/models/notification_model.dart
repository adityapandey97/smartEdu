class AppNotification {
  final String id;
  final String? userId;
  final String? role;
  final String type;
  final String title;
  final String message;
  final bool read;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    this.userId,
    this.role,
    required this.type,
    required this.title,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  bool get isRead => read; // Alias for read

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'] ?? '',
      userId: json['userId'] is String ? json['userId'] : json['userId']['_id'],
      role: json['role'],
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      read: json['read'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
