import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../models/document_action.dart';
import '../models/document_analysis.dart';

class _ActionSpec {
  final IconData icon;
  final String label;
  final DocumentAction action;

  const _ActionSpec(this.icon, this.label, this.action);
}

class AnalysisScreen extends StatelessWidget {
  final DocumentAnalysis document;

  const AnalysisScreen({super.key, required this.document});

  static const List<_ActionSpec> _actions = [
    _ActionSpec(
      Icons.psychology,
      'Ask Joseph About This',
      DocumentAction.askAboutDocument,
    ),
    _ActionSpec(
      Icons.quiz,
      'Generate Quiz',
      DocumentAction.generateQuiz,
    ),
    _ActionSpec(
      Icons.help_outline,
      'Generate Questions',
      DocumentAction.generateQuestions,
    ),
    _ActionSpec(
      Icons.summarize,
      'Summarize Again',
      DocumentAction.summarize,
    ),
    _ActionSpec(
      Icons.topic,
      'Important Topics',
      DocumentAction.importantTopics,
    ),
    _ActionSpec(
      Icons.auto_graph,
      'Exam Prediction',
      DocumentAction.examPrediction,
    ),
    _ActionSpec(
      Icons.schedule,
      'Create Study Plan',
      DocumentAction.studyPlan,
    ),
    _ActionSpec(
      Icons.menu_book,
      'Revision Notes',
      DocumentAction.revisionNotes,
    ),
  ];

  void _runAction(BuildContext context, DocumentAction action) {
    final response = AppController.instance.cognitive.respondToDocument(
      action,
      document,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Joseph'),
        content: SingleChildScrollView(
          child: Text(response),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joseph Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.description,
              size: 70,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              document.fileName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Pages'),
                trailing: Text('${document.pageCount}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Subjects'),
                subtitle: Text(
                  document.subjects.isEmpty
                      ? 'None detected'
                      : document.subjects.join(', '),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.topic),
                title: const Text('Keywords'),
                subtitle: Text(
                  document.keywords.isEmpty
                      ? 'None detected'
                      : document.keywords.join(', '),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Joseph's Summary",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(document.summary),
              ),
            ),
            const SizedBox(height: 30),
            for (final spec in _actions) _actionButton(context, spec),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, _ActionSpec spec) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(spec.icon),
          label: Text(spec.label),
          onPressed: () => _runAction(context, spec.action),
        ),
      ),
    );
  }
}