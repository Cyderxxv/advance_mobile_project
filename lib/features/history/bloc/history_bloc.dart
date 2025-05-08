import 'dart:async';
import 'package:chatbot_ai/features/history/bloc/history_event.dart';
import 'package:chatbot_ai/features/history/bloc/history_state.dart';
import 'package:chatbot_ai/features/history/data/history_response_model.dart';
import 'package:chatbot_ai/features/history/domain/history_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryBloc extends Bloc<EventHistory, HistoryState> {
  HistoryBloc() : super(const StateHistoryInitial()) {
    on<EventGetConversations>(_onEventGetConversations);
    on<EventGetConversationsHistory>(_onEventGetConversationsHistory);
  }

  FutureOr<void> _onEventGetConversations(
      EventGetConversations event, Emitter<HistoryState> emit) async {
    try {
      emit(StateGetConversations(isLoading: true));
      final response = await HistoryRepo.instant.getConversations(
        // cursor: event.cursor,
        // limit: event.limit,
        // assistantId: event.assistantId,
        assistantModel: event.assistantModel,
      );
      final data = (response.data['items'] as List?) ?? [];
      emit(StateGetConversations(
        items: data,
        cursor: response.data['cursor'],
        hasMore: response.data['has_more'] ?? false,
        limit: event.limit ?? 20,
        isLoading: false,
        isSuccess: true,
      ));
    } catch (e) {
      emit(StateGetConversations(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onEventGetConversationsHistory(
      EventGetConversationsHistory event, Emitter<HistoryState> emit) async {
    try {
      emit(StateGetConversationsHistory(isLoading: true));
      final response = await HistoryRepo.instant.getConversationsHistory(
        conversationId: event.conversationId,
        // cursor: event.cursor,
        // limit: event.limit,
        // assistantId: event.assistantId,
        assistantModel: event.assistantModel,
      );
      List<ConversationMessage> data = (response.data['items'] as List?)?.map((data) => ConversationMessage.fromJson(data)).toList() ?? [];
      emit(StateGetConversationsHistory(
        isLoading: false,
        isSuccess: true,
        messages: data,
      ));
    } catch (e) {
      print(e.toString());
      emit(StateGetConversationsHistory(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
      ));
    }
  }
}