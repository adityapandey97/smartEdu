class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? studentId;
  final String? department;
  final int? semester;
  final List<String>? subjects;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.studentId,
    this.department,
    this.semester,
    this.subjects,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      studentId: json['studentId'],
      department: json['department'],
      semester: json['semester'],
      subjects: json['subjects'] != null ? List<String>.from(json['subjects']) : null,
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'studentId': studentId,
      'department': department,
      'semester': semester,
      'subjects': subjects,
      'profileImage': profileImage,
    };
  }
}
