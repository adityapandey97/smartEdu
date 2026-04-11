class Material {
  final String id;
  final String title;
  final String type;
  final String subject;
  final String? fileUrl;
  final String? description;
  final String uploadedBy;
  final String uploadedByName;
  final DateTime createdAt;

  Material({
    required this.id,
    required this.title,
    required this.type,
    required this.subject,
    this.fileUrl,
    this.description,
    required this.uploadedBy,
    this.uploadedByName = '',
    required this.createdAt,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      subject: json['subject'] ?? '',
      fileUrl: json['fileUrl'],
      description: json['description'],
      uploadedBy: json['uploadedBy'] is String ? json['uploadedBy'] : json['uploadedBy']['_id'] ?? '',
      uploadedByName: json['uploadedBy'] is Map ? json['uploadedBy']['name'] ?? '' : '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
