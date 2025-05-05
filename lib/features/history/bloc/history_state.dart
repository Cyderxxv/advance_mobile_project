class HistoryState {
  final String? message;
  final bool? isSuccess;
  const HistoryState({
    this.message, 
    this.isSuccess,
  });
}

class StateHistoryInitial extends HistoryState {
  const StateHistoryInitial({
    super.message, 
    super.isSuccess,
  });
}

class StateGetConversations extends HistoryState {
  final List? items;
  final String? cursor;
  final bool? hasMore;
  final int? limit;
  final bool? isLoading;
  const StateGetConversations({
    this.items,
    this.cursor,
    this.hasMore,
    this.limit,
    this.isLoading,
    super.message, 
    super.isSuccess,
  });
}

class StateGetConversationsHistory extends HistoryState {
  final List? messages;
  final String? cursor;
  final bool? hasMore;
  final int? limit;
  final bool? isLoading;
  const StateGetConversationsHistory({
    this.messages,
    this.cursor,
    this.hasMore,
    this.limit,
    this.isLoading,
    super.message, 
    super.isSuccess,
  });
}