import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';
import '../utils/app_theme.dart';
import '../services/mock_data_service.dart';
import '../models/attendance_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final MockDataService _mockData = MockDataService();
  List<AttendanceOverview> _attendanceList = [];
  double _overallPercentage = 0;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  void _loadAttendance() {
    setState(() {
      _attendanceList = _mockData.getAttendanceOverview();
      _overallPercentage = _mockData.getOverallAttendancePercentage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
          primaryColor,
          isDark ? AppColors.secondaryDark : AppColors.secondaryLight
        ]))),
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
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadAttendance(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverallCard(primaryColor, isDark),
              const SizedBox(height: 24),
              const Text('Subject-wise Attendance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildAttendanceList(primaryColor, isDark),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, '/report-attendance-issue'),
        icon: const Icon(Icons.report_problem),
        label: const Text('Report Issue'),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildOverallCard(Color primaryColor, bool isDark) {
    final isLowAttendance = _overallPercentage < 75;
    final cardColor = isLowAttendance ? AppColors.warning : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            isDark ? AppColors.secondaryDark : AppColors.secondaryLight
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: primaryColor.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics,
                  color: Colors.white.withOpacity(0.8), size: 32),
              const SizedBox(width: 12),
              const Text('Overall Attendance',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('${_overallPercentage.toStringAsFixed(1)}%',
                  'Percentage', cardColor),
              Container(
                  width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              _buildStatItem(
                  '${_attendanceList.fold<int>(0, (sum, a) => sum + a.totalClasses)}',
                  'Total Classes',
                  Colors.white),
              Container(
                  width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              _buildStatItem(
                  '${_attendanceList.fold<int>(0, (sum, a) => sum + a.attendedClasses)}',
                  'Attended',
                  Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          if (isLowAttendance)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.amber),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your attendance is below 75%. Please attend upcoming classes!',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.lightGreenAccent),
                  SizedBox(width: 8),
                  Text('Great! You are meeting the attendance criteria.',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style:
                TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }

  Widget _buildAttendanceList(Color primaryColor, bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _attendanceList.length,
      itemBuilder: (context, index) {
        final attendance = _attendanceList[index];
        return _buildAttendanceCard(attendance, primaryColor, isDark);
      },
    );
  }

  Widget _buildAttendanceCard(
      AttendanceOverview attendance, Color primaryColor, bool isDark) {
    final percentage = attendance.percentage;
    Color statusColor;
    String statusText;

    if (percentage >= 90) {
      statusColor = AppColors.success;
      statusText = 'Excellent';
    } else if (percentage >= 75) {
      statusColor = AppColors.info;
      statusText = 'Good';
    } else if (percentage >= 60) {
      statusColor = AppColors.warning;
      statusText = 'Warning';
    } else {
      statusColor = AppColors.error;
      statusText = 'Critical';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.book, color: primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(attendance.subject,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                                '${attendance.attendedClasses}/${attendance.totalClasses} classes attended',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(statusText,
                      style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      color: statusColor,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
