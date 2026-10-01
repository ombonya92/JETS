import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../services/joseph_conversation_engine.dart';
import '../widgets/chat_body.dart';
import '../widgets/chat_input.dart';

class JosephChatScreen extends StatefulWidget {
  const JosephChatScreen({super.key});

  @override
  State<JosephChatScreen> createState() =>
      _JosephChatScreenState();
}

class _JosephChatScreenState
    extends State<JosephChatScreen> {
  late final JosephConversationEngine conversation;

  final TextEditingController inputController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    conversation = JosephConversationEngine(
      AppController.instance,
    );
  }

  void sendMessage() {
    final text = inputController.text.trim();

    if (text.isEmpty) return;

    conversation.send(text);

    inputController.clear();

    setState(() {});
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Joseph AI"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Expanded(
            child: ChatBody(
              messages: conversation.messages,
            ),
          ),

          ChatInput(
            controller: inputController,
            onSend: sendMessage,
          ),
        ],
      ),
    );
  }
}