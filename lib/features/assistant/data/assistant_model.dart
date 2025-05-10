import 'package:chatbot_ai/features/chat/data/chat_input_model.dart';

class AssistantModel {
  final String id;
  final String assistantName;
  final String openAiAssistantId;
  final String instructions;
  final String description;
  final String openAiThreadIdPlay;
  final String createdBy;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssistantModel({
    required this.id,
    required this.assistantName,
    required this.openAiAssistantId,
    required this.instructions,
    required this.description,
    required this.openAiThreadIdPlay,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssistantModel.fromJson(Map<String, dynamic> json) {
    return AssistantModel(
      id: json['id'] as String,
      assistantName: json['assistantName'] as String,
      openAiAssistantId: json['openAiAssistantId'] as String,
      instructions: json['instructions'] as String,
      description: json['description'] as String,
      openAiThreadIdPlay: json['openAiThreadIdPlay'] as String,
      createdBy: json['createdBy'] as String,
      updatedBy: json['updatedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assistantName': assistantName,
      'openAiAssistantId': openAiAssistantId,
      'instructions': instructions,
      'description': description,
      'openAiThreadIdPlay': openAiThreadIdPlay,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}