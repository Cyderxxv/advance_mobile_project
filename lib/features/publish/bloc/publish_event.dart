sealed class EventPublish {
  const EventPublish();
}

final class EventPublishTelegram extends EventPublish {
  final String botToken;
  final String assistantId;

  EventPublishTelegram({
    required this.botToken,
    required this.assistantId,
  });
}