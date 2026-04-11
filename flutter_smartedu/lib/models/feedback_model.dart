class Feedback {
  final String id;
  final String studentId;
  final String studentName;
  final String teacherId;
  final String teacherName;
  final String subject;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.studentId,
    this.studentName = '',
    required this.teacherId,
    this.teacherName = '',
    required this.subject,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['_id'] ?? '',
      studentId: json['studentId'] is String ? json['studentId'] : json['studentId']['_id'] ?? '',
      studentName: json['studentId'] is Map ? json['studentId']['name'] ?? '' : '',
      teacherId: json['teacherId'] is String ? json['teacherId'] : json['teacherId']['_id'] ?? '',
      teacherName: json['teacherId'] is Map ? json['teacherId']['name'] ?? '' : '',
      subject: json['subject'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
