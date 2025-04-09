import 'package:chatbot_ai/features/prompt/data/prompt_model.dart';

class PromptState {
  const PromptState();
}

class StatePromptInitial extends PromptState {
  const StatePromptInitial();
}

class StatePromptGet extends PromptState {
  final List<PromptGetModel> data;
  final int limit;
  final int offset;
  final int total;
  final bool hasNext;
  bool isLoading;

  StatePromptGet({
      this.data = const [],
      this.offset = 0,
      this.limit = 10,
      this.hasNext = true,
      this.total = 0,
      this.isLoading = false,
    });

    refresh(){
    return StatePromptGet();
    }

    StatePromptGet copyWith({
      List<PromptGetModel>? data,
      int? limit,
      int? offset,
      bool? hasNext,
      int? total,
      bool? isLoading,
    }) {
      return StatePromptGet(
        limit: limit ?? this.limit,
        data: data ?? this.data,
        offset: offset ?? this.offset,
        hasNext: hasNext ?? this.hasNext,
        total: total ?? this.total,
        isLoading: isLoading ?? this.isLoading,
      );
    }
}