import '../utils/api_constants.dart';
import 'api_service.dart';

class EventService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getEvents() async {
    return await _apiService.get(ApiConstants.getEvents);
  }

  Future<Map<String, dynamic>> createEvent({
    required String title,
    String? description,
    required DateTime date,
    String? venue,
    int? maxParticipants,
  }) async {
    return await _apiService.post(ApiConstants.createEvent, {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'venue': venue,
      'maxParticipants': maxParticipants,
    });
  }

  Future<Map<String, dynamic>> registerForEvent(String eventId) async {
    return await _apiService.post('${ApiConstants.registerForEvent}/$eventId', {});
  }

  Future<Map<String, dynamic>> getMyEvents() async {
    return await _apiService.get(ApiConstants.getMyEvents);
  }
}
