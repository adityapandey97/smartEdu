import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../models/assignment_model.dart';
import '../models/mark_model.dart';
import '../models/notification_model.dart';
import '../models/quiz_model.dart';
import '../models/material_model.dart';
import '../models/schedule_model.dart';
import '../models/feedback_model.dart';
import '../models/holiday_model.dart';
import '../models/leave_model.dart';
import '../models/event_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  User? _currentUser;
  User? get currentUser => _currentUser;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  bool _isStudent = true;

  final List<User> _demoStudents = [
    User(
        id: 'STU001',
        name: 'Rahul Sharma',
        email: 'rahul@smartedu.com',
        role: 'student',
        department: 'Computer Science',
        semester: 5,
        studentId: 'CS2021001'),
    User(
        id: 'STU002',
        name: 'Priya Patel',
        email: 'priya@smartedu.com',
        role: 'student',
        department: 'Computer Science',
        semester: 5,
        studentId: 'CS2021002'),
    User(
        id: 'STU003',
        name: 'Amit Kumar',
        email: 'amit@smartedu.com',
        role: 'student',
        department: 'Computer Science',
        semester: 5,
        studentId: 'CS2021003'),
    User(
        id: 'STU004',
        name: 'Sneha Gupta',
        email: 'sneha@smartedu.com',
        role: 'student',
        department: 'Computer Science',
        semester: 5,
        studentId: 'CS2021004'),
    User(
        id: 'STU005',
        name: 'Vikram Singh',
        email: 'vikram@smartedu.com',
        role: 'student',
        department: 'Computer Science',
        semester: 5,
        studentId: 'CS2021005'),
  ];

  final List<User> _demoTeachers = [
    User(
        id: 'TCH001',
        name: 'Dr. Rajesh Kumar',
        email: 'rajesh@smartedu.com',
        role: 'teacher',
        department: 'Computer Science'),
    User(
        id: 'TCH002',
        name: 'Prof. Anita Verma',
        email: 'anita@smartedu.com',
        role: 'teacher',
        department: 'Computer Science'),
  ];

  final List<AttendanceOverview> _attendanceData = [
    AttendanceOverview(
        subject: 'DBMS',
        totalClasses: 45,
        presentClasses: 42,
        percentage: 93.3,
        isBelow75: false),
    AttendanceOverview(
        subject: 'Operating Systems',
        totalClasses: 40,
        presentClasses: 35,
        percentage: 87.5,
        isBelow75: false),
    AttendanceOverview(
        subject: 'Computer Networks',
        totalClasses: 38,
        presentClasses: 36,
        percentage: 94.7,
        isBelow75: false),
    AttendanceOverview(
        subject: 'Software Engineering',
        totalClasses: 35,
        presentClasses: 32,
        percentage: 91.4,
        isBelow75: false),
  ];

  final List<AttendanceOverview> _teacherAttendanceData = [
    AttendanceOverview(
        subject: 'DBMS',
        totalClasses: 45,
        presentClasses: 42,
        percentage: 93.3,
        isBelow75: false),
    AttendanceOverview(
        subject: 'Operating Systems',
        totalClasses: 40,
        presentClasses: 38,
        percentage: 95.0,
        isBelow75: false),
    AttendanceOverview(
        subject: 'Computer Networks',
        totalClasses: 38,
        presentClasses: 35,
        percentage: 92.1,
        isBelow75: false),
    AttendanceOverview(
        subject: 'Software Engineering',
        totalClasses: 35,
        presentClasses: 33,
        percentage: 94.3,
        isBelow75: false),
  ];

  final List<AttendanceIssue> _attendanceIssues = [
    AttendanceIssue(
      id: 'ISS001',
      studentId: 'STU002',
      studentName: 'Priya Patel',
      subject: 'DBMS',
      date: DateTime.now().subtract(const Duration(days: 3)),
      issueType: 'Medical',
      description: 'Medical emergency - was in hospital',
      status: 'pending',
    ),
    AttendanceIssue(
      id: 'ISS002',
      studentId: 'STU003',
      studentName: 'Amit Kumar',
      subject: 'Operating Systems',
      date: DateTime.now().subtract(const Duration(days: 5)),
      issueType: 'Personal',
      description: 'Family function - informed teacher via email',
      status: 'pending',
    ),
  ];

  final List<Assignment> _assignments = [
    Assignment(
      id: 'ASN001',
      title: 'DBMS Project - Library Management System',
      description:
          'Design and implement a library management system using SQL and normalization techniques.',
      subject: 'DBMS',
      deadline: DateTime.now().add(const Duration(days: 7)),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      maxMarks: 100,
      teacherId: 'TCH001',
      teacherName: 'Dr. Rajesh Kumar',
      createdBy: 'TCH001',
    ),
    Assignment(
      id: 'ASN002',
      title: 'OS Assignment - Process Scheduling',
      description:
          'Implement different process scheduling algorithms (FCFS, SJF, Round Robin) in C.',
      subject: 'Operating Systems',
      deadline: DateTime.now().add(const Duration(days: 5)),
      dueDate: DateTime.now().add(const Duration(days: 5)),
      maxMarks: 50,
      teacherId: 'TCH001',
      teacherName: 'Dr. Rajesh Kumar',
      createdBy: 'TCH001',
    ),
    Assignment(
      id: 'ASN003',
      title: 'Network Assignment - Socket Programming',
      description: 'Create a client-server application using TCP/IP sockets.',
      subject: 'Computer Networks',
      deadline: DateTime.now().add(const Duration(days: 10)),
      dueDate: DateTime.now().add(const Duration(days: 10)),
      maxMarks: 75,
      teacherId: 'TCH002',
      teacherName: 'Prof. Anita Verma',
      createdBy: 'TCH002',
    ),
    Assignment(
      id: 'ASN004',
      title: 'SE Assignment - Use Case Diagrams',
      description: 'Create comprehensive use case diagrams for an ATM system.',
      subject: 'Software Engineering',
      deadline: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      maxMarks: 50,
      teacherId: 'TCH002',
      teacherName: 'Prof. Anita Verma',
      createdBy: 'TCH002',
    ),
  ];

  final List<Submission> _submissions = [
    Submission(
        id: 'SUB001',
        assignmentId: 'ASN004',
        studentId: 'STU001',
        content: 'Submitted assignment',
        submittedAt: DateTime.now().subtract(const Duration(days: 3)),
        status: 'submitted',
        fileUrl: 'files/submission.pdf',
        marks: 45),
  ];

  final List<Mark> _marks = [
    Mark(
        id: 'MK001',
        studentId: 'STU001',
        subject: 'DBMS',
        examType: 'Mid Term',
        marks: 85,
        total: 100,
        createdAt: DateTime.now().subtract(const Duration(days: 30))),
    Mark(
        id: 'MK002',
        studentId: 'STU001',
        subject: 'DBMS',
        examType: 'Quiz 1',
        marks: 18,
        total: 20,
        createdAt: DateTime.now().subtract(const Duration(days: 20))),
    Mark(
        id: 'MK003',
        studentId: 'STU001',
        subject: 'Operating Systems',
        examType: 'Mid Term',
        marks: 78,
        total: 100,
        createdAt: DateTime.now().subtract(const Duration(days: 30))),
    Mark(
        id: 'MK004',
        studentId: 'STU001',
        subject: 'Operating Systems',
        examType: 'Quiz 1',
        marks: 15,
        total: 20,
        createdAt: DateTime.now().subtract(const Duration(days: 20))),
    Mark(
        id: 'MK005',
        studentId: 'STU001',
        subject: 'Computer Networks',
        examType: 'Mid Term',
        marks: 92,
        total: 100,
        createdAt: DateTime.now().subtract(const Duration(days: 30))),
    Mark(
        id: 'MK006',
        studentId: 'STU001',
        subject: 'Computer Networks',
        examType: 'Quiz 1',
        marks: 19,
        total: 20,
        createdAt: DateTime.now().subtract(const Duration(days: 20))),
    Mark(
        id: 'MK007',
        studentId: 'STU001',
        subject: 'Software Engineering',
        examType: 'Mid Term',
        marks: 88,
        total: 100,
        createdAt: DateTime.now().subtract(const Duration(days: 30))),
    Mark(
        id: 'MK008',
        studentId: 'STU001',
        subject: 'Software Engineering',
        examType: 'Quiz 1',
        marks: 17,
        total: 20,
        createdAt: DateTime.now().subtract(const Duration(days: 20))),
  ];

  final List<AppNotification> _notifications = [
    AppNotification(
        id: 'NTF001',
        title: 'Attendance Warning',
        message:
            'Your attendance in DBMS has dropped below 75%. Please attend upcoming classes.',
        type: 'attendance',
        read: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    AppNotification(
        id: 'NTF002',
        title: 'New Assignment',
        message:
            'New assignment posted: DBMS Project - Library Management System',
        type: 'assignment',
        read: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    AppNotification(
        id: 'NTF003',
        title: 'Holiday Announcement',
        message:
            'College will remain closed on 15th April for Holi celebration.',
        type: 'holiday',
        read: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1))),
    AppNotification(
        id: 'NTF004',
        title: 'Quiz Result',
        message: 'Your Quiz 1 result in DBMS is out. Score: 18/20',
        type: 'quiz',
        read: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2))),
    AppNotification(
        id: 'NTF005',
        title: 'Class Timetable Change',
        message: 'DBMS class timing changed to 9:00 AM from tomorrow.',
        type: 'schedule',
        read: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3))),
  ];

  final List<Quiz> _quizzes = [
    Quiz(
      id: 'QZ001',
      title: 'DBMS Fundamentals',
      subject: 'DBMS',
      duration: 30,
      createdBy: 'TCH001',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      questions: [
        QuizQuestion(
            question: 'What is normalization?',
            options: [
              'Database concept',
              'Process to reduce redundancy',
              'Type of database',
              'Query language'
            ],
            correctAnswer: 1),
        QuizQuestion(
            question: 'SQL stands for?',
            options: [
              'Structured Query Language',
              'Simple Query Language',
              'Standard Query Language',
              'System Query Language'
            ],
            correctAnswer: 0),
        QuizQuestion(
            question: 'Primary key can be?',
            options: ['Null', 'Duplicate', 'Unique', 'Temporary'],
            correctAnswer: 2),
      ],
      teacherName: 'Dr. Rajesh Kumar',
    ),
    Quiz(
      id: 'QZ002',
      title: 'OS Process Management',
      subject: 'Operating Systems',
      duration: 20,
      createdBy: 'TCH001',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      questions: [
        QuizQuestion(
            question: 'What is a process?',
            options: ['Program in execution', 'Compiler', 'Type of OS', 'File'],
            correctAnswer: 0),
        QuizQuestion(
            question: 'FCFS scheduling is?',
            options: ['Non-preemptive', 'Preemptive', 'Both', 'Neither'],
            correctAnswer: 0),
      ],
      teacherName: 'Dr. Rajesh Kumar',
    ),
    Quiz(
      id: 'QZ003',
      title: 'Computer Networks Basics',
      subject: 'Computer Networks',
      duration: 25,
      createdBy: 'TCH002',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      questions: [
        QuizQuestion(
            question: 'OSI model has how many layers?',
            options: ['5', '6', '7', '8'],
            correctAnswer: 2),
        QuizQuestion(
            question: 'TCP is connection-oriented?',
            options: ['Yes', 'No', 'Maybe', 'Depends'],
            correctAnswer: 0),
      ],
      teacherName: 'Prof. Anita Verma',
    ),
  ];

  final List<QuizResult> _quizResults = [
    QuizResult(
        id: 'QR001',
        quizId: 'QZ003',
        studentId: 'STU001',
        score: 40,
        totalQuestions: 50,
        completedAt: DateTime.now().subtract(const Duration(days: 2))),
  ];

  final List<Material> _materials = [
    Material(
        id: 'MAT001',
        title: 'DBMS Complete Notes',
        description: 'Comprehensive notes covering all DBMS topics',
        subject: 'DBMS',
        type: 'Notes',
        fileUrl: 'files/dbms_notes.pdf',
        uploadedBy: 'TCH001',
        uploadedByName: 'Dr. Rajesh Kumar',
        createdAt: DateTime.now().subtract(const Duration(days: 10))),
    Material(
        id: 'MAT002',
        title: 'SQL Cheat Sheet',
        description: 'Quick reference guide for SQL queries',
        subject: 'DBMS',
        type: 'Reference',
        fileUrl: 'files/sql_cheatsheet.pdf',
        uploadedBy: 'TCH001',
        uploadedByName: 'Dr. Rajesh Kumar',
        createdAt: DateTime.now().subtract(const Duration(days: 5))),
    Material(
        id: 'MAT003',
        title: 'OS Process Scheduling PPT',
        description: 'PowerPoint presentation on process scheduling',
        subject: 'Operating Systems',
        type: 'Slides',
        fileUrl: 'files/os_scheduling.pptx',
        uploadedBy: 'TCH001',
        uploadedByName: 'Dr. Rajesh Kumar',
        createdAt: DateTime.now().subtract(const Duration(days: 15))),
    Material(
        id: 'MAT004',
        title: 'Network Layers Diagram',
        description: 'Visual representation of OSI model layers',
        subject: 'Computer Networks',
        type: 'Image',
        fileUrl: 'files/osi_layers.png',
        uploadedBy: 'TCH002',
        uploadedByName: 'Prof. Anita Verma',
        createdAt: DateTime.now().subtract(const Duration(days: 7))),
  ];

  final List<Schedule> _schedules = [
    Schedule(
        id: 'SCH001',
        dayOfWeek: 1,
        period: 1,
        subject: 'DBMS',
        room: 'CS Lab 1',
        teacherName: 'Dr. Rajesh Kumar'),
    Schedule(
        id: 'SCH002',
        dayOfWeek: 1,
        period: 2,
        subject: 'Operating Systems',
        room: 'CS Lab 2',
        teacherName: 'Dr. Rajesh Kumar'),
    Schedule(
        id: 'SCH003',
        dayOfWeek: 2,
        period: 1,
        subject: 'Computer Networks',
        room: 'CS Lab 1',
        teacherName: 'Prof. Anita Verma'),
    Schedule(
        id: 'SCH004',
        dayOfWeek: 2,
        period: 2,
        subject: 'Software Engineering',
        room: 'CS Lab 2',
        teacherName: 'Prof. Anita Verma'),
    Schedule(
        id: 'SCH005',
        dayOfWeek: 3,
        period: 1,
        subject: 'DBMS',
        room: 'CS Lab 1',
        teacherName: 'Dr. Rajesh Kumar'),
    Schedule(
        id: 'SCH006',
        dayOfWeek: 4,
        period: 2,
        subject: 'Operating Systems',
        room: 'CS Lab 2',
        teacherName: 'Dr. Rajesh Kumar'),
    Schedule(
        id: 'SCH007',
        dayOfWeek: 5,
        period: 1,
        subject: 'Computer Networks',
        room: 'CS Lab 1',
        teacherName: 'Prof. Anita Verma'),
  ];

  final List<Holiday> _holidays = [
    Holiday(
        id: 'HOL001',
        title: 'Holi',
        date: DateTime(2026, 3, 14),
        reason: 'Festival of Colors'),
    Holiday(
        id: 'HOL002',
        title: 'Good Friday',
        date: DateTime(2026, 4, 3),
        reason: 'Religious Holiday'),
    Holiday(
        id: 'HOL003',
        title: 'Independence Day',
        date: DateTime(2026, 8, 15),
        reason: 'National Holiday'),
    Holiday(
        id: 'HOL004',
        title: 'Gandhi Jayanti',
        date: DateTime(2026, 10, 2),
        reason: 'Birth Anniversary of Mahatma Gandhi'),
  ];

  final List<LeaveApplication> _leaveApplications = [
    LeaveApplication(
        id: 'LV001',
        studentId: 'STU001',
        reason: 'Medical checkup',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 2)),
        status: 'pending',
        createdAt: DateTime.now()),
  ];

  final List<Event> _events = [
    Event(
        id: 'EVT001',
        title: 'Tech Fest 2026',
        description: 'Annual technical fest with coding competitions',
        date: DateTime.now().add(const Duration(days: 20)),
        venue: 'Main Auditorium'),
    Event(
        id: 'EVT002',
        title: 'Workshop on AI/ML',
        description: 'Hands-on workshop on Machine Learning',
        date: DateTime.now().add(const Duration(days: 15)),
        venue: 'CS Lab 1'),
    Event(
        id: 'EVT003',
        title: 'Campus Placement Drive',
        description: 'TCS and Infosys recruiting for 2026 batch',
        date: DateTime.now().add(const Duration(days: 30)),
        venue: 'Placement Cell'),
  ];

  final List<Feedback> _feedbackList = [
    Feedback(
        id: 'FDB001',
        studentId: 'STU001',
        teacherId: 'TCH001',
        subject: 'DBMS',
        rating: 4,
        comment:
            'Excellent teaching methodology. Would appreciate more practical sessions.',
        createdAt: DateTime.now().subtract(const Duration(days: 5))),
    Feedback(
        id: 'FDB002',
        studentId: 'STU002',
        teacherId: 'TCH001',
        subject: 'Operating Systems',
        rating: 5,
        comment: 'Very helpful and supportive faculty.',
        createdAt: DateTime.now().subtract(const Duration(days: 10))),
  ];

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.contains('teacher') || email.contains('professor')) {
      _currentUser = _demoTeachers.first;
      _isStudent = false;
    } else {
      _currentUser = _demoStudents.first;
      _isStudent = true;
    }
    _isLoggedIn = true;
  }

  Future<void> register(
      String name, String email, String password, String role) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (role == 'teacher') {
      _currentUser = _demoTeachers.first;
      _isStudent = false;
    } else {
      _currentUser = _demoStudents.first;
      _isStudent = true;
    }
    _isLoggedIn = true;
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _isStudent = true;
  }

  bool get isStudent => _isStudent;
  bool get isTeacher => !_isStudent;

  List<AttendanceOverview> getAttendanceOverview() =>
      _isStudent ? _attendanceData : _teacherAttendanceData;
  List<AttendanceIssue> getAttendanceIssues() => _attendanceIssues;
  List<Assignment> getAssignments() => _assignments;
  List<Submission> getSubmissions() => _submissions;
  List<Mark> getMarks() => _marks;
  List<AppNotification> getNotifications() => _notifications;
  List<Quiz> getQuizzes() => _quizzes;
  List<QuizResult> getQuizResults() => _quizResults;
  List<Material> getMaterials() => _materials;
  List<Schedule> getSchedule() => _schedules;
  List<Holiday> getHolidays() => _holidays;
  List<LeaveApplication> getLeaveApplications() => _leaveApplications;
  List<Event> getEvents() => _events;
  List<Feedback> getFeedbackList() => _feedbackList;
  List<User> getStudents() => _demoStudents;
  List<User> getTeachers() => _demoTeachers;

  int getUnreadNotificationCount() =>
      _notifications.where((n) => !n.isRead).length;
  double getOverallAttendancePercentage() {
    if (_attendanceData.isEmpty) return 0;
    final total =
        _attendanceData.fold<int>(0, (sum, a) => sum + a.totalClasses);
    final attended =
        _attendanceData.fold<int>(0, (sum, a) => sum + a.attendedClasses);
    return (attended / total * 100);
  }

  double getAverageMarks() {
    if (_marks.isEmpty) return 0;
    final total = _marks.fold<double>(0, (sum, m) => sum + m.marks);
    final max = _marks.fold<double>(0, (sum, m) => sum + m.maxMarks);
    return (total / max * 100);
  }

  int getPendingAssignments() =>
      _assignments.where((a) => a.dueDate.isAfter(DateTime.now())).length;
}
