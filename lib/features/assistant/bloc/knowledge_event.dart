import 'dart:io';

import 'package:chatbot_ai/features/assistant/bloc/knowledge_state.dart';

sealed class KnowledgeEvent {
  const KnowledgeEvent();
}

final class EventGetKnowledges extends KnowledgeEvent {
  final StateGetKnowledges currentState;
  EventGetKnowledges({
    required this.currentState,
  });
}

final class EventCreateKnowledge extends KnowledgeEvent {
  final String knowledgeName;
  final String? description;
  EventCreateKnowledge({
    required this.knowledgeName,
    this.description,
  });
}

final class EventUpdateKnowledge extends KnowledgeEvent {
  final String id;
  final String knowledgeName;
  final String? description;

  EventUpdateKnowledge({
    required this.id,
    required this.knowledgeName,
    this.description,
  });
}

final class EventDeleteKnowledge extends KnowledgeEvent {
  final String id;
  EventDeleteKnowledge({
    required this.id,
  });
}

final class EventUploadFiles extends KnowledgeEvent {
  final List<File> files;
  EventUploadFiles({
    required this.files,
  });
}