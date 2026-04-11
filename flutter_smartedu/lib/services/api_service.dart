import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import 'auth_service.dart';

class ApiService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> get(String endpoint) async {
    if (ApiConstants.useMock) {
      return _mockGet(endpoint);
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: _authService.authHeaders,
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    if (ApiConstants.useMock) {
      return _mockPost(endpoint, body);
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: _authService.authHeaders,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    if (ApiConstants.useMock) {
      return _mockPut(endpoint, body);
    }

    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: _authService.authHeaders,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Request failed'};
    }
  }

  Map<String, dynamic> _mockGet(String endpoint) {
    final normalized = endpoint.split('?').first;

    if (normalized == ApiConstants.getMaterials || normalized.startsWith('${ApiConstants.getMaterials}/')) {
      return {
        'success': true,
        'data': [
          {
            '_id': 'mat1',
            'title': 'Chapter 1 Notes',
            'type': 'notes',
            'subject': 'Mathematics',
            'fileUrl': 'https://example.com/notes1.pdf',
            'description': 'Essential concepts for chapter 1.',
            'uploadedBy': 'teacher1',
            'uploadedByName': 'Ms. Rao',
            'createdAt': DateTime.now().toIso8601String(),
          },
          {
            '_id': 'mat2',
            'title': 'Python Sample Problems',
            'type': 'pyq',
            'subject': 'Computer Science',
            'fileUrl': 'https://example.com/pyq1.pdf',
            'description': 'Previous year questions for Python.',
            'uploadedBy': 'teacher2',
            'uploadedByName': 'Mr. Kumar',
            'createdAt': DateTime.now().toIso8601String(),
          },
        ],
      };
    }

    if (normalized == ApiConstants.getQuizzes) {
      return {
        'success': true,
        'data': [
          {
            '_id': 'quiz1',
            'title': 'General Knowledge Quiz',
            'subject': 'General',
            'duration': 10,
            'questions': [
              {
                'question': 'What is the capital of France?',
                'options': ['Paris', 'London', 'Berlin', 'Rome'],
                'correctAnswer': 0,
              },
              {
                'question': '2 + 2 equals?',
                'options': ['3', '4', '5', '6'],
                'correctAnswer': 1,
              },
            ],
            'createdBy': 'teacher1',
            'createdAt': DateTime.now().toIso8601String(),
          },
        ],
      };
    }

    if (normalized.startsWith(ApiConstants.getAttendanceOverview)) {
      return {
        'success': true,
        'data': {
          'percentage': 92.5,
        },
      };
    }

    if (normalized == ApiConstants.getUnreadCount) {
      return {
        'success': true,
        'data': {
          'count': 5,
        },
      };
    }

    if (normalized == ApiConstants.getPendingAssignments) {
      return {
        'success': true,
        'data': [
          {'_id': 'ass1', 'title': 'English Essay', 'subject': 'English'},
          {'_id': 'ass2', 'title': 'Math Worksheet', 'subject': 'Mathematics'},
        ],
      };
    }

    if (normalized.startsWith(ApiConstants.getAverageMarks)) {
      return {
        'success': true,
        'data': {
          'overallAverage': 88.0,
        },
      };
    }

    if (normalized == ApiConstants.getNotifications) {
      return {
        'success': true,
        'data': [
          {
            '_id': 'notif1',
            'title': 'New assignment available',
            'message': 'Check the latest homework for Science.',
            'isRead': false,
            'createdAt': DateTime.now().toIso8601String(),
          },
        ],
      };
    }

    return {'success': false, 'message': 'Mock endpoint not implemented: $endpoint'};
  }

  Map<String, dynamic> _mockPost(String endpoint, Map<String, dynamic> body) {
    if (endpoint == ApiConstants.submitQuiz) {
      final answers = List<int>.from(body['answers'] as List<dynamic>);
      final correctAnswers = [0, 1];
      final score = answers.asMap().entries.where((entry) => entry.value == correctAnswers[entry.key]).length;
      return {
        'success': true,
        'data': {
          'result': {'score': score},
        },
      };
    }

    return {'success': true, 'data': {}};
  }

  Map<String, dynamic> _mockPut(String endpoint, Map<String, dynamic> body) {
    return {'success': true, 'data': {}};
  }
}
