import 'dart:async';
import 'package:chatbot_ai/features/chat/bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat/bloc/chat_state.dart';
import 'package:chatbot_ai/features/chat/data/chat_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/chat_repo.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {

  ChatBloc() : super(StateChatInitial()) {
    on<EventChat>(_onEventChat);
  }
  FutureOr<void> _onEventChat(
      EventChat event, Emitter<ChatState> emit) async {
      try {
        emit(StateChatMessageSent(message: null, isLoading: true));
        final metadata = {
          'conversation': {},
        };
        final assistant = {
          'model': 'knowledge-base',
          'name': 'votutrinh2002''s Default Team Assistant',
          'id': '29178123-34d4-4e52-94fb-8e580face2d5',
        };

        final response = await ChatRepo.instant.sendMessage(
          content: event.content.content ?? '',
          files: event.content.files?? [],
          metadata: metadata,
          assistant: assistant,
        );
        
        final chatInputModel = ChatResponseModel.fromJson(response.data);
        emit(StateChatMessageSent(message: chatInputModel));
      } catch (e) {
        emit(StateChatError(message: e.toString()));
      }
    }
  }