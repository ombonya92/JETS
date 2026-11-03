import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../models/timeline_event.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppController.instance.state,
      builder: (context, _) {
        final events = AppController.instance.state.timeline;
        return _TimelineView(events: events);
      },
    );
  }
}

class _TimelineView extends StatelessWidget {
  final List<TimelineEvent> events;

  const _TimelineView({required this.events});

  static const Map<String, IconData> _icons = {
    'Upload': Icons.upload_file,
    'Question': Icons.help_outline,
    'Quiz': Icons.quiz,
    'Study': Icons.menu_book,
    'Learning': Icons.school,
  };

  static const Map<String, Color> _colors = {
    'Upload': Colors.blue,
    'Question': Colors.purple,
    'Quiz': Colors.orange,
    'Study': Colors.green,
    'Learning': Colors.teal,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Study Timeline',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: events.isEmpty
          ? const Center(
              child: Text(
                'No activity yet.\nUpload a document or ask Joseph a question.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return _eventRow(context, events[index], index);
              },
            ),
    );
  }

  Widget _eventRow(
    BuildContext context,
    TimelineEvent event,
    int index,
  ) {
    final icon = _icons[event.category] ?? Icons.circle;
    final color = _colors[event.category] ?? Colors.grey;
    final isLast = index == events.length - 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              if (!isLast)
                Container(
                  width: 3,
                  height: 70,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.description,
                      style: TextStyle(color: Colors.grey.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(event.time),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${time.day}/${time.month}/${time.year}';
  }
}