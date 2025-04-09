import 'package:chatbot_ai/features/chat/data/chat_input_model.dart';

sealed class ChatEvent {
  const ChatEvent();
}

final class EventChat extends ChatEvent {
  final ChatInputModel content;
  EventChat({
    required this.content,
  });
}