class ChatInputModel {
  final String? content;
  final List<String>? files;
  final Metadata? metadata;
  final Assistant? assistant;
  final Map<String, String>? headers;

  ChatInputModel({
    required this.content,
    required this.files,
    required this.metadata,
    required this.assistant,
    this.headers,
  });

  factory ChatInputModel.fromJson(Map<String, dynamic> json) {
    return ChatInputModel(
      content: json['content'],
      files: List<String>.from(json['files']),
      metadata: Metadata.fromJson(json['metadata']),
      assistant: Assistant.fromJson(json['assistant']),
      headers: Map<String, String>.from(json['headers'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'files': files,
      'metadata': metadata?.toJson(),
      'assistant': assistant?.toJson(),
      'headers': headers,
    };
  }
}

class Metadata {
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

class Assistant {
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
