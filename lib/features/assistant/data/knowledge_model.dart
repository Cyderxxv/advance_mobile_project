class KnowledgeModel {
  String? id;
  String? knowledgeName;
  String? openAiAssistantId;
  String? instructions;
  String? description;
  String? openAiThreadIdPlay;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;

  KnowledgeModel({
    this.id,
    this.knowledgeName,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  KnowledgeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    knowledgeName = json['knowledgeName'];
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
      'knowledgeName': knowledgeName,
      'description': description,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  KnowledgeModel copyWith({
    String? id,
    String? knowledgeName,
    String? description,
    String? createdBy,
    String? updatedBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return KnowledgeModel(
      id: id ?? this.id,
      knowledgeName: knowledgeName ?? this.knowledgeName,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}