class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final String? venue;
  final int? maxParticipants;
  final int registeredCount;
  final bool isRegistered;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.venue,
    this.maxParticipants,
    this.registeredCount = 0,
    this.isRegistered = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      date: DateTime.parse(json['date']),
      venue: json['venue'],
      maxParticipants: json['maxParticipants'],
      registeredCount: (json['registeredUsers'] as List?)?.length ?? 0,
      isRegistered: (json['registeredUsers'] as List?)?.contains(json['_id']) ?? false,
    );
  }
}
