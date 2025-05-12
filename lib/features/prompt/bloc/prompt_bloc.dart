import 'dart:async';
import 'dart:ffi';
import 'package:chatbot_ai/features/prompt/bloc/prompt_event.dart';
import 'package:chatbot_ai/features/prompt/bloc/prompt_state.dart';
import 'package:chatbot_ai/features/prompt/data/prompt_model.dart';
import 'package:chatbot_ai/features/prompt/domain/prompt_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptBloc extends Bloc<EventPrompt, PromptState> {
  PromptBloc() : super(const StatePromptInitial()) {
    on<EventPromptGet>(_onEventPromptGet);
    on<EventUpdatePrompt>(_onEventUpdatePrompt);
    on<EventDeletePrompt>(_onEventDeletePrompt);
    on<EventToggleFavorite>(_onEventToggleFavorite);
    on<EventCreatePrompt>(_onEventCreatePrivatePrompt);
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
        isPublic: event.currentState.isPublic,
        isFavorite: event.currentState.isFavorite,
        // query: event.promptTitle,
        // categories: event.category,
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

  FutureOr<void> _onEventUpdatePrompt(
      EventUpdatePrompt event, Emitter<PromptState> emit) async {
      try {
        final response = await PromptRepo.instant.updatePrompt(
          promptId: event.promptId,
          title: event.promptTitle,
          content: event.promptContent,
          description: event.promptDescription,
          category: event.promptCategory,
          language: event.language,
        );
        
        emit(StatePromptUpdate(message: response.data, isSuccess: true));
      } catch (e) {
        emit(StatePromptUpdate(message: e.toString()));
      }
    }

  FutureOr<void> _onEventDeletePrompt(
      EventDeletePrompt event, Emitter<PromptState> emit) async {
      try {
        final response = await PromptRepo.instant.deletePrompt(
          promptId: event.promptId,
        );
        
        emit(StatePromptDelete(message: response.data, isSuccess: true));
      } catch (e) {
        emit(StatePromptDelete(message: e.toString()));
      }
    }

  FutureOr<void> _onEventToggleFavorite(
      EventToggleFavorite event, Emitter<PromptState> emit) async {
      try {
        final response = await PromptRepo.instant.toggleFavorite(
          promptId: event.promptId,
          isFavorite: event.isFavorite,
        );
        
        emit(StatePromptUpdate(message: response.data, isSuccess: true));
      } catch (e) {
        emit(StatePromptUpdate(message: e.toString()));
      }
    }


    FutureOr<void> _onEventCreatePrivatePrompt(
      EventCreatePrompt event, Emitter<PromptState> emit) async {
      try {
        final response = await PromptRepo.instant.createPrivatePrompt(
          title: event.title,
          content: event.content,
          description: event.description,
          category: event.category,
          language: event.language,
          isPublic: event.isPublic,
        );
        emit(StatePromptUpdate(message: response.data, isSuccess: true));
      } catch (e) {
        emit(StatePromptUpdate(message: e.toString()));
      }
    }
}