import 'package:chatbot_ai/features/assistant/data/assistant_model.dart';
import 'package:chatbot_ai/features/assistant/data/knowledge_model.dart';

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
  const StateFavoriteAssistant({
    super.message,
    super.isSuccess,
  });
}

class StateUpdateAssistant extends AssistantState {
  final AssistantModel? assistant;
  const StateUpdateAssistant({
    super.message,
    super.isSuccess,
    this.assistant,
  });
}

class StateDeleteAssistant extends AssistantState {
  final String? assistantantId;
  const StateDeleteAssistant({
    this.assistantantId,
    super.message,
    super.isSuccess,
  });
}

class StateGetAssistantDetail extends AssistantState {
  final AssistantModel? assistant;
  const StateGetAssistantDetail
  ({
    this.assistant,
    super.message,
    super.isSuccess,
  });
}

class StateImportKnowledgeToAssistant extends AssistantState {
  final String assistantId;
  final String knowledgeId;
  const StateImportKnowledgeToAssistant({
    required this.assistantId,
    required this.knowledgeId,
    super.message,
    super.isSuccess,
  });
}

class StateRemoveKnowledgeFromAssistant extends AssistantState {
  final String assistantId;
  final String knowledgeId;
  const StateRemoveKnowledgeFromAssistant({
    required this.assistantId,
    required this.knowledgeId,
    super.message,
    super.isSuccess,
  });
}

class StateGetAssistantKnowledge extends AssistantState {
  final List<KnowledgeModel> data;
  final int limit;
  final int offset;
  final int total;
  final bool hasNext;
  bool isLoading;

  StateGetAssistantKnowledge({
      this.data = const [],
      this.offset = 0,
      this.limit = 10,
      this.hasNext = true,
      this.total = 0,
      this.isLoading = false,
    });

    StateGetAssistantKnowledge copyWith({
      List<KnowledgeModel>? data,
      int? limit,
      int? offset,
      bool? hasNext,
      int? total,
      bool? isLoading,
    }) {
      return StateGetAssistantKnowledge(
        limit: limit ?? this.limit,
        data: data ?? this.data,
        offset: offset ?? this.offset,
        hasNext: hasNext ?? this.hasNext,
        total: total ?? this.total,
        isLoading: isLoading ?? this.isLoading,
      );
    }
}

class StateAskAssistant extends AssistantState {
  final String? answer;
  const StateAskAssistant({
    this.answer,
    super.message,
    super.isSuccess,
  });
}