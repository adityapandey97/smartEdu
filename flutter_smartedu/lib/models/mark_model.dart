class Mark {
  final String id;
  final String studentId;
  final String subject;
  final String examType;
  final double marks;
  final double total;
  final double maxMarks;
  final DateTime createdAt;

  Mark({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.examType,
    required this.marks,
    required this.total,
    double? maxMarks,
    required this.createdAt,
  }) : maxMarks = maxMarks ?? total;

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      id: json['_id'] ?? '',
      studentId: json['studentId'] is String
          ? json['studentId']
          : json['studentId']['_id'] ?? '',
      subject: json['subject'] ?? '',
      examType: json['examType'] ?? '',
      marks: (json['marks'] ?? 0).toDouble(),
      total: (json['total'] ?? 100).toDouble(),
      maxMarks: (json['maxMarks'] ?? json['total'] ?? 100).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class MarkSummary {
  final String subject;
  final double average;
  final int totalExams;

  MarkSummary({
    required this.subject,
    required this.average,
    required this.totalExams,
  });

  factory MarkSummary.fromJson(Map<String, dynamic> json) {
    return MarkSummary(
      subject: json['subject'] ?? '',
      average: double.tryParse(json['average'].toString()) ?? 0.0,
      totalExams: json['totalExams'] ?? 0,
    );
  }
}

class MarksAnalytics {
  final List<MarkSummary> summary;
  final double overallAverage;
  final List<Mark> marks;

  MarksAnalytics({
    required this.summary,
    required this.overallAverage,
    required this.marks,
  });

  factory MarksAnalytics.fromJson(Map<String, dynamic> json) {
    return MarksAnalytics(
      summary: (json['summary'] as List?)
              ?.map((s) => MarkSummary.fromJson(s))
              .toList() ??
          [],
      overallAverage: double.tryParse(json['overallAverage'].toString()) ?? 0.0,
      marks:
          (json['marks'] as List?)?.map((m) => Mark.fromJson(m)).toList() ?? [],
    );
  }
}
