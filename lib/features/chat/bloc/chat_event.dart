sealed class ChatEvent {
  const ChatEvent();
}

final class EventChat extends ChatEvent {
  final String content;
  final List<String> files;

  EventChat({required this.content, required this.files});
}