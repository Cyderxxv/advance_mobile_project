import 'package:chatbot_ai/features/chat/data/chat_response_model.dart';

class ChatState {
  const ChatState();
}

class StateChatInitial extends ChatState {}

class StateChatMessageSent extends ChatState {
  bool isLoading;
  final ChatResponseModel? message;
  StateChatMessageSent({required this.message, this.isLoading = false});
}

class StateChatError extends ChatState {
  final String message;
  StateChatError({required this.message});
}

