class Schedule {
  final String id;
  final int dayOfWeek;
  final int period;
  final String subject;
  final String teacherName;
  final String room;
  final bool isSubstitute;
  final String? substituteTeacher;

  Schedule({
    required this.id,
    required this.dayOfWeek,
    required this.period,
    required this.subject,
    required this.teacherName,
    required this.room,
    this.isSubstitute = false,
    this.substituteTeacher,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['_id'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? 1,
      period: json['period'] ?? 1,
      subject: json['subject'] ?? '',
      teacherName: json['teacherName'] ?? '',
      room: json['room'] ?? '',
      isSubstitute: json['isSubstitute'] ?? false,
      substituteTeacher: json['substituteTeacher'],
    );
  }

  String get dayName {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return dayOfWeek >= 1 && dayOfWeek <= 7 ? days[dayOfWeek - 1] : 'Unknown';
  }
}
