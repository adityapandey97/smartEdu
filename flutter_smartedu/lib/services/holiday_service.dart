import '../utils/api_constants.dart';
import 'api_service.dart';

class HolidayService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getHolidays() async {
    return await _apiService.get(ApiConstants.getHolidays);
  }

  Future<Map<String, dynamic>> createHoliday({
    required String title,
    required DateTime date,
    String? reason,
  }) async {
    return await _apiService.post(ApiConstants.createHoliday, {
      'title': title,
      'date': date.toIso8601String(),
      'reason': reason,
    });
  }
}
