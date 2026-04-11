import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/feedback_service.dart';
import '../services/auth_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final AuthService _authService = AuthService();
  final FeedbackService _feedbackService = FeedbackService();
  int _rating = 0;
  String? _selectedSubject;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_rating == 0 || _selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide rating and select subject')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await _feedbackService.submitFeedback(
        subject: _selectedSubject!,
        rating: _rating,
        comment: _commentController.text.isNotEmpty ? _commentController.text : null,
      );

      if (mounted) {
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback submitted!'), backgroundColor: AppColors.success),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final subjects = user?.subjects ?? ['DBMS', 'Operating Systems', 'Computer Networks'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rate Your Lecture', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return GestureDetector(
                          onTap: () => setState(() => _rating = starIndex),
                          child: Icon(
                            starIndex <= _rating ? Icons.star : Icons.star_border,
                            size: 48,
                            color: AppColors.warning,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        _rating == 0
                            ? 'Tap to rate'
                            : _rating == 1
                                ? 'Poor'
                                : _rating == 2
                                    ? 'Fair'
                                    : _rating == 3
                                        ? 'Good'
                                        : _rating == 4
                                            ? 'Very Good'
                                            : 'Excellent',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Select Subject', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedSubject,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.book),
              ),
              items: subjects.map((subject) {
                return DropdownMenuItem(value: subject, child: Text(subject));
              }).toList(),
              onChanged: (value) => setState(() => _selectedSubject = value),
              hint: const Text('Choose subject'),
            ),
            const SizedBox(height: 24),
            const Text('Additional Comments', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Share your thoughts (optional)...',
                prefixIcon: Padding(padding: EdgeInsets.only(bottom: 60)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
