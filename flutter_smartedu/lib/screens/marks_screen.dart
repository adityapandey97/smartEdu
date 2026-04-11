import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_theme.dart';
import '../services/auth_service.dart';
import '../services/mark_service.dart';
import '../models/mark_model.dart';

class MarksScreen extends StatefulWidget {
  const MarksScreen({super.key});

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  final AuthService _authService = AuthService();
  final MarkService _markService = MarkService();
  bool _isLoading = true;
  List<MarkSummary> _summary = [];
  List<Mark> _marks = [];
  double _overallAverage = 0;

  @override
  void initState() {
    super.initState();
    _loadMarks();
  }

  Future<void> _loadMarks() async {
    final user = _authService.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      final result = await _markService.getStudentMarks(user.id);
      if (result['success'] && result['data'] != null) {
        final analytics = MarksAnalytics.fromJson(result['data']);
        setState(() {
          _summary = analytics.summary;
          _marks = analytics.marks;
          _overallAverage = analytics.overallAverage;
        });
      }
    } catch (e) {
      debugPrint('Error loading marks: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Marks'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMarks,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text('Overall Average', style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text(
                              '${_overallAverage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: _overallAverage >= 75 ? AppColors.success : AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_summary.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text('Subject Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barGroups: _summary.asMap().entries.map((entry) {
                              return BarChartGroupData(
                                x: entry.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: double.tryParse(entry.value.average.toString()) ?? 0,
                                    color: (entry.value.average >= 75 ? AppColors.success : AppColors.warning),
                                    width: 20,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                  ),
                                ],
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= 0 && index < _summary.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          _summary[index].subject.substring(0, 3),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: const FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Subject Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ..._summary.map((sub) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(sub.subject),
                              subtitle: Text('${sub.totalExams} exams'),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: sub.average >= 75
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.warning.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${sub.average.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: sub.average >= 75 ? AppColors.success : AppColors.warning,
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                    const SizedBox(height: 24),
                    const Text('Recent Marks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (_marks.isEmpty)
                      const Center(child: Text('No marks found'))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _marks.length,
                        itemBuilder: (context, index) {
                          final mark = _marks[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text('${mark.subject} - ${mark.examType}'),
                              subtitle: Text('${mark.marks.toInt()}/${mark.total.toInt()}'),
                              trailing: Text(
                                '${((mark.marks / mark.total) * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (mark.marks / mark.total) >= 0.75 ? AppColors.success : AppColors.warning,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
