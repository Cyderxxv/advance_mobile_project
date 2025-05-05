class ConversationMessage {
  final String? answer;
  final int? createdAt;
  final List<String>? files;
  final String? query;

  ConversationMessage({
    this.answer,
    this.createdAt,
    this.files,
    this.query,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      answer: json['answer'] as String?,
      createdAt: json['createdAt'] as int?,
      files: (json['files'] as List?)?.map((e) => e as String).toList(),
      query: json['query'] as String?,
    );
  }
}

class HistoryResponseModel {
  final String? cursor;
  final bool? hasMore;
  final int? limit;
  final List<ConversationMessage>? items;

  HistoryResponseModel({
    this.cursor,
    this.hasMore,
    this.limit,
    this.items,
  });

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return HistoryResponseModel(
      cursor: json['cursor'] as String?,
      hasMore: json['has_more'] as bool?,
      limit: json['limit'] as int?,
      items: (json['items'] as List?)?.map((e) => ConversationMessage.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
