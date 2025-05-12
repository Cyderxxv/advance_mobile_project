import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';

sealed class AssistantEvent {
  const AssistantEvent();
}

final class EventGetAssistants extends AssistantEvent {
  final StateGetAssistants currentState;
  EventGetAssistants({
    required this.currentState,
  });
}

final class EventCreateAssistant extends AssistantEvent {
  final String assistantName;
  final String instructions;
  final String description;
  EventCreateAssistant({
    required this.assistantName,
    required this.instructions,
    required this.description,
  });
}

final class EventFavoriteAssistant extends AssistantEvent {
  final String assistantId;
  EventFavoriteAssistant({
    required this.assistantId,
  });
}

final class EventUpdateAssistant extends AssistantEvent {
  final String assistantId;
  final String? assistantName;
  final String? instructions;
  final String? description;

  EventUpdateAssistant({
    required this.assistantId,
    this.assistantName,
    this.instructions,
    this.description,
  });
}

final class EventDeleteAssistant extends AssistantEvent {
  final String assistantId;
  EventDeleteAssistant({
    required this.assistantId,
  });
}

final class EventGetAssistantDetail extends AssistantEvent {
  final String assistantId;
  EventGetAssistantDetail({
    required this.assistantId,
  });
}

final class EventImportKnowledgeToAssistant extends AssistantEvent {
  final String assistantId;
  final String knowledgeId;
  EventImportKnowledgeToAssistant({
    required this.assistantId,
    required this.knowledgeId,
  });
}

final class EventRemoveKnowledgeFromAssistant extends AssistantEvent {
  final String assistantId;
  final String knowledgeId;
  EventRemoveKnowledgeFromAssistant({
    required this.assistantId,
    required this.knowledgeId,
  });
}

final class EventGetAssistantKnowledge extends AssistantEvent {
  final String assistantId;
  final StateGetAssistantKnowledge currentState;
  EventGetAssistantKnowledge({
    required this.assistantId,
    required this.currentState,
  });
}

final class EventAskAssistant extends AssistantEvent {
  final String assistantId;
  final String message;
  final String additionalInstruction;
  final String openAiThreadId;
  EventAskAssistant({
    required this.assistantId,
    required this.message,
    required this.additionalInstruction,
    required this.openAiThreadId,
  });
}