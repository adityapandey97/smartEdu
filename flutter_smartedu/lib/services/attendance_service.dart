import '../utils/api_constants.dart';
import 'api_service.dart';

class AttendanceService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getAttendanceOverview(String studentId) async {
    return await _apiService.get('${ApiConstants.getAttendanceOverview}/$studentId');
  }

  Future<Map<String, dynamic>> getStudentAttendance(String studentId, {String? subject}) async {
    String endpoint = '${ApiConstants.getStudentAttendance}/$studentId';
    if (subject != null) endpoint += '?subject=$subject';
    return await _apiService.get(endpoint);
  }

  Future<Map<String, dynamic>> reportIssue({
    required String studentId,
    required String subject,
    required DateTime date,
    required String issueType,
    required String description,
    String? proof,
  }) async {
    return await _apiService.post(ApiConstants.reportIssue, {
      'studentId': studentId,
      'subject': subject,
      'date': date.toIso8601String(),
      'issueType': issueType,
      'description': description,
      'proof': proof,
    });
  }

  Future<Map<String, dynamic>> getPendingIssues() async {
    return await _apiService.get(ApiConstants.getPendingIssues);
  }

  Future<Map<String, dynamic>> resolveIssue(String issueId, String status, String? resolutionNote) async {
    return await _apiService.put('${ApiConstants.resolveIssue}/$issueId', {
      'status': status,
      'resolutionNote': resolutionNote,
    });
  }

  Future<Map<String, dynamic>> getMyIssues() async {
    return await _apiService.get(ApiConstants.getMyIssues);
  }

  Future<Map<String, dynamic>> markAttendance({
    required String studentId,
    required String subject,
    required DateTime date,
    required String status,
  }) async {
    return await _apiService.post(ApiConstants.markAttendance, {
      'studentId': studentId,
      'subject': subject,
      'date': date.toIso8601String(),
      'status': status,
    });
  }
}
