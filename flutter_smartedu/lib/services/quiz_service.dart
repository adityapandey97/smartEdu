import '../utils/api_constants.dart';
import 'api_service.dart';

class QuizService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getQuizzes({String? subject}) async {
    String endpoint = ApiConstants.getQuizzes;
    if (subject != null) endpoint += '?subject=$subject';
    return await _apiService.get(endpoint);
  }

  Future<Map<String, dynamic>> getQuiz(String quizId) async {
    return await _apiService.get('${ApiConstants.getQuiz}/$quizId');
  }

  Future<Map<String, dynamic>> createQuiz({
    required String title,
    required String subject,
    required int duration,
    required List<Map<String, dynamic>> questions,
  }) async {
    return await _apiService.post(ApiConstants.createQuiz, {
      'title': title,
      'subject': subject,
      'duration': duration,
      'questions': questions,
    });
  }

  Future<Map<String, dynamic>> submitQuiz(String quizId, List<int> answers) async {
    return await _apiService.post(ApiConstants.submitQuiz, {
      'quizId': quizId,
      'answers': answers,
    });
  }

  Future<Map<String, dynamic>> getMyResults() async {
    return await _apiService.get(ApiConstants.getMyResults);
  }
}
