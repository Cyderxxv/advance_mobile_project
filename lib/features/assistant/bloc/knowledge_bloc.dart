import 'dart:async';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_event.dart';
import 'package:chatbot_ai/features/assistant/bloc/knowledge_state.dart';
import 'package:chatbot_ai/features/assistant/data/confluence_model.dart';
import 'package:chatbot_ai/features/assistant/data/file_model.dart';
import 'package:chatbot_ai/features/assistant/data/knowledge_model.dart';
import 'package:chatbot_ai/features/assistant/domain/knowledge_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KnowledgeBloc extends Bloc<KnowledgeEvent, KnowledgeState> {
  KnowledgeBloc() : super(const StateKnowledgeInitial()) {
    on<EventGetKnowledges>(_onEventGetKnowledges);
    on<EventCreateKnowledge>(_onEventCreateKnowledge);
    on<EventUpdateKnowledge>(_onEventUpdateKnowledge);
    on<EventDeleteKnowledge>(_onEventDeleteKnowledge);
    on<EventUploadFiles>(_onEventUploadFiles);
    on<EventImportKBFromConfluence>(_onEventImportKBFromConfluence);
  }

  FutureOr<void> _onEventGetKnowledges(
      EventGetKnowledges event, Emitter<KnowledgeState> emit) async {
    try {
      emit(event.currentState.copyWith(isLoading: true));
      if (event.currentState.hasNext == false) {
        emit(event.currentState.copyWith(isLoading: false));
        return;
      }
      final response = await KnowledgeRepo.instant.getKnowledges(
        limit: event.currentState.limit,
        offset: event.currentState.offset,
      );
      if (response.statusCode == 200) {
        List<KnowledgeModel> newData = (response.data['data'] as List?)
                ?.map((data) => KnowledgeModel.fromJson(data))
                .toList() ??
            [];

        // Deduplicate data based on unique identifiers (e.g., id)
        final updatedData = {
          ...event.currentState.data.map((e) => e.id).toSet(),
          ...newData.map((e) => e.id).toSet()
        }.map((id) =>
            newData.firstWhere((knowledge) => knowledge.id == id, orElse: () => event.currentState.data.firstWhere((knowledge) => knowledge.id == id)));

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

  FutureOr<void> _onEventCreateKnowledge(
      EventCreateKnowledge event, Emitter<KnowledgeState> emit) async {
    try {
      final response = await KnowledgeRepo.instant.createKnowledge(
        knowledgeName: event.knowledgeName,
        description: event.description,
      );
      if (response.statusCode == 201) {
        emit(const StateCreateKnowledge(
          message: 'Create Assistant Success',
          isSuccess: true,
        ));
      } else {
        emit(const StateCreateKnowledge(
          message: 'Create Assistant Failed',
          isSuccess: false,
        ));
      }
    } catch (e) {
      emit(const StateCreateKnowledge(isSuccess: false));
    }
  }

  FutureOr<void> _onEventUpdateKnowledge(
      EventUpdateKnowledge event, Emitter<KnowledgeState> emit) async {
    try {
      final response = await KnowledgeRepo.instant.updateKnowledge(
        knowledgeName: event.knowledgeName,
        id: event.id,
        description: event.description,
      );
      if (response.statusCode == 200) {
        KnowledgeModel updatedKnowledge =
            KnowledgeModel.fromJson(response.data);
        emit(StateUpdateKnowledge(
          knowledge: updatedKnowledge,
          message: 'Update Assistant Success',
          isSuccess: true,
        ));
      } else {
        emit(const StateCreateKnowledge(
          message: 'Update Assistant Failed',
          isSuccess: false,
        ));
      }
    } catch (e) {
      emit(const StateCreateKnowledge(isSuccess: false));
    }
  }

  FutureOr<void> _onEventDeleteKnowledge(
      EventDeleteKnowledge event, Emitter<KnowledgeState> emit) async {
    try {
      final response = await KnowledgeRepo.instant.deleteKnowledge(id: event.id);
      if (response.statusCode == 204) {
        emit(StateDeleteKnowledge(isSuccess: true, knowledgeId: event.id));
      } else {
        emit(const StateDeleteKnowledge(isSuccess: false));
      }
    } catch (e) {
      emit(const StateDeleteKnowledge(isSuccess: false));
    }
  }

  FutureOr<void> _onEventUploadFiles(
      EventUploadFiles event, Emitter<KnowledgeState> emit) async {
    try {
      final response = await KnowledgeRepo.instant.uploadFiles(
        files: event.files,
      );
      if (response.statusCode == 201) {
        List<FileModel> uploadedFiles = (response.data['files'] as List?)
                ?.map((data) => FileModel.fromJson(data))
                .toList() ??
            [];
        emit(StateUploadFiles(
          files: uploadedFiles,
          message: 'Upload Files Success',
          isSuccess: true,
        ));
      } else {
        emit(const StateUploadFiles(
          message: 'Upload Files Failed',
          isSuccess: false,
        ));
      }
    } catch (e) {
      emit(const StateUploadFiles(isSuccess: false));
    }
  }
  

  FutureOr<void> _onEventImportKBFromConfluence(
      EventImportKBFromConfluence event, Emitter<KnowledgeState> emit) async {
    try {
      final response = await KnowledgeRepo.instant.importKBFromConfluence(
        name: event.name,
        wikiUrl: event.wikiUrl,
        username: event.username,
        token: event.token,
        knowledgeId: event.knowledgeId, 
      );
      if (response.statusCode == 201) {
        List<ConfluenceModel> confluence = (response.data['datasources'] as List?)
                ?.map((data) => ConfluenceModel.fromJson(data))
                .toList() ??
            [];
        emit(StateImportKBFromConfluence(
          confluence: confluence,
          message: 'Import Knowledge Base Success',
          isSuccess: true,
        ));
      } else {
        emit(const StateImportKBFromConfluence(
          message: 'Import Knowledge Base Failed',
          isSuccess: false,
        ));
      }
    } catch (e) {
      emit(const StateImportKBFromConfluence(isSuccess: false));
    }
  }
}