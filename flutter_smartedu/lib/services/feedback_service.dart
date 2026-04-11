import '../utils/api_constants.dart';
import 'api_service.dart';

class FeedbackService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> submitFeedback({
    String? teacherId,
    required String subject,
    required int rating,
    String? comment,
  }) async {
    return await _apiService.post(ApiConstants.submitFeedback, {
      'teacherId': teacherId,
      'subject': subject,
      'rating': rating,
      'comment': comment,
    });
  }

  Future<Map<String, dynamic>> getFeedback() async {
    return await _apiService.get(ApiConstants.getFeedback);
  }

  Future<Map<String, dynamic>> getTeacherFeedback(String teacherId) async {
    return await _apiService.get('${ApiConstants.getTeacherFeedback}/$teacherId');
  }
}
