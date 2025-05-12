import 'dart:async';
import 'package:chatbot_ai/features/assistant/bloc/assistant_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/assistant_state.dart';
import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';
import 'package:chatbot_ai/features/assistant/data/knowledge_model.dart';
import 'package:chatbot_ai/features/assistant/domain/assistant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  AssistantBloc() : super(const StateAssistantInitial()) {
    on<EventGetAssistants>(_onEventGetAssistants);
    on<EventGetAssistantDetail>(_onEventGetAssistantDetail);
    on<EventCreateAssistant>(_onEventCreateAssistant);
    on<EventFavoriteAssistant>(_onEventFavoriteAssistant);
    on<EventUpdateAssistant>(_onEventUpdateAssistant);
    on<EventDeleteAssistant>(_onEventDeleteAssistant);
    on<EventImportKnowledgeToAssistant>(_onEventImportKnowledgeToAssistant);
    on<EventRemoveKnowledgeFromAssistant>(_onEventRemoveKnowledgeFromAssistant);
    on<EventGetAssistantKnowledge> (_onEventGetAssistantKnowledge);
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

  FutureOr<void> _onEventGetAssistantDetail(
      EventGetAssistantDetail event, Emitter<AssistantState> emit) async {
    try {
      final response = await AssistantRepo.instant.getAssistantDetail(
        assistantId: event.assistantId,
      );
      if (response.statusCode == 200) {
        AssistantModel assistant =
            AssistantModel.fromJson(response.data);
        emit(StateGetAssistantDetail(assistant: assistant,
            message: 'Get Assistant Detail Success',
            isSuccess: true));
      } else {
        emit(const StateGetAssistantDetail(assistant: null,
            message: 'Get Assistant Detail Failed',
            isSuccess: false));
      }
    } catch (e) {
      emit(const StateGetAssistantDetail(assistant: null,
          message: 'Get Assistant Detail Failed',
          isSuccess: false));
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
    try {
      final response = await AssistantRepo.instant.favoriteAssistant(
        assistantId: event.assistantId,
      );

      if (response.statusCode == 201) {
        
        emit(const StateFavoriteAssistant(isSuccess: true));
      } else {
        emit(const StateFavoriteAssistant(isSuccess: false));
      }
    } catch (e) {
      emit(const StateFavoriteAssistant(isSuccess: false));
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
        AssistantModel updatedAssistant =
            AssistantModel.fromJson(response.data);
        emit(StateUpdateAssistant(
          assistant: updatedAssistant,
          message: 'Update Assistant Success',
          isSuccess: true,
        ));
      } else {
        emit(const StateUpdateAssistant(
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
    try {
      final response = await AssistantRepo.instant.deleteAssistant(assistantId: event.assistantId);
      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(StateDeleteAssistant(isSuccess: true, assistantantId: event.assistantId));
      } else {
        emit(const StateDeleteAssistant(isSuccess: false));
      }
    } catch (e) {
      emit(const StateDeleteAssistant(isSuccess: false));
    }
  }

  FutureOr<void> _onEventImportKnowledgeToAssistant(
      EventImportKnowledgeToAssistant event, Emitter<AssistantState> emit) async {
    try {
      final response = await AssistantRepo.instant.importKnowledgeToAssistant(assistantId: event.assistantId, knowledgeId: event.knowledgeId);
      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(StateImportKnowledgeToAssistant(
          assistantId: event.assistantId,
          knowledgeId: event.knowledgeId,
          message: 'Import Knowledge Success',
          isSuccess: true,
        ));
      } else {
        emit(StateImportKnowledgeToAssistant(
          assistantId: event.assistantId,
          knowledgeId: event.knowledgeId,
          message: 'Import Knowledge Failed',
          isSuccess: false,
        ));
      }
    } catch (e) {
      emit(const StateImportKnowledgeToAssistant(
        assistantId: '',
        knowledgeId: '',
        isSuccess: false,
      ));
    }
  }

  FutureOr<void> _onEventRemoveKnowledgeFromAssistant(
    EventRemoveKnowledgeFromAssistant event, Emitter<AssistantState> emit) async {
    try {
      final response = await AssistantRepo.instant.removeKnowledgeFromAssistant(assistantId: event.assistantId, knowledgeId: event.knowledgeId);
      if (response.statusCode == 204) {
        emit(StateRemoveKnowledgeFromAssistant(isSuccess: true, assistantId: event.assistantId, knowledgeId: event.knowledgeId));
      } else {
        emit(const StateRemoveKnowledgeFromAssistant(isSuccess: false, assistantId: '', knowledgeId: ''));
      }
    } catch (e) {
      emit(const StateRemoveKnowledgeFromAssistant(isSuccess: false, assistantId: '', knowledgeId: ''));
    }
  }


  FutureOr<void> _onEventGetAssistantKnowledge(
    EventGetAssistantKnowledge event, Emitter<AssistantState> emit) async {
    try {
      final response = await AssistantRepo.instant.getAssistantKnowledges(assistantId: event.assistantId);
      if (response.statusCode == 200) {
        List<KnowledgeModel> knowledgeList = (response.data['data'] as List?)
                ?.map((data) => KnowledgeModel.fromJson(data))
                .toList() ??
            [];
       final meta = response.data['meta'] ?? {};
        emit(event.currentState.copyWith(
          isLoading: false,
          data: [...event.currentState.data, ...knowledgeList],
          total: meta['total'] ?? 0,
          hasNext: meta['hasNext'] ?? false,
          offset: event.currentState.offset + event.currentState.limit,
          limit: event.currentState.limit,
        ));
      } else {
        emit(
          event.currentState.copyWith(
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      emit(
        event.currentState.copyWith(
          isLoading: false,
        ),
      );
    }
  }
}