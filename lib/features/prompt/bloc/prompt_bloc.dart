import 'dart:async';
import 'package:chatbot_ai/features/prompt/bloc/prompt_event.dart';
import 'package:chatbot_ai/features/prompt/bloc/prompt_state.dart';
import 'package:chatbot_ai/features/prompt/data/prompt_model.dart';
import 'package:chatbot_ai/features/prompt/domain/prompt_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  PromptBloc() : super(const StatePromptInitial()) {
    on<EventPromptGet>(_onEventPromptGet);
  }

  FutureOr<void> _onEventPromptGet(
      EventPromptGet event, Emitter<PromptState> emit) async {
    try {
      emit(event.currentState.copyWith(isLoading: true));
      if(event.currentState.hasNext == false) {
        emit(event.currentState.copyWith(isLoading: false));
        return;
      }
      final response = await PromptRepo.instant.getPrompt(
        limit: event.currentState.limit,
        offset: event.currentState.offset,
        query: event.promptTitle,
        categories: event.category,
      );
      List<PromptGetModel> data = (response.data['items'] as List?)?.map((data) => PromptGetModel.fromJson(data)).toList() ?? [];
        emit(event.currentState.copyWith(
        isLoading: false,
        data: [...event.currentState.data, ...data],
        total: response.data['total'] ?? 0,
        hasNext: response.data['hasNext'] ?? false,
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