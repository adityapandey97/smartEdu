import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../services/auth_service.dart';
import '../services/attendance_service.dart';
import '../models/attendance_model.dart';

class AttendanceIssuesScreen extends StatefulWidget {
  const AttendanceIssuesScreen({super.key});

  @override
  State<AttendanceIssuesScreen> createState() => _AttendanceIssuesScreenState();
}

class _AttendanceIssuesScreenState extends State<AttendanceIssuesScreen> {
  final AttendanceService _attendanceService = AttendanceService();
  bool _isLoading = true;
  List<AttendanceIssue> _issues = [];

  @override
  void initState() {
    super.initState();
    _loadIssues();
  }

  Future<void> _loadIssues() async {
    setState(() => _isLoading = true);
    try {
      final result = await _attendanceService.getPendingIssues();
      if (result['success'] && result['data'] != null) {
        setState(() {
          _issues = (result['data'] as List)
              .map((i) => AttendanceIssue.fromJson(i))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading issues: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _resolveIssue(String issueId, String status) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(status == 'approved' ? 'Approve Issue' : 'Reject Issue'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            labelText: 'Resolution Note',
            hintText: 'Enter a note (optional)',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  status == 'approved' ? AppColors.success : AppColors.error,
            ),
            child: Text(status == 'approved' ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final result = await _attendanceService.resolveIssue(
            issueId, status, noteController.text);
        if (result['success']) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Issue ${status == 'approved' ? 'approved' : 'rejected'} successfully'),
                backgroundColor:
                    status == 'approved' ? AppColors.success : AppColors.error,
              ),
            );
            _loadIssues();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error: $e'), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Issues'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _issues.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          size: 64, color: AppColors.success.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      const Text('No pending issues',
                          style: TextStyle(
                              fontSize: 18, color: AppColors.textSecondary)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadIssues,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _issues.length,
                    itemBuilder: (context, index) {
                      final issue = _issues[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      issue.studentName.isNotEmpty
                                          ? issue.studentName
                                          : 'Student',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text('Pending',
                                        style: TextStyle(
                                            color: AppColors.warning,
                                            fontSize: 12)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Subject: ${issue.subject}',
                                  style: const TextStyle(
                                      color: AppColors.textSecondary)),
                              Text(
                                  'Date: ${DateFormat('MMM dd, yyyy').format(issue.date)}',
                                  style: const TextStyle(
                                      color: AppColors.textSecondary)),
                              Text(
                                  'Issue: ${issue.issueType.replaceAll('_', ' ').toUpperCase()}',
                                  style: const TextStyle(
                                      color: AppColors.textSecondary)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(issue.description),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          _resolveIssue(issue.id, 'rejected'),
                                      icon: const Icon(Icons.close,
                                          color: AppColors.error),
                                      label: const Text('Reject',
                                          style: TextStyle(
                                              color: AppColors.error)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          _resolveIssue(issue.id, 'approved'),
                                      icon: const Icon(Icons.check),
                                      label: const Text('Approve'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.success),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
