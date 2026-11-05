import 'package:flutter/material.dart';

import 'package:jets/core/app_controller.dart';
import 'package:jets/models/chat_message.dart';
import 'package:jets/security/input_validator.dart';
import 'package:jets/widgets/chat_bubble.dart';

class JosephScreen extends StatefulWidget {
  const JosephScreen({super.key});

  @override
  State<JosephScreen> createState() => _JosephScreenState();
}

class _JosephScreenState extends State<JosephScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  static const List<_QuickChip> _chips = [
    _QuickChip(Icons.quiz, 'quiz anova'),
    _QuickChip(Icons.school, 'my weak topics'),
    _QuickChip(Icons.analytics, 'my progress'),
    _QuickChip(Icons.auto_graph, 'exam prediction'),
    _QuickChip(Icons.menu_book, 'study plan'),
    _QuickChip(Icons.psychology, 'my strong topics'),
  ];

  @override
  void initState() {
    super.initState();
    final brain = AppController.instance.cognitive.think();
    final greeting = brain['greeting']?.toString() ??
        'Hello! Ask me anything about your studies.';
    _messages.add(ChatMessage.fromJoseph(greeting));
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? override]) {
    final text = InputValidator.sanitise(override ?? _input.text);
    if (text.isEmpty) return;

    setState(() => _messages.add(ChatMessage.fromUser(text)));
    _input.clear();
    _scrollToBottom();

    final reply = AppController.instance.cognitive.respond(text);
    setState(() => _messages.add(ChatMessage.fromJoseph(reply)));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.smart_toy, color: Colors.blue, size: 18),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Joseph',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'AI Study Assistant',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _chipsBar(),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) => ChatBubble(message: _messages[index]),
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _chipsBar() {
    return Container(
      color: Colors.white,
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: _chips
            .map(
              (chip) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  avatar: Icon(chip.icon, size: 15, color: Colors.blue),
                  label: Text(chip.label, style: const TextStyle(fontSize: 12)),
                  onPressed: () => _send(chip.label),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _input,
                onSubmitted: (_) => _send(),
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Ask Joseph anything...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              heroTag: 'josephSend',
              mini: true,
              backgroundColor: Colors.blue,
              onPressed: _send,
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickChip {
  final IconData icon;
  final String label;
  const _QuickChip(this.icon, this.label);
}