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