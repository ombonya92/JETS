import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import 'chat_bubble.dart';

class ChatBody extends StatelessWidget {
  final List<ChatMessage> messages;

  const ChatBody({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text(
          "👋 Hello!\nI'm Joseph.\n\nAsk me anything about your studies.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatBubble(
          message: messages[index],
        );
      },
    );
  }
}