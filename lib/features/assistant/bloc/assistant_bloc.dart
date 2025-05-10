import 'dart:async';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';
import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';
import 'package:chatbot_ai/features/assistant/domain/assistant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  AssistantBloc() : super(const StateAssistantInitial()) {
    print('AssistantBloc initialized with event handlers');
    on<EventGetAssistants>(_onEventGetAssistants);
    on<EventCreateAssistant>(_onEventCreateAssistant);
    on<EventFavoriteAssistant>(_onEventFavoriteAssistant);
    on<EventUpdateAssistant>(_onEventUpdateAssistant);
    on<EventDeleteAssistant>(_onEventDeleteAssistant);
  }

  FutureOr<void> _onEventGetAssistants(
      EventGetAssistants event, Emitter<AssistantState> emit) async {
    try {
      emit(event.currentState.copyWith(isLoading: true));
      if (event.currentState.hasNext == false) {
        emit(event.currentState.copyWith(isLoading: false));
        return;
      }
      final response = await AssistantRepo.instant.getAssistants(
        limit: event.currentState.limit,
        offset: event.currentState.offset,
      );
      if (response.statusCode == 200) {
        List<AssistantModel> newData = (response.data['data'] as List?)
                ?.map((data) => AssistantModel.fromJson(data))
                .toList() ??
            [];

        // Deduplicate data based on unique identifiers (e.g., id)
        final updatedData = {
          ...event.currentState.data.map((e) => e.id).toSet(),
          ...newData.map((e) => e.id).toSet()
        }.map((id) =>
            newData.firstWhere((assistant) => assistant.id == id, orElse: () => event.currentState.data.firstWhere((assistant) => assistant.id == id)));

        final meta = response.data['meta'] ?? {};
        emit(event.currentState.copyWith(
          isLoading: false,
          data: updatedData.toList(),
          total: meta['total'] ?? 0,
          hasNext: meta['hasNext'] ?? false,
          offset: event.currentState.offset + event.currentState.limit,
          limit: event.currentState.limit,
        ));
      } else {
        emit(event.currentState.copyWith(
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(event.currentState.copyWith(
        isLoading: false,
        data: [],
      ));
    }
  }

  FutureOr<void> _onEventCreateAssistant(
      EventCreateAssistant event, Emitter<AssistantState> emit) async {
    try {
      final response = await AssistantRepo.instant.createAssistants(
        assistantName: event.assistantName,
        instructions: event.instructions,
        description: event.description,
      );
      if (response.statusCode == 201) {
        emit(const StateCreateAssistant(
          message: 'Create Assistant Success',
          isSuccess: true,
        ));
      } else {
        emit(const StateCreateAssistant(
          message: 'Create Assistant Failed',
          isSuccess: false,
        ));
      }
    } catch (e) {
      emit(const StateCreateAssistant(isSuccess: false));
    }
  }

  FutureOr<void> _onEventFavoriteAssistant(
      EventFavoriteAssistant event, Emitter<AssistantState> emit) async {
    final currentState = state as StateGetAssistants;
    final updatedData = currentState.data.map((assistant) {
      if (assistant.id == event.assistantId) {
        return assistant.copyWith(isFavorite: !assistant.isFavorite);
      }
      return assistant;
    }).toList();

    emit(currentState.copyWith(data: updatedData));

    try {
      final response = await AssistantRepo.instant.favoriteAssistant(
        assistantId: event.assistantId,
      );

      if (response.statusCode != 200) {
        // Revert the change if the API call fails
        final revertedData = currentState.data.map((assistant) {
          if (assistant.id == event.assistantId) {
            return assistant.copyWith(isFavorite: !assistant.isFavorite);
          }
          return assistant;
        }).toList();

        emit(currentState.copyWith(data: revertedData));
      }
    } catch (e) {
      // Revert the change in case of an error
      final revertedData = currentState.data.map((assistant) {
        if (assistant.id == event.assistantId) {
          return assistant.copyWith(isFavorite: !assistant.isFavorite);
        }
        return assistant;
      }).toList();

      emit(currentState.copyWith(data: revertedData));
    }
  }

  FutureOr<void> _onEventUpdateAssistant(
      EventUpdateAssistant event, Emitter<AssistantState> emit) async {
    try {
      final response = await AssistantRepo.instant.updateAssistant(
        assistantId: event.assistantId,
        assistantName: event.assistantName,
        instructions: event.instructions,
        description: event.description,
      );
      if (response.statusCode == 200) {
        final updatedAssistant = AssistantModel.fromJson(response.data);
        if (state is StateGetAssistants) {
          final currentState = state as StateGetAssistants;
          final updatedData = currentState.data.map((assistant) {
            return assistant.id == updatedAssistant.id ? updatedAssistant : assistant;
          }).toList();

          print('Updated assistant: ${updatedAssistant.assistantName}'); // Debug log
          emit(currentState.copyWith(
            data: updatedData,
            isLoading: false,
          ));
        } else {
          emit(const StateCreateAssistant(
            message: 'Update Assistant Success',
            isSuccess: true,
          ));
        }
      } else {
        print('Update failed with status code: ${response.statusCode}'); // Debug log
        emit(const StateCreateAssistant(
          message: 'Update Assistant Failed',
          isSuccess: false,
        ));
      }
    } catch (e) {
      emit(const StateCreateAssistant(isSuccess: false));
    }
  }

  FutureOr<void> _onEventDeleteAssistant(
      EventDeleteAssistant event, Emitter<AssistantState> emit) async {
    print('EventDeleteAssistant received for assistantId: ${event.assistantId}');
    try {
      final response = await AssistantRepo.instant.deleteAssistant(assistantId: event.assistantId);
      if (response.statusCode == 200) {
        if (state is StateGetAssistants) {
          final currentState = state as StateGetAssistants;
          final updatedData = currentState.data.where((assistant) => assistant.id != event.assistantId).toList();
          emit(currentState.copyWith(data: updatedData));
          print('Updated state emitted with ${updatedData.length} assistants');
        }
      } else {
        emit(state);
      }
    } catch (e) {
      emit(state);
    }
  }
}