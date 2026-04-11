class LeaveApplication {
  final String id;
  final String studentId;
  final String studentName;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final String? reviewNote;
  final DateTime createdAt;

  LeaveApplication({
    required this.id,
    required this.studentId,
    this.studentName = '',
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.reviewNote,
    required this.createdAt,
  });

  factory LeaveApplication.fromJson(Map<String, dynamic> json) {
    return LeaveApplication(
      id: json['_id'] ?? '',
      studentId: json['studentId'] is String ? json['studentId'] : json['studentId']['_id'] ?? '',
      studentName: json['studentId'] is Map ? json['studentId']['name'] ?? '' : '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reason: json['reason'] ?? '',
      status: json['status'] ?? 'pending',
      reviewNote: json['reviewNote'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
