import '../utils/api_constants.dart';
import 'api_service.dart';

class ScheduleService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getSchedule({int? dayOfWeek}) async {
    String endpoint = ApiConstants.getSchedule;
    if (dayOfWeek != null) endpoint += '?dayOfWeek=$dayOfWeek';
    return await _apiService.get(endpoint);
  }

  Future<Map<String, dynamic>> createSchedule({
    required int dayOfWeek,
    required int period,
    required String subject,
    String? teacherId,
    required String teacherName,
    required String room,
  }) async {
    return await _apiService.post(ApiConstants.createSchedule, {
      'dayOfWeek': dayOfWeek,
      'period': period,
      'subject': subject,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'room': room,
    });
  }

  Future<Map<String, dynamic>> setSubstitute(String scheduleId, String substituteTeacher) async {
    return await _apiService.post(ApiConstants.setSubstitute, {
      'scheduleId': scheduleId,
      'substituteTeacher': substituteTeacher,
    });
  }
}
