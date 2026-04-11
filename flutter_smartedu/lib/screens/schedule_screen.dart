import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/schedule_service.dart';
import '../models/schedule_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScheduleService _scheduleService = ScheduleService();
  bool _isLoading = true;
  int _selectedDay = DateTime.now().weekday;
  List<Schedule> _schedule = [];

  final List<String> _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    try {
      final result = await _scheduleService.getSchedule(dayOfWeek: _selectedDay);
      if (result['success'] && result['data'] != null) {
        setState(() {
          _schedule = (result['data'] as List)
              .map((s) => Schedule.fromJson(s))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading schedule: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture Schedule'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(7, (index) {
                  final day = index + 1;
                  final isSelected = _selectedDay == day;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedDay = day);
                        _loadSchedule();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.divider,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _dayNames[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _schedule.isEmpty
                    ? const Center(child: Text('No classes scheduled'))
                    : RefreshIndicator(
                        onRefresh: _loadSchedule,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _schedule.length,
                          itemBuilder: (context, index) {
                            final slot = _schedule[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: slot.isSubstitute ? AppColors.warning : AppColors.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Period ${slot.period}',
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            slot.subject,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.person, size: 14, color: AppColors.textSecondary),
                                              const SizedBox(width: 4),
                                              Text(
                                                slot.isSubstitute
                                                    ? '${slot.substituteTeacher} (Substitute)'
                                                    : slot.teacherName,
                                                style: TextStyle(
                                                  color: slot.isSubstitute ? AppColors.warning : AppColors.textSecondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                                              const SizedBox(width: 4),
                                              Text(slot.room, style: const TextStyle(fontSize: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (slot.isSubstitute)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.warning.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'Substitute',
                                          style: TextStyle(color: AppColors.warning, fontSize: 10),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
