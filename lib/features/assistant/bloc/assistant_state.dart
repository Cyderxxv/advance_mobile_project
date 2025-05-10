import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';

class AssistantState {
  final String? message;
  final bool? isSuccess;
  const AssistantState({
    this.message, 
    this.isSuccess,
  });
}

class StateAssistantInitial extends AssistantState {
  const StateAssistantInitial({
    super.message, 
    super.isSuccess,
  });
}

class StateGetAssistants extends AssistantState {
  final List<AssistantModel> data;
  final int limit;
  final int offset;
  final int total;
  final bool hasNext;
  bool isLoading;

  StateGetAssistants({
      this.data = const [],
      this.offset = 0,
      this.limit = 10,
      this.hasNext = true,
      this.total = 0,
      this.isLoading = false,
    });

    StateGetAssistants copyWith({
      List<AssistantModel>? data,
      int? limit,
      int? offset,
      bool? hasNext,
      int? total,
      bool? isLoading,
    }) {
      return StateGetAssistants(
        limit: limit ?? this.limit,
        data: data ?? this.data,
        offset: offset ?? this.offset,
        hasNext: hasNext ?? this.hasNext,
        total: total ?? this.total,
        isLoading: isLoading ?? this.isLoading,
      );
    }
}

class StateCreateAssistant extends AssistantState {
  const StateCreateAssistant({
    super.message,
    super.isSuccess,
  });
}

class StateFavoriteAssistant extends AssistantState {
  final String id;
  final String assistantName;
  final String openAiAssistantId;
  final String? instructions;
  final String? description;
  final String? openAiThreadIdPlay;
  final String createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;

  const StateFavoriteAssistant({
    required this.id,
    required this.assistantName,
    required this.openAiAssistantId,
    this.instructions,
    this.description,
    this.openAiThreadIdPlay,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    super.message,
    super.isSuccess,
  });
}