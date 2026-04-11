import '../utils/api_constants.dart';
import 'api_service.dart';

class LeaveService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> applyLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    return await _apiService.post(ApiConstants.applyLeave, {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
    });
  }

  Future<Map<String, dynamic>> getMyApplications() async {
    return await _apiService.get(ApiConstants.getMyApplications);
  }

  Future<Map<String, dynamic>> getAllApplications() async {
    return await _apiService.get(ApiConstants.getAllApplications);
  }

  Future<Map<String, dynamic>> reviewApplication(String applicationId, String status, String? reviewNote) async {
    return await _apiService.put('${ApiConstants.reviewApplication}/$applicationId', {
      'status': status,
      'reviewNote': reviewNote,
    });
  }
}
