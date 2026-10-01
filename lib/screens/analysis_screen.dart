
import 'package:flutter/material.dart';

import '../core/app_controller.dart';

class AnalysisScreen extends StatelessWidget {
  final String fileName;
  final int pages;
  final List<String> subjects;
  final List<String> keywords;
  final String summary;
  final String documentText;

  const AnalysisScreen({
    super.key,
    required this.fileName,
    required this.pages,
    required this.subjects,
    required this.keywords,
    required this.summary,
    required this.documentText,
  });

  void _askJoseph(
    BuildContext context,
    String command,
  ) {
    final controller = AppController();

    final response = controller.cognitive.respond(
      "$command\n\n"
      "Uploaded document: $fileName\n"
      "Detected subjects: ${subjects.join(", ")}\n"
      "Detected topics: ${keywords.join(", ")}\n"
      "Document analysis:\n$summary\n\n"
      "Full document content:\n$documentText",
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Joseph"),
        content: SingleChildScrollView(
          child: Text(response),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Joseph Analysis"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.description,
              size: 70,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            Text(
              fileName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text("Pages"),
                trailing: Text("$pages"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.school),
                title: const Text("Subjects"),
                subtitle: Text(
                  subjects.isEmpty
                      ? "None detected"
                      : subjects.join(", "),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.topic),
                title: const Text("Keywords"),
                subtitle: Text(
                  keywords.isEmpty
                      ? "None detected"
                      : keywords.join(", "),
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
                child: Text(summary),
              ),
            ),

            const SizedBox(height: 30),

            _actionButton(
              context,
              Icons.psychology,
              "Ask Joseph About This",
              "Answer questions about this uploaded document.",
            ),

            _actionButton(
              context,
              Icons.quiz,
              "Generate Quiz",
              "Generate a quiz from this uploaded document.",
            ),

            _actionButton(
              context,
              Icons.help_outline,
              "Generate Questions",
              "Generate important study questions from this uploaded document.",
            ),

            _actionButton(
              context,
              Icons.summarize,
              "Summarize Again",
              "Give me a clear summary of this uploaded document.",
            ),

            _actionButton(
              context,
              Icons.topic,
              "Important Topics",
              "Identify the most important topics in this uploaded document.",
            ),

            _actionButton(
              context,
              Icons.auto_graph,
              "Exam Prediction",
              "Identify possible exam questions based on this uploaded document.",
            ),

            _actionButton(
              context,
              Icons.schedule,
              "Create Study Plan",
              "Create a study plan based on this uploaded document.",
            ),

            _actionButton(
              context,
              Icons.menu_book,
              "Revision Notes",
              "Create revision notes from this uploaded document.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String title,
    String command,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(title),
          onPressed: () {
            _askJoseph(context, command);
          },
        ),
      ),
    );
  }
}