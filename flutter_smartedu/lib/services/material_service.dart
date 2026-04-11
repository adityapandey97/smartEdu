import '../utils/api_constants.dart';
import 'api_service.dart';

class MaterialService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getMaterials({String? subject, String? type}) async {
    String endpoint = ApiConstants.getMaterials;
    List<String> params = [];
    if (subject != null) params.add('subject=$subject');
    if (type != null) params.add('type=$type');
    if (params.isNotEmpty) endpoint += '?${params.join('&')}';
    return await _apiService.get(endpoint);
  }

  Future<Map<String, dynamic>> uploadMaterial({
    required String title,
    required String type,
    required String subject,
    String? fileUrl,
    String? description,
  }) async {
    return await _apiService.post(ApiConstants.uploadMaterial, {
      'title': title,
      'type': type,
      'subject': subject,
      'fileUrl': fileUrl,
      'description': description,
    });
  }

  Future<Map<String, dynamic>> getMaterialsBySubject(String subject) async {
    return await _apiService.get('${ApiConstants.getMaterialsBySubject}/$subject');
  }
}
