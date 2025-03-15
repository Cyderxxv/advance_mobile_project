class ChatHistory {
  final String message;
  final DateTime timestamp;
  bool isDeleted;

  ChatHistory({
    required this.message,
    required this.timestamp,
    this.isDeleted = false,
  });
}
