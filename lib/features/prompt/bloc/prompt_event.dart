import 'package:chatbot_ai/features/prompt/bloc/prompt_state.dart';

sealed class EventPrompt {
  const EventPrompt();
}

final class EventPromptGet extends EventPrompt {
  final String? promptTitle;
  final List<String>? category;
  final StatePromptGet currentState;
  EventPromptGet({
    required this.currentState,
     this.promptTitle,
     this.category,
  });
}


final class EventUpdatePrompt extends EventPrompt {
  final String promptId;
  final String promptTitle;
  final String promptContent;
  final String promptDescription;
  final String promptCategory;
  final bool isPublic;
  EventUpdatePrompt({
    required this.promptId,
    required this.promptTitle,
    required this.promptContent,
    required this.promptDescription,
    required this.promptCategory,
    this.isPublic = true,
  });
}

final class EventDeletePrompt extends EventPrompt {
  final String promptId;
  EventDeletePrompt({
    required this.promptId,
  });
}

final class EventToggleFavorite extends EventPrompt {
  final String promptId;
  final bool isFavorite;
  EventToggleFavorite({
    required this.promptId,
    required this.isFavorite,
  });
}

final class EventCreatePrompt extends EventPrompt {
  final String title;
  final String content;
  final String description;
  final String category;
  final String language;
  final bool isPublic;
  EventCreatePrompt({
    required this.title,
    required this.content,
    required this.description,
    required this.category,
    required this.language,
    this.isPublic = false,
  });
}