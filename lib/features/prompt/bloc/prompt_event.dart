import 'package:chatbot_ai/features/prompt/bloc/prompt_state.dart';

sealed class PromptEvent {
  const PromptEvent();
}

final class EventPromptGet extends PromptEvent {
  final String promptTitle;
  final List<String> category;
  final StatePromptGet currentState;
  EventPromptGet({
    required this.currentState,
    required this.promptTitle,
    required this.category,
  });
}