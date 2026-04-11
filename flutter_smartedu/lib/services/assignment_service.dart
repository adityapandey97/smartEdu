import '../utils/api_constants.dart';
import 'api_service.dart';

class AssignmentService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getAssignments({String? subject}) async {
    String endpoint = ApiConstants.getAssignments;
    if (subject != null) endpoint += '?subject=$subject';
    return await _apiService.get(endpoint);
  }

  Future<Map<String, dynamic>> createAssignment({
    required String title,
    String? description,
    required String subject,
    required DateTime deadline,
  }) async {
    return await _apiService.post(ApiConstants.createAssignment, {
      'title': title,
      'description': description,
      'subject': subject,
      'deadline': deadline.toIso8601String(),
    });
  }

  Future<Map<String, dynamic>> submitAssignment({
    required String assignmentId,
    String? content,
    String? fileUrl,
  }) async {
    return await _apiService.post(ApiConstants.submitAssignment, {
      'assignmentId': assignmentId,
      'content': content,
      'fileUrl': fileUrl,
    });
  }

  Future<Map<String, dynamic>> getMySubmissions() async {
    return await _apiService.get(ApiConstants.getMySubmissions);
  }

  Future<Map<String, dynamic>> getPendingAssignments() async {
    return await _apiService.get(ApiConstants.getPendingAssignments);
  }

  Future<Map<String, dynamic>> getSubmissions(String assignmentId) async {
    return await _apiService.get('${ApiConstants.getSubmissions}/$assignmentId');
  }
}
