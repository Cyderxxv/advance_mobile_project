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