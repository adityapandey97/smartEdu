import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_insight_model.dart';
import '../utils/theme_provider.dart';
import '../utils/app_theme.dart';
import '../services/mock_data_service.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final MockDataService _mockData = MockDataService();
  int _unreadCount = 0;
  double _attendancePercentage = 0;
  int _pendingAssignments = 0;
  double _averageMarks = 0;
  List<DashboardInsight> _insights = const [];
  List<FocusMetric> _focusMetrics = const [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    setState(() {
      _unreadCount = _mockData.getUnreadNotificationCount();
      _attendancePercentage = _mockData.getOverallAttendancePercentage();
      _pendingAssignments = _mockData.getPendingAssignments();
      _averageMarks = _mockData.getAverageMarks();
      _insights = _mockData.getStudentInsights();
      _focusMetrics = _mockData.getStudentFocusMetrics();
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
        title: const Text('SmartEdu'),
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
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
              ),
              if (_unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: AppColors.error, shape: BoxShape.circle),
                    child: Text('$_unreadCount',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
            ],
          ),
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
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'S',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${user?.name ?? 'Student'}!',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            user?.department ?? 'Computer Science',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildStatCards(context, primaryColor),
              const SizedBox(height: 24),
              if (_attendancePercentage < 75)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning,
                          color: AppColors.warning, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Attendance Warning!',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                                'Your attendance is ${_attendancePercentage.toStringAsFixed(1)}%. Maintain 75% to attend exams.',
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              _buildSmartSuggestions(context, primaryColor),
              const SizedBox(height: 24),
              _buildAcademicPulse(context, primaryColor),
              const SizedBox(height: 24),
              _buildQuickActions(context, primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCards(BuildContext context, Color primaryColor) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
            'Attendance',
            '${_attendancePercentage.toStringAsFixed(1)}%',
            Icons.how_to_reg,
            _attendancePercentage < 75 ? AppColors.warning : AppColors.success),
        _buildStatCard('Average Marks', '${_averageMarks.toStringAsFixed(1)}%',
            Icons.grade, AppColors.primary),
        _buildStatCard('Pending Tasks', '$_pendingAssignments',
            Icons.assignment, AppColors.secondary),
        _buildStatCard('Notifications', '$_unreadCount', Icons.notifications,
            AppColors.info),
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

  Widget _buildSmartSuggestions(BuildContext context, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Smart Suggestions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSuggestionItem(Icons.assignment, 'Complete DBMS Project',
                    'Due in 7 days', AppColors.warning),
                const Divider(),
                _buildSuggestionItem(Icons.book, 'Review OS Process Scheduling',
                    'Quiz on Monday', AppColors.info),
                const Divider(),
                _buildSuggestionItem(
                    Icons.calendar_today,
                    'Attend tomorrow\'s DBMS class',
                    'Build your attendance',
                    AppColors.success),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicPulse(BuildContext context, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Academic Pulse',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Live snapshot',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
        borderRadius: BorderRadius.circular(14),
        color: color.withValues(alpha: 0.1),
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
      case 'quiz':
        return Icons.quiz;
      case 'notification':
        return Icons.notifications_active;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.auto_graph;
    }
  }

  Widget _buildSuggestionItem(
      IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
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
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildActionCard('Attendance', Icons.how_to_reg, primaryColor,
                  () => Navigator.pushNamed(context, '/attendance')),
              _buildActionCard('Marks', Icons.grade, AppColors.success,
                  () => Navigator.pushNamed(context, '/marks')),
              _buildActionCard(
                  'Assignments',
                  Icons.assignment,
                  AppColors.warning,
                  () => Navigator.pushNamed(context, '/assignments')),
              _buildActionCard('Quizzes', Icons.quiz, AppColors.info,
                  () => Navigator.pushNamed(context, '/quizzes')),
              _buildActionCard('Schedule', Icons.schedule, AppColors.secondary,
                  () => Navigator.pushNamed(context, '/schedule')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
