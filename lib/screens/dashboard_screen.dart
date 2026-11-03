import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../state/app_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppController.instance.state,
      builder: (context, _) {
        final state = AppController.instance.state;
        return _DashboardView(state: state);
      },
    );
  }
}

class _DashboardView extends StatelessWidget {
  final AppState state;

  const _DashboardView({required this.state});

  @override
  Widget build(BuildContext context) {
    final progress = state.progress;
    final predictions = AppController.instance.prediction.predictions();

    return Scaffold(
      appBar: AppBar(title: const Text('JETS Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _josephCard(context),
            const SizedBox(height: 20),
            _statsRow(
              level: state.learningLevel(),
              confidence: state.confidenceScore(),
              uploads: progress.totalUploads,
              questions: progress.totalQuestions,
            ),
            const SizedBox(height: 20),
            _predictionsCard(predictions),
            const SizedBox(height: 25),
            const Text(
              'Quick Access',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.2,
              children: [
                _menuCard(Icons.menu_book, 'Notes'),
                _menuCard(Icons.upload, 'Upload'),
                _menuCard(Icons.quiz, 'Quiz'),
                _menuCard(Icons.timeline, 'Timeline'),
                _menuCard(Icons.analytics, 'Progress'),
                _menuCard(Icons.smart_toy, 'Joseph'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _josephCard(BuildContext context) {
    final greeting = AppController.instance.personality.greeting();
    final insight = AppController.instance.reasoning.generateInsight();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Joseph AI',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(greeting, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              insight,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsRow({
    required String level,
    required double confidence,
    required int uploads,
    required int questions,
  }) {
    return Row(
      children: [
        Expanded(child: _statTile(Icons.school, level, 'Level')),
        const SizedBox(width: 12),
        Expanded(
          child: _statTile(
            Icons.psychology,
            '${confidence.toStringAsFixed(0)}%',
            'Confidence',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: _statTile(Icons.upload_file, '$uploads', 'Uploads')),
        const SizedBox(width: 12),
        Expanded(child: _statTile(Icons.help_outline, '$questions', 'Asked')),
      ],
    );
  }

  Widget _statTile(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _predictionsCard(List<String> predictions) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Predictions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ...predictions.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('- '),
                    Expanded(child: Text(p)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(IconData icon, String title) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.blue),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}