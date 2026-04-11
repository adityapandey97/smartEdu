import '../utils/api_constants.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getNotifications() async {
    return await _apiService.get(ApiConstants.getNotifications);
  }

  Future<Map<String, dynamic>> getUnreadCount() async {
    return await _apiService.get(ApiConstants.getUnreadCount);
  }

  Future<Map<String, dynamic>> markAsRead(String notificationId) async {
    return await _apiService.put('${ApiConstants.markAsRead}/$notificationId', {});
  }

  Future<Map<String, dynamic>> markAllAsRead() async {
    return await _apiService.put(ApiConstants.markAllAsRead, {});
  }

  Future<Map<String, dynamic>> createNotification({
    String? userId,
    String? role,
    required String type,
    required String title,
    required String message,
  }) async {
    return await _apiService.post(ApiConstants.createNotification, {
      'userId': userId,
      'role': role,
      'type': type,
      'title': title,
      'message': message,
    });
  }
}
