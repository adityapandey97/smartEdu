import '../models/assignment_model.dart';
import '../models/attendance_model.dart';
import '../models/dashboard_insight_model.dart';
import '../models/event_model.dart';
import '../models/feedback_model.dart';
import '../models/holiday_model.dart';
import '../models/leave_model.dart';
import '../models/mark_model.dart';
import '../models/material_model.dart';
import '../models/notification_model.dart';
import '../models/quiz_model.dart';
import '../models/schedule_model.dart';
import '../models/user_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();

  factory MockDataService() => _instance;

  MockDataService._internal();

  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isStudent = true;

  final List<User> _students = [];
  final List<User> _teachers = [];
  final List<AttendanceOverview> _attendanceData = [];
  final List<AttendanceIssue> _attendanceIssues = [];
  final List<Assignment> _assignments = [];
  final List<Submission> _submissions = [];
  final List<Mark> _marks = [];
  final List<AppNotification> _notifications = [];
  final List<Quiz> _quizzes = [];
  final List<QuizResult> _quizResults = [];
  final List<Material> _materials = [];
  final List<Schedule> _schedules = [];
  final List<Holiday> _holidays = [];
  final List<LeaveApplication> _leaveApplications = [];
  final List<Event> _events = [];
  final List<Feedback> _feedbackList = [];

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isStudent => _isStudent;
  bool get isTeacher => !_isStudent;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final normalizedEmail = email.trim().toLowerCase();
    final inferredTeacher =
        normalizedEmail.contains('teacher') || normalizedEmail.contains('prof');

    _isStudent = !inferredTeacher;
    _currentUser = User(
      id: inferredTeacher ? 'TCH-LIVE' : 'STU-LIVE',
      name: _nameFromEmail(normalizedEmail, fallback: inferredTeacher ? 'Teacher' : 'Student'),
      email: normalizedEmail,
      role: inferredTeacher ? 'teacher' : 'student',
      department: 'Computer Science',
      semester: inferredTeacher ? null : 1,
      studentId: inferredTeacher ? null : 'NEW-STUDENT',
    );
    _isLoggedIn = true;
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final normalizedRole = role.toLowerCase();
    _isStudent = normalizedRole != 'teacher';
    _currentUser = User(
      id: _isStudent ? 'STU-LIVE' : 'TCH-LIVE',
      name: name.trim().isEmpty ? (_isStudent ? 'Student' : 'Teacher') : name.trim(),
      email: email.trim(),
      role: _isStudent ? 'student' : 'teacher',
      department: 'Computer Science',
      semester: _isStudent ? 1 : null,
      studentId: _isStudent ? 'NEW-STUDENT' : null,
    );
    _isLoggedIn = true;
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _isStudent = true;
  }

  List<AttendanceOverview> getAttendanceOverview() =>
      List.unmodifiable(_attendanceData);
  List<AttendanceIssue> getAttendanceIssues() =>
      List.unmodifiable(_attendanceIssues);
  List<Assignment> getAssignments() => List.unmodifiable(_assignments);
  List<Submission> getSubmissions() => List.unmodifiable(_submissions);
  List<Mark> getMarks() => List.unmodifiable(_marks);
  List<AppNotification> getNotifications() => List.unmodifiable(_notifications);
  List<Quiz> getQuizzes() => List.unmodifiable(_quizzes);
  List<QuizResult> getQuizResults() => List.unmodifiable(_quizResults);
  List<Material> getMaterials() => List.unmodifiable(_materials);
  List<Schedule> getSchedule() => List.unmodifiable(_schedules);
  List<Holiday> getHolidays() => List.unmodifiable(_holidays);
  List<LeaveApplication> getLeaveApplications() =>
      List.unmodifiable(_leaveApplications);
  List<Event> getEvents() => List.unmodifiable(_events);
  List<Feedback> getFeedbackList() => List.unmodifiable(_feedbackList);
  List<User> getStudents() => List.unmodifiable(_students);
  List<User> getTeachers() => List.unmodifiable(_teachers);

  int getUnreadNotificationCount() =>
      _notifications.where((notification) => !notification.isRead).length;

  double getOverallAttendancePercentage() {
    if (_attendanceData.isEmpty) {
      return 0;
    }

    final totalClasses =
        _attendanceData.fold<int>(0, (sum, item) => sum + item.totalClasses);
    final attendedClasses =
        _attendanceData.fold<int>(0, (sum, item) => sum + item.attendedClasses);

    if (totalClasses == 0) {
      return 0;
    }

    return attendedClasses / totalClasses * 100;
  }

  double getAverageMarks() {
    if (_marks.isEmpty) {
      return 0;
    }

    final totalScored = _marks.fold<double>(0, (sum, mark) => sum + mark.marks);
    final totalPossible = _marks.fold<double>(0, (sum, mark) => sum + mark.total);

    if (totalPossible == 0) {
      return 0;
    }

    return totalScored / totalPossible * 100;
  }

  int getPendingAssignments() => _assignments
      .where((assignment) => assignment.deadline.isAfter(DateTime.now()))
      .length;

  List<DashboardInsight> getStudentInsights() {
    if (_attendanceData.isEmpty &&
        _assignments.isEmpty &&
        _quizzes.isEmpty &&
        _notifications.isEmpty) {
      return const [
        DashboardInsight(
          title: 'Ready for live data',
          message:
              'Your dashboard is clean and waiting for attendance, assignments, and quiz records from the backend.',
          routeName: '/schedule',
          actionLabel: 'Open schedule',
          severity: 'low',
          iconKey: 'rocket',
        ),
        DashboardInsight(
          title: 'Set up your study flow',
          message:
              'Once real classes sync in, this area will surface deadlines, weak subjects, and preparation alerts automatically.',
          routeName: '/materials',
          actionLabel: 'Explore materials',
          severity: 'low',
          iconKey: 'spark',
        ),
      ];
    }

    final insights = <DashboardInsight>[];

    if (getPendingAssignments() > 0) {
      insights.add(
        DashboardInsight(
          title: 'Assignments in progress',
          message:
              '${getPendingAssignments()} task(s) are still open. Keep momentum on the nearest deadline first.',
          routeName: '/assignments',
          actionLabel: 'View assignments',
          severity: 'medium',
          iconKey: 'assignment',
        ),
      );
    }

    if (getOverallAttendancePercentage() > 0 &&
        getOverallAttendancePercentage() < 75) {
      insights.add(
        DashboardInsight(
          title: 'Attendance needs action',
          message:
              'Your current attendance is ${getOverallAttendancePercentage().toStringAsFixed(1)}%. Protect eligibility before the next review.',
          routeName: '/attendance',
          actionLabel: 'Review attendance',
          severity: 'high',
          iconKey: 'warning',
        ),
      );
    }

    if (_quizzes.isNotEmpty) {
      insights.add(
        DashboardInsight(
          title: 'Quiz window active',
          message: 'There are quiz records available for your current subjects.',
          routeName: '/quizzes',
          actionLabel: 'Open quizzes',
          severity: 'low',
          iconKey: 'quiz',
        ),
      );
    }

    return insights;
  }

  List<DashboardInsight> getTeacherInsights() {
    if (_attendanceIssues.isEmpty &&
        _assignments.isEmpty &&
        _materials.isEmpty &&
        _schedules.isEmpty) {
      return const [
        DashboardInsight(
          title: 'Teaching space is ready',
          message:
              'No placeholder records are being shown. This dashboard will elevate real classes, issues, and delivery metrics as soon as backend data arrives.',
          routeName: '/create-assignment',
          actionLabel: 'Create assignment',
          severity: 'low',
          iconKey: 'spark',
        ),
        DashboardInsight(
          title: 'Start with classroom tools',
          message:
              'You can use OTP attendance, content uploads, and quiz creation once live academic data is connected.',
          routeName: '/generate-attendance-otp',
          actionLabel: 'Attendance tools',
          severity: 'low',
          iconKey: 'rocket',
        ),
      ];
    }

    final insights = <DashboardInsight>[];

    if (_attendanceIssues.isNotEmpty) {
      insights.add(
        DashboardInsight(
          title: 'Attendance issues pending',
          message:
              '${_attendanceIssues.length} issue(s) need review and closure.',
          routeName: '/attendance-issues',
          actionLabel: 'Review issues',
          severity: 'high',
          iconKey: 'warning',
        ),
      );
    }

    if (getPendingAssignments() > 0) {
      insights.add(
        DashboardInsight(
          title: 'Active assessments running',
          message:
              '${getPendingAssignments()} assignment(s) are still collecting submissions.',
          routeName: '/create-assignment',
          actionLabel: 'Manage assignments',
          severity: 'medium',
          iconKey: 'assignment',
        ),
      );
    }

    return insights;
  }

  List<FocusMetric> getStudentFocusMetrics() {
    return [
      FocusMetric(
        label: 'Attendance',
        value: _attendanceData.isEmpty
            ? '--'
            : '${getOverallAttendancePercentage().toStringAsFixed(1)}%',
        helperText: _attendanceData.isEmpty
            ? 'Waiting for live attendance sync'
            : 'Current aggregate across enrolled classes',
      ),
      FocusMetric(
        label: 'Assignments',
        value: '${getPendingAssignments()}',
        helperText: _assignments.isEmpty
            ? 'No live assignment records yet'
            : 'Pending tasks still open for submission',
      ),
      FocusMetric(
        label: 'Notifications',
        value: '${getUnreadNotificationCount()}',
        helperText: _notifications.isEmpty
            ? 'No unread updates right now'
            : 'Unread schedule or academic alerts',
      ),
    ];
  }

  List<FocusMetric> getTeacherFocusMetrics() {
    return [
      FocusMetric(
        label: 'Students',
        value: '${_students.length}',
        helperText: _students.isEmpty
            ? 'Roster will appear after backend sync'
            : 'Active learners in current sections',
      ),
      FocusMetric(
        label: 'Issues',
        value: '${_attendanceIssues.length}',
        helperText: _attendanceIssues.isEmpty
            ? 'No pending attendance issues'
            : 'Attendance cases awaiting your action',
      ),
      FocusMetric(
        label: 'Materials',
        value: '${_materials.length}',
        helperText: _materials.isEmpty
            ? 'No live resources uploaded yet'
            : 'Resources available to students',
      ),
    ];
  }

  List<Schedule> getTodayClasses() {
    final weekday = DateTime.now().weekday;
    return _schedules.where((schedule) => schedule.dayOfWeek == weekday).toList()
      ..sort((a, b) => a.period.compareTo(b.period));
  }

  String _nameFromEmail(String email, {required String fallback}) {
    final localPart = email.split('@').first.trim();
    if (localPart.isEmpty) {
      return fallback;
    }

    final pieces = localPart.split(RegExp(r'[._-]+'));
    return pieces
        .where((piece) => piece.isNotEmpty)
        .map((piece) => '${piece[0].toUpperCase()}${piece.substring(1)}')
        .join(' ');
  }
}
