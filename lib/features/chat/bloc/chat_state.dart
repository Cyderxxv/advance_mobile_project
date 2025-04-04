import 'package:chatbot_ai/features/chat/data/chat_model.dart';

class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}

class ChatMessageSent extends ChatState {
  final ChatModel message;
  ChatMessageSent({required this.message});
}

class ChatError extends ChatState {
  final String message;
  ChatError({required this.message});
}