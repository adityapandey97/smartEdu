import '../utils/api_constants.dart';
import 'api_service.dart';

class MarkService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getStudentMarks(String studentId, {String? subject}) async {
    String endpoint = '${ApiConstants.getStudentMarks}/$studentId';
    if (subject != null) endpoint += '?subject=$subject';
    return await _apiService.get(endpoint);
  }

  Future<Map<String, dynamic>> uploadMarks({
    required String studentId,
    required String subject,
    required String examType,
    required double marks,
    double total = 100,
  }) async {
    return await _apiService.post(ApiConstants.uploadMarks, {
      'studentId': studentId,
      'subject': subject,
      'examType': examType,
      'marks': marks,
      'total': total,
    });
  }

  Future<Map<String, dynamic>> getAnalytics(String studentId) async {
    return await _apiService.get('${ApiConstants.getAnalytics}/$studentId');
  }

  Future<Map<String, dynamic>> getAverageMarks(String studentId) async {
    return await _apiService.get('${ApiConstants.getAverageMarks}/$studentId');
  }
}
