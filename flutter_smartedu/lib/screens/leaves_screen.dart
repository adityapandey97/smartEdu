import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../services/leave_service.dart';

class LeavesScreen extends StatefulWidget {
  const LeavesScreen({super.key});

  @override
  State<LeavesScreen> createState() => _LeavesScreenState();
}

class _LeavesScreenState extends State<LeavesScreen> {
  final LeaveService _leaveService = LeaveService();
  bool _isLoading = true;
  List<dynamic> _applications = [];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    try {
      final result = await _leaveService.getMyApplications();
      if (result['success'] && result['data'] != null) {
        setState(() {
          _applications = result['data'] as List;
        });
      }
    } catch (e) {
      debugPrint('Error loading applications: $e');
    }
    setState(() => _isLoading = false);
  }

  void _showApplyDialog() {
    final startController = TextEditingController();
    final endController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Leave'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startController,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    startController.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: endController,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    endController.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (startController.text.isEmpty ||
                  endController.text.isEmpty ||
                  reasonController.text.isEmpty) {
                return;
              }
              final result = await _leaveService.applyLeave(
                startDate: DateTime.parse(startController.text),
                endDate: DateTime.parse(endController.text),
                reason: reasonController.text,
              );
              if (mounted) {
                Navigator.pop(context);
                if (result['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Leave application submitted!'),
                        backgroundColor: AppColors.success),
                  );
                  _loadApplications();
                }
              }
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Applications'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showApplyDialog,
        icon: const Icon(Icons.add),
        label: const Text('Apply Leave'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
              ? const Center(child: Text('No leave applications'))
              : RefreshIndicator(
                  onRefresh: _loadApplications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _applications.length,
                    itemBuilder: (context, index) {
                      final app = _applications[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(app.reason ?? 'Leave Application'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                  '${DateFormat('MMM dd').format(DateTime.parse(app.startDate))} - ${DateFormat('MMM dd').format(DateTime.parse(app.endDate))}'),
                              Text('Status: ${app.status}',
                                  style: TextStyle(
                                      color: app.status == 'approved'
                                          ? AppColors.success
                                          : app.status == 'rejected'
                                              ? AppColors.error
                                              : AppColors.warning)),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: app.status == 'approved'
                                  ? AppColors.success.withOpacity(0.1)
                                  : app.status == 'rejected'
                                      ? AppColors.error.withOpacity(0.1)
                                      : AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              app.status.toString().toUpperCase(),
                              style: TextStyle(
                                color: app.status == 'approved'
                                    ? AppColors.success
                                    : app.status == 'rejected'
                                        ? AppColors.error
                                        : AppColors.warning,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
