import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';
import '../models/user_model.dart';

class AuthService {
  String? _token;
  User? _currentUser;

  String? get token => _token;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null;
  bool get isStudent => _currentUser?.role == 'student';
  bool get isTeacher => _currentUser?.role == 'teacher';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userData = prefs.getString('user');
    if (userData != null) {
      _currentUser = User.fromJson(jsonDecode(userData));
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    if (ApiConstants.useMock) {
      final isStudent = email == 'student@test.com' && password == 'password123';
      final isTeacher = email == 'teacher@test.com' && password == 'password123';
      if (isStudent || isTeacher) {
        _token = 'mock_token';
        _currentUser = User(
          id: isStudent ? 'student1' : 'teacher1',
          name: isStudent ? 'Demo Student' : 'Demo Teacher',
          email: email,
          role: isStudent ? 'student' : 'teacher',
          department: isStudent ? 'Computer Science' : 'Mathematics',
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(_currentUser!.toJson()));

        return {'success': true, 'user': _currentUser};
      }
      return {'success': false, 'message': 'Invalid demo credentials'};
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _token = data['token'];
        _currentUser = User.fromJson(data['user']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(data['user']));

        return {'success': true, 'user': _currentUser};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? studentId,
    String? department,
    int? semester,
    List<String>? subjects,
  }) async {
    if (ApiConstants.useMock) {
      _token = 'mock_token';
      _currentUser = User(
        id: 'mock_user',
        name: name,
        email: email,
        role: role,
        department: department ?? 'Computer Science',
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('user', jsonEncode(_currentUser!.toJson()));

      return {'success': true, 'user': _currentUser};
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'studentId': studentId,
          'department': department,
          'semester': semester,
          'subjects': subjects,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _token = data['token'];
        _currentUser = User.fromJson(data['user']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(data['user']));

        return {'success': true, 'user': _currentUser};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  Map<String, String> get authHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };
}
