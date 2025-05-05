sealed class EventHistory {
  const EventHistory();
}

final class EventGetConversations extends EventHistory {
  final String? cursor;
  final int? limit;
  final String? assistantId;
  final String assistantModel;

  EventGetConversations({
    this.cursor,
    this.limit,
    this.assistantId,
    required this.assistantModel,
  });
}

final class EventGetConversationsHistory extends EventHistory {
  final String conversationId;
  final String? cursor;
  final int? limit;
  final String? assistantId;
  final String assistantModel;

  EventGetConversationsHistory({
    required this.conversationId,
    this.cursor,
    this.limit,
    this.assistantId,
    required this.assistantModel,
  });
}