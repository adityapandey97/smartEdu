import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../services/event_service.dart';
import '../models/event_model.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventService _eventService = EventService();
  bool _isLoading = true;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    try {
      final result = await _eventService.getEvents();
      if (result['success'] && result['data'] != null) {
        setState(() {
          _events = (result['data'] as List)
              .map((e) => Event.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
              ? const Center(child: Text('No events found'))
              : RefreshIndicator(
                  onRefresh: _loadEvents,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => _showEventDetails(event),
                          borderRadius: BorderRadius.circular(12),
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
                                        color: AppColors.secondary.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.event, color: AppColors.secondary),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          Text(DateFormat('MMM dd, yyyy').format(event.date), style: const TextStyle(color: AppColors.textSecondary)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (event.description != null) ...[
                                  const SizedBox(height: 12),
                                  Text(event.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    if (event.venue != null) ...[
                                      const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(event.venue!, style: const TextStyle(fontSize: 12)),
                                      const SizedBox(width: 16),
                                    ],
                                    const Icon(Icons.people, size: 16, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${event.registeredCount}${event.maxParticipants != null ? '/${event.maxParticipants}' : ''} registered',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _showEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Chip(label: Text(DateFormat('MMM dd, yyyy').format(event.date))),
            if (event.venue != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 20),
                  const SizedBox(width: 8),
                  Text(event.venue!),
                ],
              ),
            ],
            if (event.description != null) ...[
              const SizedBox(height: 16),
              Text(event.description!),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.people, size: 20),
                const SizedBox(width: 8),
                Text('${event.registeredCount}${event.maxParticipants != null ? ' / ${event.maxParticipants}' : ''} participants'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await _eventService.registerForEvent(event.id);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['success'] ? 'Registered successfully!' : 'Registration failed'),
                        backgroundColor: result['success'] ? AppColors.success : AppColors.error,
                      ),
                    );
                    _loadEvents();
                  }
                },
                icon: const Icon(Icons.how_to_reg),
                label: const Text('Register for Event'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
