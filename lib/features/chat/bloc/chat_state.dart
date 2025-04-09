import 'package:chatbot_ai/features/chat/data/chat_response_model.dart';

class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {}

class ChatMessageSent extends ChatState {
  bool isLoading;
  final ChatResponseModel? message;
  ChatMessageSent({required this.message, this.isLoading = false});
}

class ChatError extends ChatState {
  final String message;
  ChatError({required this.message});
}

