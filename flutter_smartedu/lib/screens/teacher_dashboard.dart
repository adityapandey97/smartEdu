import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_insight_model.dart';
import '../utils/theme_provider.dart';
import '../utils/app_theme.dart';
import '../services/mock_data_service.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final MockDataService _mockData = MockDataService();
  int _totalStudents = 0;
  int _pendingAttendanceIssues = 0;
  int _pendingAssignments = 0;
  List<DashboardInsight> _insights = const [];
  List<FocusMetric> _focusMetrics = const [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    setState(() {
      _totalStudents = _mockData.getStudents().length;
      _pendingAttendanceIssues = _mockData.getAttendanceIssues().length;
      _pendingAssignments = _mockData
          .getAssignments()
          .where((a) => a.deadline.isAfter(DateTime.now()))
          .length;
      _insights = _mockData.getTeacherInsights();
      _focusMetrics = _mockData.getTeacherFocusMetrics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _mockData.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final secondaryColor =
        isDark ? AppColors.secondaryDark : AppColors.secondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartEdu - Teacher'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryColor, secondaryColor])),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(themeProvider.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
          IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => Navigator.pushNamed(context, '/notifications')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadDashboardData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'T',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome, ${user?.name ?? 'Teacher'}!',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(user?.department ?? 'Computer Science',
                              style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildStatCards(primaryColor),
              const SizedBox(height: 24),
              _buildQuickActions(context, primaryColor),
              const SizedBox(height: 24),
              _buildClassroomPulse(context, primaryColor),
              const SizedBox(height: 24),
              _buildRecentActivity(context, primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCards(Color primaryColor) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard('Total Students', '$_totalStudents', Icons.people,
            AppColors.primary),
        _buildStatCard('Pending Issues', '$_pendingAttendanceIssues',
            Icons.report, AppColors.warning),
        _buildStatCard('Active Assignments', '$_pendingAssignments',
            Icons.assignment, AppColors.success),
        _buildStatCard('Active Quizzes', '${_mockData.getQuizzes().length}',
            Icons.quiz, AppColors.info),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildActionChip('Take Attendance', Icons.how_to_reg, primaryColor,
                () => Navigator.pushNamed(context, '/take-attendance')),
            _buildActionChip('Upload Marks', Icons.grade, AppColors.success,
                () => Navigator.pushNamed(context, '/upload-marks')),
            _buildActionChip(
                'Create Assignment',
                Icons.assignment_add,
                AppColors.warning,
                () => Navigator.pushNamed(context, '/create-assignment')),
            _buildActionChip(
                'Upload Material',
                Icons.upload_file,
                AppColors.info,
                () => Navigator.pushNamed(context, '/upload-material')),
            _buildActionChip('Create Quiz', Icons.quiz, AppColors.secondary,
                () => Navigator.pushNamed(context, '/create-quiz')),
            _buildActionChip('View Attendance', Icons.visibility, primaryColor,
                () => Navigator.pushNamed(context, '/attendance')),
            _buildActionChip(
                'Attendance Issues',
                Icons.report_problem,
                AppColors.error,
                () => Navigator.pushNamed(context, '/attendance-issues')),
          ],
        ),
      ],
    );
  }

  Widget _buildClassroomPulse(BuildContext context, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Classroom Pulse',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _focusMetrics
                      .map((metric) => _buildMetricChip(metric, primaryColor))
                      .toList(),
                ),
                const SizedBox(height: 16),
                ..._insights.map(
                  (insight) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildInsightTile(context, insight),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricChip(FocusMetric metric, Color primaryColor) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            metric.value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.helperText,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightTile(BuildContext context, DashboardInsight insight) {
    final color = _colorForSeverity(insight.severity);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.14),
            ),
            child: Icon(_iconForInsight(insight.iconKey), color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(insight.message),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, insight.routeName),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: color,
                  ),
                  child: Text(insight.actionLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForSeverity(String severity) {
    switch (severity) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  IconData _iconForInsight(String iconKey) {
    switch (iconKey) {
      case 'assignment':
        return Icons.assignment;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'schedule':
        return Icons.schedule;
      default:
        return Icons.auto_graph;
    }
  }

  Widget _buildActionChip(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, Color primaryColor) {
    final notifications = _mockData.getNotifications().take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                leading: Icon(_getNotificationIcon(notification.type),
                    color: primaryColor),
                title: Text(notification.title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(notification.message,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Icon(
                    notification.read ? Icons.check_circle : Icons.circle,
                    size: 16,
                    color: notification.read ? Colors.grey : AppColors.info),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'attendance':
        return Icons.how_to_reg;
      case 'assignment':
        return Icons.assignment;
      case 'quiz':
        return Icons.quiz;
      case 'holiday':
        return Icons.celebration;
      case 'schedule':
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }
}
