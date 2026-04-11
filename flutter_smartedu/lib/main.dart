import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/student_dashboard.dart';
import 'screens/teacher_dashboard.dart';
import 'screens/attendance_screen.dart';
import 'screens/report_attendance_issue_screen.dart';
import 'screens/attendance_issues_screen.dart';
import 'screens/assignments_screen.dart';
import 'screens/marks_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/materials_screen.dart';
import 'screens/quizzes_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/holidays_screen.dart';
import 'screens/leaves_screen.dart';
import 'screens/events_screen.dart';
import 'screens/take_attendance_screen.dart';
import 'screens/upload_marks_screen.dart';
import 'screens/create_assignment_screen.dart';
import 'screens/upload_material_screen.dart';
import 'screens/create_quiz_screen.dart';
import 'screens/generate_attendance_otp_screen.dart';
import 'screens/mark_attendance_with_otp_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const SmartEduApp());
}

class SmartEduApp extends StatelessWidget {
  const SmartEduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'SmartEdu',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/role-selection': (context) => const RoleSelectionScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/student-dashboard': (context) => const StudentDashboard(),
              '/teacher-dashboard': (context) => const TeacherDashboard(),
              '/attendance': (context) => const AttendanceScreen(),
              '/report-attendance-issue': (context) =>
                  const ReportAttendanceIssueScreen(),
              '/attendance-issues': (context) => const AttendanceIssuesScreen(),
              '/assignments': (context) => const AssignmentsScreen(),
              '/marks': (context) => const MarksScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/materials': (context) => const MaterialsScreen(),
              '/quizzes': (context) => const QuizzesScreen(),
              '/schedule': (context) => const ScheduleScreen(),
              '/feedback': (context) => const FeedbackScreen(),
              '/holidays': (context) => const HolidaysScreen(),
              '/leaves': (context) => const LeavesScreen(),
              '/events': (context) => const EventsScreen(),
              '/take-attendance': (context) => const TakeAttendanceScreen(),
              '/upload-marks': (context) => const UploadMarksScreen(),
              '/create-assignment': (context) => const CreateAssignmentScreen(),
              '/upload-material': (context) => const UploadMaterialScreen(),
              '/create-quiz': (context) => const CreateQuizScreen(),
              '/generate-attendance-otp': (context) =>
                  const GenerateAttendanceOTPScreen(),
              '/mark-attendance-otp': (context) =>
                  const MarkAttendanceWithOTPScreen(),
            },
          );
        },
      ),
    );
  }
}
