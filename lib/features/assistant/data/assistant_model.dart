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
  bool isFavorite;

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
    this.isFavorite = false,
  });

  AssistantModel.fromJson(Map<String, dynamic> json)
      : isFavorite = (json['isFavorite'] as bool?) ?? false {
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
      'isFavorite': isFavorite,
    };
  }

  AssistantModel copyWith({
    String? id,
    String? assistantName,
    String? openAiAssistantId,
    String? instructions,
    String? description,
    String? openAiThreadIdPlay,
    String? createdBy,
    String? updatedBy,
    String? createdAt,
    String? updatedAt,
    bool? isFavorite,
  }) {
    return AssistantModel(
      id: id ?? this.id,
      assistantName: assistantName ?? this.assistantName,
      openAiAssistantId: openAiAssistantId ?? this.openAiAssistantId,
      instructions: instructions ?? this.instructions,
      description: description ?? this.description,
      openAiThreadIdPlay: openAiThreadIdPlay ?? this.openAiThreadIdPlay,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}