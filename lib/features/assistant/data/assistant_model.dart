class AssistantModel {
  String? id;
  String? assistantName;
  String? openAiAssistantId;
  String? instructions;
  String? description;
  String? openAiThreadIdPlay;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;

  AssistantModel({
    this.id,
    this.assistantName,
    this.openAiAssistantId,
    this.instructions,
    this.description,
    this.openAiThreadIdPlay,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  AssistantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assistantName = json['assistantName'];
    openAiAssistantId = json['openAiAssistantId'];
    instructions = json['instructions'];
    description = json['description'];
    openAiThreadIdPlay = json['openAiThreadIdPlay'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}