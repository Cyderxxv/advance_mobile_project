import 'package:chatbot_ai/features/prompt/data/prompt_model.dart';

class PromptState {
  final String? message;
  final bool? isSuccess;
  const PromptState({
    this.message, 
    this.isSuccess,
  });
}

class StatePromptInitial extends PromptState {
  const StatePromptInitial({
    super.message, 
    super.isSuccess,
  });
}

class StatePromptGet extends PromptState {
  final List<PromptGetModel> data;
  final int limit;
  final int offset;
  final int total;
  final bool hasNext;
  bool isLoading;
  bool isPublic;
  bool isFavorite;

  StatePromptGet({
      this.data = const [],
      this.offset = 0,
      this.limit = 10,
      this.hasNext = true,
      this.total = 0,
      this.isLoading = false,
      this.isPublic = true,
      this.isFavorite = false,
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
      bool? isPublic,
      bool? isFavorite,
    }) {
      return StatePromptGet(
        limit: limit ?? this.limit,
        data: data ?? this.data,
        offset: offset ?? this.offset,
        hasNext: hasNext ?? this.hasNext,
        total: total ?? this.total,
        isLoading: isLoading ?? this.isLoading,
        isPublic: isPublic ?? this.isPublic,
        isFavorite: isFavorite ?? this.isFavorite,
      );
    }
}

class StatePromptUpdate extends PromptState {
  StatePromptUpdate({
    super.message,
    super.isSuccess,
  });
}

class StatePromptDelete extends PromptState {
  StatePromptDelete({
    super.message,
    super.isSuccess,
  });
}

class StatePromptToggleFavorite extends PromptState {
  StatePromptToggleFavorite({
    super.message,
    super.isSuccess,
  });
}

class StatePrivatePromptCreate extends PromptState {
  StatePrivatePromptCreate({
    super.message,
    super.isSuccess,
  });
}