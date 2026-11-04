import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        AppController.instance.state,
        AppController.instance.authState,
      ]),
      builder: (context, _) {
        final state = AppController.instance.state;
        final user = AppController.instance.authState.user;
        final cognitive = AppController.instance.cognitive;
        final brain = cognitive.think();
        final predictions = AppController.instance.prediction.predictions();
        final firstName = user?.name.split(' ').first ?? 'Student';

        return Scaffold(
          appBar: AppBar(title: const Text('JETS Dashboard')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search notes, topics, past papers...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                _josephCard(firstName, brain),
                const SizedBox(height: 20),
                _statsRow(state, brain),
                const SizedBox(height: 20),
                _predictionsCard(predictions),
                const SizedBox(height: 25),
                const Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
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
                    _menuCard(context, Icons.menu_book, 'Library', 1),
                    _menuCard(context, Icons.upload_file, 'Upload', 2),
                    _menuCard(context, Icons.timeline, 'Timeline', 3),
                    _menuCard(context, Icons.smart_toy, 'Joseph', 4),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _josephCard(String firstName, Map<String, dynamic> brain) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Icons.smart_toy, color: Colors.blue, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $firstName.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  brain['insight']?.toString() ??
                      'Ready to help you study.',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(dynamic state, Map<String, dynamic> brain) {
    return Row(
      children: [
        Expanded(
          child: _statTile(
            Icons.school,
            state.learningLevel(),
            'Level',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statTile(
            Icons.psychology,
            '${state.confidenceScore().toStringAsFixed(0)}%',
            'Confidence',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statTile(
            Icons.upload_file,
            '${state.progress.totalUploads}',
            'Uploads',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statTile(
            Icons.quiz,
            '${state.progress.quizzesCompleted}',
            'Quizzes',
          ),
        ),
      ],
    );
  }

  Widget _statTile(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Predictions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...predictions.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
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

  Widget _menuCard(
    BuildContext context,
    IconData icon,
    String title,
    int tabIndex,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          final nav = context
              .findAncestorStateOfType<_MainScreensNavigatorState>();
          nav?.jumpTo(tabIndex);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Exposed so DashboardScreen quick-access cards can navigate tabs.
abstract class _MainScreensNavigatorState {
  void jumpTo(int index);
}