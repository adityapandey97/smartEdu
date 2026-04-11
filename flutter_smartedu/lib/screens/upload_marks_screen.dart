





import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/mark_service.dart';

class UploadMarksScreen extends StatefulWidget {
  const UploadMarksScreen({super.key});

  @override
  State<UploadMarksScreen> createState() => _UploadMarksScreenState();
}

class _UploadMarksScreenState extends State<UploadMarksScreen> {
  final MarkService _markService = MarkService();
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _marksController = TextEditingController();
  final _totalController = TextEditingController(text: '100');
  String? _selectedSubject;
  String? _selectedExamType;
  bool _isLoading = false;

  @override
  void dispose() {
    _studentIdController.dispose();
    _marksController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  Future<void> _uploadMarks() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubject == null || _selectedExamType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _markService.uploadMarks(
        studentId: _studentIdController.text,
        subject: _selectedSubject!,
        examType: _selectedExamType!,
        marks: double.parse(_marksController.text),
        total: double.parse(_totalController.text),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['success'] ? 'Marks uploaded!' : 'Failed to upload'),
            backgroundColor: result['success'] ? AppColors.success : AppColors.error,
          ),
        );
        if (result['success']) {
          _studentIdController.clear();
          _marksController.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Marks'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter student ID';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  prefixIcon: Icon(Icons.book),
                ),
                items: const [
                  DropdownMenuItem(value: 'DBMS', child: Text('DBMS')),
                  DropdownMenuItem(value: 'Operating Systems', child: Text('Operating Systems')),
                  DropdownMenuItem(value: 'Computer Networks', child: Text('Computer Networks')),
                ],
                onChanged: (value) => setState(() => _selectedSubject = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedExamType,
                decoration: const InputDecoration(
                  labelText: 'Exam Type',
                  prefixIcon: Icon(Icons.grade),
                ),
                items: const [
                  DropdownMenuItem(value: 'Mid Term', child: Text('Mid Term')),
                  DropdownMenuItem(value: 'Quiz 1', child: Text('Quiz 1')),
                  DropdownMenuItem(value: 'Quiz 2', child: Text('Quiz 2')),
                  DropdownMenuItem(value: 'Final', child: Text('Final')),
                ],
                onChanged: (value) => setState(() => _selectedExamType = value),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _marksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Marks',
                        prefixIcon: Icon(Icons.looks_one),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter marks';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _totalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total',
                        prefixIcon: Icon(Icons.looks_two),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter total';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadMarks,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Upload Marks'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
