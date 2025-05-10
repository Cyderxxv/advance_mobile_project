import 'dart:async';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';
import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';
import 'package:chatbot_ai/features/assistant/domain/assistant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  AssistantBloc() : super(const StateAssistantInitial()) {
    on<EventGetAssistants>(_onEventGetAssistants);
  }

  FutureOr<void> _onEventGetAssistants(
      EventGetAssistants event, Emitter<AssistantState> emit) async {
    try {
      emit(event.currentState.copyWith(isLoading: true));
      if(event.currentState.hasNext == false) {
        emit(event.currentState.copyWith(isLoading: false));
        return;
      }
      final response = await AssistantRepo.instant.getAssistants(
        limit: event.currentState.limit,
        offset: event.currentState.offset,
        // query: event.assistantTitle,
        // categories: event.category,
      );
      List<AssistantModel> data = (response.data['data'] as List?)?.map((data) => AssistantModel.fromJson(data)).toList() ?? [];
        emit(event.currentState.copyWith(
        isLoading: false,
        data: [...event.currentState.data, ...data],
        total: response.data['meta']['total'] ?? 0,
        hasNext: response.data['meta']['hasNext'] ?? false,
        offset: event.currentState.offset + event.currentState.limit,
        limit: event.currentState.limit,
        ));
    } catch(e) {
      emit(event.currentState.copyWith(
        isLoading: false,
        data: [],
      ));
    }
  }
}