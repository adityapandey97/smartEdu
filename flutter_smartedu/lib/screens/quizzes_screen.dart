import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';
import '../utils/app_theme.dart';
import '../services/mock_data_service.dart';
import '../models/quiz_model.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  final MockDataService _mockData = MockDataService();
  List<Quiz> _quizzes = [];
  List<QuizResult> _quizResults = [];
  String _selectedSubject = 'All';

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  void _loadQuizzes() {
    setState(() {
      _quizzes = _mockData.getQuizzes();
      _quizResults = _mockData.getQuizResults();
    });
  }

  List<Quiz> get _filteredQuizzes {
    if (_selectedSubject == 'All') return _quizzes;
    return _quizzes.where((q) => q.subject == _selectedSubject).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
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
      body: Column(
        children: [
          _buildSubjectFilter(isDark),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _loadQuizzes(),
              child: _filteredQuizzes.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredQuizzes.length,
                      itemBuilder: (context, index) =>
                          _buildQuizCard(_filteredQuizzes[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilter(bool isDark) {
    final subjects = [
      'All',
      'DBMS',
      'Operating Systems',
      'Computer Networks',
      'Software Engineering'
    ];
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedSubject == subjects[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(subjects[index]),
              selected: isSelected,
              onSelected: (_) =>
                  setState(() => _selectedSubject = subjects[index]),
              backgroundColor:
                  isDark ? AppColors.surfaceDark : Colors.grey.shade200,
              selectedColor: AppColors.primary.withOpacity(0.2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuizCard(Quiz quiz) {
    final isCompleted = _quizResults.any((r) => r.quizId == quiz.id);
    final result = isCompleted
        ? _quizResults.firstWhere((r) => r.quizId == quiz.id)
        : null;
    final isUpcoming = quiz.dueDate.isAfter(DateTime.now());
    final isDueSoon = quiz.dueDate.difference(DateTime.now()).inDays <= 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showQuizDetails(quiz),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isCompleted
                              ? AppColors.success
                              : (isDueSoon
                                  ? AppColors.warning
                                  : AppColors.primary))
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.quiz,
                        color: isCompleted
                            ? AppColors.success
                            : (isDueSoon
                                ? AppColors.warning
                                : AppColors.primary)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(quiz.title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(quiz.subject,
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check,
                              size: 14, color: AppColors.success),
                          const SizedBox(width: 4),
                          Text('${result!.percentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildQuizStat(
                      Icons.help_outline, '${quiz.questions.length} Questions'),
                  const SizedBox(width: 16),
                  _buildQuizStat(Icons.timer, '${quiz.duration} mins'),
                  const Spacer(),
                  if (isUpcoming && !isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDueSoon
                            ? AppColors.warning.withOpacity(0.1)
                            : AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isDueSoon ? 'Due Soon' : 'Upcoming',
                        style: TextStyle(
                          color: isDueSoon ? AppColors.warning : AppColors.info,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(quiz.teacherName,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const Spacer(),
                  Icon(Icons.calendar_today,
                      size: 14,
                      color:
                          isDueSoon ? AppColors.warning : Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    isCompleted
                        ? 'Completed'
                        : (isUpcoming
                            ? 'Due: ${_formatDate(quiz.dueDate)}'
                            : 'Expired'),
                    style: TextStyle(
                      color:
                          isDueSoon ? AppColors.warning : Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight:
                          isDueSoon ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(value,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('No quizzes available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Check back later for new quizzes!',
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  void _showQuizDetails(Quiz quiz) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.quiz,
                          color: AppColors.primary, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(quiz.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(quiz.subject,
                                style:
                                    const TextStyle(color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        child: _buildDetailCard(Icons.help_outline, 'Questions',
                            '${quiz.questions.length}')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildDetailCard(
                            Icons.timer, 'Duration', '${quiz.duration} mins')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildDetailCard(
                            Icons.person, 'Teacher', quiz.teacherName)),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Questions',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...quiz.questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text('${index + 1}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Text(question.question,
                                      style: const TextStyle(fontSize: 15))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...question.options.asMap().entries.map((opt) {
                            final optIndex = opt.key;
                            final isCorrect =
                                optIndex == question.correctAnswer;
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 40, bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isCorrect
                                          ? AppColors.success.withOpacity(0.1)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + optIndex),
                                        style: TextStyle(
                                          color: isCorrect
                                              ? AppColors.success
                                              : Colors.grey.shade600,
                                          fontSize: 12,
                                          fontWeight: isCorrect
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    opt.value,
                                    style: TextStyle(
                                      color: isCorrect
                                          ? AppColors.success
                                          : Colors.grey.shade700,
                                      fontWeight: isCorrect
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Starting quiz...')));
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Quiz'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center),
          Text(label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Tomorrow';
    return '${date.day}/${date.month}/${date.year}';
  }
}
