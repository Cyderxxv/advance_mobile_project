import 'package:chatbot_ai/features/assistant/data/confluence_model.dart';
import 'package:chatbot_ai/features/assistant/data/datasource_model.dart';
import 'package:chatbot_ai/features/assistant/data/file_model.dart';
import 'package:chatbot_ai/features/assistant/data/knowledge_model.dart';

class KnowledgeState {
  final String? message;
  final bool? isSuccess;
  const KnowledgeState({
    this.message, 
    this.isSuccess,
  });
}

class StateKnowledgeInitial extends KnowledgeState {
  const StateKnowledgeInitial({
    super.message, 
    super.isSuccess,
  });
}

class StateGetKnowledges extends KnowledgeState {
  final List<KnowledgeModel> data;
  final int limit;
  final int offset;
  final int total;
  final bool hasNext;
  bool isLoading;

  StateGetKnowledges({
      this.data = const [],
      this.offset = 0,
      this.limit = 10,
      this.hasNext = true,
      this.total = 0,
      this.isLoading = false,
    });

    StateGetKnowledges copyWith({
      List<KnowledgeModel>? data,
      int? limit,
      int? offset,
      bool? hasNext,
      int? total,
      bool? isLoading,
    }) {
      return StateGetKnowledges(
        limit: limit ?? this.limit,
        data: data ?? this.data,
        offset: offset ?? this.offset,
        hasNext: hasNext ?? this.hasNext,
        total: total ?? this.total,
        isLoading: isLoading ?? this.isLoading,
      );
    }
}

class StateCreateKnowledge extends KnowledgeState {
  const StateCreateKnowledge({
    super.message,
    super.isSuccess,
  });
}

class StateUpdateKnowledge extends KnowledgeState {
  final KnowledgeModel? knowledge;
  const StateUpdateKnowledge({
    this.knowledge,
    super.message,
    super.isSuccess,
  });
}

class StateDeleteKnowledge extends KnowledgeState {
  final String? knowledgeId;
  const StateDeleteKnowledge({
    this.knowledgeId,
    super.message,
    super.isSuccess,
  });
}

class StateUploadFiles extends KnowledgeState {
  final List<FileModel>? files;
  const StateUploadFiles({
    this.files,
    super.message,
    super.isSuccess,
  });
}

class StateImportKBFromConfluence extends KnowledgeState {
  final List<ConfluenceModel>? confluence;
  const StateImportKBFromConfluence({
    this.confluence,
    super.message,
    super.isSuccess,
  });
}

class StateGetDatasourceFromKB extends KnowledgeState {
  final List<DatasourceModel> data;
  final int limit;
  final int offset;
  final int total;
  final bool hasNext;
  bool isLoading;

  StateGetDatasourceFromKB({
      this.data = const [],
      this.offset = 0,
      this.limit = 10,
      this.hasNext = true,
      this.total = 0,
      this.isLoading = false,
    });

    StateGetDatasourceFromKB copyWith({
      List<DatasourceModel>? data,
      int? limit,
      int? offset,
      bool? hasNext,
      int? total,
      bool? isLoading,
    }) {
      return StateGetDatasourceFromKB(
        limit: limit ?? this.limit,
        data: data ?? this.data,
        offset: offset ?? this.offset,
        hasNext: hasNext ?? this.hasNext,
        total: total ?? this.total,
        isLoading: isLoading ?? this.isLoading,
      );
    }
}

class StateImportKBFromSlack extends KnowledgeState {
  final List<ConfluenceModel>? slack;
  const StateImportKBFromSlack({
    this.slack,
    super.message,
    super.isSuccess,
  });
}