class Quiz {
  final String id;
  final String title;
  final String subject;
  final int duration;
  final List<QuizQuestion> questions;
  final String createdBy;
  final DateTime createdAt;
  final DateTime dueDate;
  final String teacherName;

  Quiz({
    required this.id,
    required this.title,
    required this.subject,
    required this.duration,
    required this.questions,
    required this.createdBy,
    required this.createdAt,
    DateTime? dueDate,
    this.teacherName = '',
  }) : dueDate = dueDate ?? createdAt.add(const Duration(days: 7));

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      duration: json['duration'] ?? 15,
      questions: (json['questions'] as List?)
              ?.map((q) => QuizQuestion.fromJson(q))
              .toList() ??
          [],
      createdBy: json['createdBy'] is String
          ? json['createdBy']
          : json['createdBy']['_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.parse(json['createdAt']).add(const Duration(days: 7)),
      teacherName: json['teacherName'] ?? '',
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final int correctOption; // Alias for correctAnswer

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    int? correctOption,
  }) : correctOption = correctOption ?? correctAnswer;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? 0,
      correctOption: json['correctOption'],
    );
  }
}

class QuizResult {
  final String id;
  final String quizId;
  final String studentId;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
  });

  double get percentage =>
      totalQuestions > 0 ? (score / totalQuestions) * 100 : 0.0;

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['_id'] ?? '',
      quizId: json['quizId'] is String
          ? json['quizId']
          : json['quizId']['_id'] ?? '',
      studentId: json['studentId'] is String
          ? json['studentId']
          : json['studentId']['_id'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      completedAt: DateTime.parse(json['completedAt']),
    );
  }
}
