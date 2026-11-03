import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../state/app_state.dart';

class JosephScreen extends StatefulWidget {
  const JosephScreen({super.key});

  @override
  State<JosephScreen> createState() => _JosephScreenState();
}

class _JosephScreenState extends State<JosephScreen> {
  final TextEditingController _input = TextEditingController();

  void _ask() {
    final question = _input.text.trim();
    if (question.isEmpty) return;

    final reply = AppController.instance.cognitive.respond(question);
    _input.clear();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Joseph'),
        content: SingleChildScrollView(child: Text(reply)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppController.instance.state,
      builder: (context, _) {
        final state = AppController.instance.state;
        return _JosephView(
          state: state,
          input: _input,
          onAsk: _ask,
        );
      },
    );
  }
}

class _JosephView extends StatelessWidget {
  final AppState state;
  final TextEditingController input;
  final VoidCallback onAsk;

  const _JosephView({
    required this.state,
    required this.input,
    required this.onAsk,
  });

  static const List<_Chip> _chips = [
    _Chip(Icons.quiz, 'quiz anova'),
    _Chip(Icons.summarize, 'Summarize Notes'),
    _Chip(Icons.menu_book, 'Study Plan'),
    _Chip(Icons.analytics, 'my progress'),
    _Chip(Icons.auto_graph, 'my weak topics'),
    _Chip(Icons.psychology_alt, 'my strong topics'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;
    final brain = controller.cognitive.think();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          'Joseph AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _header(brain),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  _statusCard(state, brain),
                  const SizedBox(height: 20),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _chipRow(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            _inputBar(context),
          ],
        ),
      ),
    );
  }

  Widget _header(Map<String, dynamic> brain) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.smart_toy, color: Colors.blue, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brain['greeting']?.toString() ?? 'Hello!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  brain['insight']?.toString() ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(AppState state, Map<String, dynamic> brain) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _statBox(
                    'Level',
                    brain['learningLevel']?.toString() ?? '',
                    Icons.school,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _statBox(
                    'Confidence',
                    '${brain['confidence']?.toStringAsFixed(0) ?? '0'}%',
                    Icons.psychology,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _statBox(
                    'Uploads',
                    '${state.progress.totalUploads}',
                    Icons.upload_file,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _statBox(
                    'Questions',
                    '${state.progress.totalQuestions}',
                    Icons.help_outline,
                  ),
                ),
              ],
            ),
            if (state.progress.weakTopics.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Needs Work',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: state.progress.weakTopics
                    .map(
                      (t) => Chip(
                        label: Text(t),
                        backgroundColor: Colors.red.shade50,
                        side: BorderSide(color: Colors.red.shade200),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (state.progress.strongTopics.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Mastered',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: state.progress.strongTopics
                    .map(
                      (t) => Chip(
                        label: Text(t),
                        backgroundColor: Colors.green.shade50,
                        side: BorderSide(color: Colors.green.shade200),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statBox(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _chipRow(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _chips.map((chip) => _actionChip(context, chip)).toList(),
    );
  }

  Widget _actionChip(BuildContext context, _Chip chip) {
    return ActionChip(
      avatar: Icon(chip.icon, size: 18, color: Colors.blue),
      label: Text(chip.label),
      onPressed: () {
        input.text = chip.label;
        onAsk();
      },
    );
  }

  Widget _inputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: input,
              onSubmitted: (_) => onAsk(),
              decoration: InputDecoration(
                hintText: 'Ask Joseph anything.',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'sendJoseph',
            mini: true,
            backgroundColor: Colors.blue,
            onPressed: onAsk,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _Chip {
  final IconData icon;
  final String label;
  const _Chip(this.icon, this.label);
}