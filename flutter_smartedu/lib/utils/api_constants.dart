class ApiConstants {
  static const bool useMock = true;
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';

  static const String markAttendance = '/attendance/mark';
  static const String getStudentAttendance = '/attendance/student';
  static const String getAttendanceOverview = '/attendance/overview';
  static const String reportIssue = '/attendance/report-issue';
  static const String getPendingIssues = '/attendance/issues/pending';
  static const String resolveIssue = '/attendance/resolve';
  static const String getMyIssues = '/attendance/my-issues';

  static const String createAssignment = '/assignments/create';
  static const String getAssignments = '/assignments';
  static const String getAssignment = '/assignments';
  static const String submitAssignment = '/assignments/submit';
  static const String getSubmissions = '/assignments/submissions';
  static const String getMySubmissions = '/assignments/my-submissions';
  static const String getPendingAssignments = '/assignments/pending';

  static const String uploadMarks = '/marks/upload';
  static const String getStudentMarks = '/marks/student';
  static const String getAverageMarks = '/marks/average';
  static const String getAnalytics = '/marks/analytics';

  static const String createNotification = '/notifications/create';
  static const String getNotifications = '/notifications';
  static const String getUnreadCount = '/notifications/unread-count';
  static const String markAsRead = '/notifications/read';
  static const String markAllAsRead = '/notifications/read-all';

  static const String createQuiz = '/quizzes/create';
  static const String getQuizzes = '/quizzes';
  static const String getQuiz = '/quizzes';
  static const String submitQuiz = '/quizzes/submit';
  static const String getMyResults = '/quizzes/my-results';
  static const String getQuizResults = '/quizzes/results';

  static const String uploadMaterial = '/materials/upload';
  static const String getMaterials = '/materials';
  static const String getMaterialsBySubject = '/materials/subject';

  static const String createSchedule = '/schedules/create';
  static const String getSchedule = '/schedules';
  static const String setSubstitute = '/schedules/substitute';

  static const String submitFeedback = '/feedback/submit';
  static const String getFeedback = '/feedback';
  static const String getTeacherFeedback = '/feedback/teacher';

  static const String createHoliday = '/holidays/create';
  static const String getHolidays = '/holidays';

  static const String applyLeave = '/leaves/apply';
  static const String getMyApplications = '/leaves/my-applications';
  static const String getAllApplications = '/leaves/all';
  static const String reviewApplication = '/leaves/review';

  static const String createEvent = '/events/create';
  static const String getEvents = '/events';
  static const String registerForEvent = '/events/register';
  static const String getMyEvents = '/events/my-events';
}
