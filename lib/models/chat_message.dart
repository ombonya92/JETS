enum MessageSender { user, joseph }

class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime time;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
  });

  factory ChatMessage.fromUser(String text) {
    return ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      sender: MessageSender.user,
      time: DateTime.now(),
    );
  }

  factory ChatMessage.fromJoseph(String text) {
    return ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}_j',
      text: text,
      sender: MessageSender.joseph,
      time: DateTime.now(),
    );
  }
}