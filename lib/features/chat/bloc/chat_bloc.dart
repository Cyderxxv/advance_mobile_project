import 'package:chatbot_ai/features/chat/bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/chat_repo.dart';
import '../data/chat_model.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo chatRepo;

  ChatBloc({required this.chatRepo}) : super(ChatInitial()) {
    on<EventChat>((event, emit) async {
      emit(ChatLoading());
      try {
        final metadata = {
          'conversation': {},
        };
        final assistant = {
          'model': 'gpt-4',
          'name': 'Jarvis',
          'id': '12345',
        };

        final response = await chatRepo.sendMessage(
          content: event.content,
          files: event.files,
          metadata: metadata,
          assistant: assistant,
        );
        
        final chatModel = ChatModel.fromJson(response);
        emit(ChatMessageSent(message: chatModel));
      } catch (e) {
        emit(ChatError(message: e.toString()));
      }
    });
  }
}