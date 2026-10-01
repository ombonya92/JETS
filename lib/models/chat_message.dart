enum Sender {
  user,
  joseph,
}

class ChatMessage {
  final String message;
  final Sender sender;
  final DateTime time;

  const ChatMessage({
    required this.message,
    required this.sender,
    required this.time,
  });
}