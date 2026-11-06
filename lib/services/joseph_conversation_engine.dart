import 'package:jets/core/app_controller.dart';
import 'package:jets/models/chat_message.dart';

// Manages the Joseph chat message list for the current session.
class JosephConversationEngine {
  final AppController controller;
  final List<ChatMessage> _messages = [];

  JosephConversationEngine(this.controller);

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void send(String question) {
    if (question.trim().isEmpty) return;

    _messages.add(ChatMessage.fromUser(question));

    final reply = controller.cognitive.respond(question);

    _messages.add(ChatMessage.fromJoseph(reply));
  }

  void clear() => _messages.clear();
}