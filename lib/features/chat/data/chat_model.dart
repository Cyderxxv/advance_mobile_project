class ChatModel {
  final String content;
  final List<String> files;
  final Metadata metadata;
  final Assistant assistant;

  ChatModel({
    required this.content,
    required this.files,
    required this.metadata,
    required this.assistant,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      content: json['content'],
      files: List<String>.from(json['files']),
      metadata: Metadata.fromJson(json['metadata']),
      assistant: Assistant.fromJson(json['assistant']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'files': files,
      'metadata': metadata.toJson(),
      'assistant': assistant.toJson(),
    };
  }
}

class Metadata{
  final Conversation conversation;
  Metadata({required this.conversation});
  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      conversation: Conversation.fromJson(json['conversation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation': conversation.toJson(),
    };
  }
}

class Conversation {
  Conversation();
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation();
  }
  Map<String, dynamic> toJson() {
    return {};
  }
}

class Assistant{
  final String model;
  final String name;
  final String id;

  Assistant({
    required this.model,
    required this.name,
    required this.id,
  });

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      model: json['model'],
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'name': name,
      'id': id,
    };
  }
}