import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../services/holiday_service.dart';
import '../models/holiday_model.dart';

class HolidaysScreen extends StatefulWidget {
  const HolidaysScreen({super.key});

  @override
  State<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  final HolidayService _holidayService = HolidayService();
  bool _isLoading = true;
  List<Holiday> _holidays = [];

  @override
  void initState() {
    super.initState();
    _loadHolidays();
  }

  Future<void> _loadHolidays() async {
    setState(() => _isLoading = true);
    try {
      final result = await _holidayService.getHolidays();
      if (result['success'] && result['data'] != null) {
        setState(() {
          _holidays = (result['data'] as List)
              .map((h) => Holiday.fromJson(h))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading holidays: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holidays'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _holidays.isEmpty
              ? const Center(child: Text('No holidays found'))
              : RefreshIndicator(
                  onRefresh: _loadHolidays,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _holidays.length,
                    itemBuilder: (context, index) {
                      final holiday = _holidays[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.beach_access, color: AppColors.success),
                          ),
                          title: Text(holiday.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(DateFormat('MMMM dd, yyyy').format(holiday.date)),
                              if (holiday.reason != null) Text(holiday.reason!),
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
