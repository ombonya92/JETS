import '../core/app_controller.dart';
import '../models/chat_message.dart';

class JosephConversationEngine {
  final AppController controller;

  final List<ChatMessage> _messages = [];

  JosephConversationEngine(this.controller);

  List<ChatMessage> get messages =>
      List.unmodifiable(_messages);

  void clear() {
    _messages.clear();
  }

  void send(String question) {
    if (question.trim().isEmpty) return;

    _messages.add(
      ChatMessage(
        message: question,
        sender: Sender.user,
        time: DateTime.now(),
      ),
    );

    final reply =
        controller.cognitive.respond(question);

    _messages.add(
      ChatMessage(
        message: reply,
        sender: Sender.joseph,
        time: DateTime.now(),
      ),
    );
  }
}