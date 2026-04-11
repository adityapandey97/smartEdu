class Assignment {
  final String id;
  final String title;
  final String description;
  final String subject;
  final DateTime deadline;
  final DateTime dueDate; // Alias for deadline
  final String createdBy;
  final String createdByName;
  final String teacherId;
  final String teacherName;
  final int maxMarks;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.deadline,
    DateTime? dueDate,
    required this.createdBy,
    this.createdByName = '',
    this.teacherId = '',
    this.teacherName = '',
    this.maxMarks = 100,
  }) : dueDate = dueDate ?? deadline;

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      subject: json['subject'] ?? '',
      deadline: DateTime.parse(json['deadline']),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.parse(json['deadline']),
      createdBy: json['createdBy'] is String
          ? json['createdBy']
          : json['createdBy']['_id'] ?? '',
      createdByName:
          json['createdBy'] is Map ? json['createdBy']['name'] ?? '' : '',
      teacherId: json['teacherId'] ?? '',
      teacherName: json['teacherName'] ?? '',
      maxMarks: json['maxMarks'] ?? 100,
    );
  }

  bool get isOverdue => DateTime.now().isAfter(deadline);
}

class Submission {
  final String id;
  final String assignmentId;
  final String studentId;
  final String content;
  final String? fileUrl;
  final String status;
  final DateTime submittedAt;
  final int? marks;

  Submission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.content,
    this.fileUrl,
    required this.status,
    required this.submittedAt,
    this.marks,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['_id'] ?? '',
      assignmentId: json['assignmentId'] is String
          ? json['assignmentId']
          : json['assignmentId']['_id'] ?? '',
      studentId: json['studentId'] is String
          ? json['studentId']
          : json['studentId']['_id'] ?? '',
      content: json['content'] ?? '',
      fileUrl: json['fileUrl'],
      status: json['status'] ?? 'pending',
      submittedAt: DateTime.parse(json['submittedAt']),
      marks: json['marks'],
    );
  }
}
