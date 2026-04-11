class AttendanceRecord {
  final String id;
  final String studentId;
  final String subject;
  final DateTime date;
  final String status;
  final String? otpUsed; // OTP that was used for marking attendance
  final DateTime? otpVerifiedAt; // When the OTP was verified

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.date,
    required this.status,
    this.otpUsed,
    this.otpVerifiedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['_id'] ?? '',
      studentId: json['studentId'] is String
          ? json['studentId']
          : json['studentId']['_id'] ?? '',
      subject: json['subject'] ?? '',
      date: DateTime.parse(json['date']),
      status: json['status'] ?? '',
      otpUsed: json['otpUsed'],
      otpVerifiedAt: json['otpVerifiedAt'] != null
          ? DateTime.parse(json['otpVerifiedAt'])
          : null,
    );
  }
}

class AttendanceOTPSession {
  final String id;
  final String teacherId;
  final String subject;
  final String otp;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final bool isActive;
  final List<String> verifiedStudentIds;

  AttendanceOTPSession({
    required this.id,
    required this.teacherId,
    required this.subject,
    required this.otp,
    required this.generatedAt,
    required this.expiresAt,
    required this.isActive,
    this.verifiedStudentIds = const [],
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isValid => isActive && !isExpired;

  factory AttendanceOTPSession.fromJson(Map<String, dynamic> json) {
    return AttendanceOTPSession(
      id: json['_id'] ?? '',
      teacherId: json['teacherId'] ?? '',
      subject: json['subject'] ?? '',
      otp: json['otp'] ?? '',
      generatedAt: DateTime.parse(json['generatedAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      isActive: json['isActive'] ?? false,
      verifiedStudentIds: List<String>.from(json['verifiedStudentIds'] ?? []),
    );
  }
}

class AttendanceOverview {
  final int totalClasses;
  final int presentClasses;
  final int attendedClasses; // Alias for presentClasses
  final double percentage;
  final bool isBelow75;
  final String subject;

  AttendanceOverview({
    required this.totalClasses,
    required this.presentClasses,
    int? attendedClasses,
    required this.percentage,
    required this.isBelow75,
    this.subject = '',
  }) : attendedClasses = attendedClasses ?? presentClasses;

  factory AttendanceOverview.fromJson(Map<String, dynamic> json) {
    return AttendanceOverview(
      totalClasses: json['totalClasses'] ?? 0,
      presentClasses: json['presentClasses'] ?? 0,
      attendedClasses: json['attendedClasses'] ?? json['presentClasses'] ?? 0,
      percentage: double.tryParse(json['percentage'].toString()) ?? 0.0,
      isBelow75: json['isBelow75'] ?? false,
      subject: json['subject'] ?? '',
    );
  }
}

class SubjectAttendance {
  final String subject;
  final int total;
  final int present;
  final double percentage;

  SubjectAttendance({
    required this.subject,
    required this.total,
    required this.present,
    required this.percentage,
  });

  factory SubjectAttendance.fromJson(Map<String, dynamic> json) {
    return SubjectAttendance(
      subject: json['subject'] ?? '',
      total: json['total'] ?? 0,
      present: json['present'] ?? 0,
      percentage: double.tryParse(json['percentage'].toString()) ?? 0.0,
    );
  }
}

class AttendanceIssue {
  final String id;
  final String studentId;
  final String studentName;
  final String subject;
  final DateTime date;
  final String issueType;
  final String description;
  final String? proof;
  final String status;

  AttendanceIssue({
    required this.id,
    required this.studentId,
    this.studentName = '',
    required this.subject,
    required this.date,
    required this.issueType,
    required this.description,
    this.proof,
    required this.status,
  });

  factory AttendanceIssue.fromJson(Map<String, dynamic> json) {
    return AttendanceIssue(
      id: json['_id'] ?? '',
      studentId: json['studentId'] is String
          ? json['studentId']
          : json['studentId']['_id'] ?? '',
      studentName:
          json['studentId'] is Map ? json['studentId']['name'] ?? '' : '',
      subject: json['subject'] ?? '',
      date: DateTime.parse(json['date']),
      issueType: json['issueType'] ?? '',
      description: json['description'] ?? '',
      proof: json['proof'],
      status: json['status'] ?? 'pending',
    );
  }
}
