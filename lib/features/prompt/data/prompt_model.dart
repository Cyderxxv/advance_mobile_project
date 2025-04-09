class PromptGetModel {
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? category;
  final String? content;
  final String? description;
  final bool? isPublic;
  final String? language;
  final String? title;
  final String? userId;
  final String? userName;
  final bool? isFavorite;

  PromptGetModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.content,
    required this.description,
    required this.isPublic,
    required this.language,
    required this.title,
    required this.userId,
    required this.userName,
    required this.isFavorite,
  });

  factory PromptGetModel.fromJson(Map<String, dynamic> json) {
    return PromptGetModel(
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      category: json['category'],
      content: json['content'],
      description: json['description'],
      isPublic: json['isPublic'],
      language: json['language'],
      title: json['title'],
      userId: json['userId'],
      userName: json['userName'],
      isFavorite: json['isFavorite'],
    );
  }
}