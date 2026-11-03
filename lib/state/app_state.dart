import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/student_progress.dart';
import '../models/timeline_event.dart';

class AppState extends ChangeNotifier {
  static const String _progressKey = 'student_progress';
  static const String _timelineKey = 'timeline_events';
  static const int _maxTimelineEvents = 100;

  StudentProgress _progress = StudentProgress();
  final List<TimelineEvent> _timeline = [];

  bool _loaded = false;

  StudentProgress get progress => _progress;
  List<TimelineEvent> get timeline => List.unmodifiable(_timeline);
  bool get loaded => _loaded;

  String learningLevel() {
    final n = _progress.totalInteractions;
    if (n < 10) return 'Learning You';
    if (n < 40) return 'Understanding You';
    if (n < 80) return 'Adapting';
    if (n < 150) return 'Academic Mentor';
    return 'Personal Tutor';
  }

  double confidenceScore() {
    final score = (_progress.totalUploads * 4) +
        (_progress.totalQuestions * 2) +
        (_progress.quizzesCompleted * 5);
    return score.clamp(0, 100).toDouble();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final progressJson = prefs.getString(_progressKey);
    if (progressJson != null) {
      _progress = StudentProgress.fromJson(
        jsonDecode(progressJson) as Map<String, dynamic>,
      );
    }

    final timelineJson = prefs.getString(_timelineKey);
    if (timelineJson != null) {
      final list = jsonDecode(timelineJson) as List;
      _timeline.addAll(
        list.map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>)),
      );
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(_progress.toJson()));
    await prefs.setString(
      _timelineKey,
      jsonEncode(_timeline.map((e) => e.toJson()).toList()),
    );
  }

  void recordUpload(String fileName, String subject) {
    _progress.totalUploads++;

    if (!_progress.uploadedFiles.contains(fileName)) {
      _progress.uploadedFiles.add(fileName);
    }

    if (subject.isNotEmpty && !_progress.subjects.contains(subject)) {
      _progress.subjects.add(subject);
      _progress.favoriteSubject = subject;
    }

    _addEvent(
      title: 'Uploaded Notes',
      description: fileName,
      category: 'Upload',
    );
  }

  void recordQuestion(String question) {
    _progress.totalQuestions++;
    _addEvent(
      title: 'Asked Joseph',
      description: question,
      category: 'Question',
    );
  }

  void recordQuiz(String topic, int score) {
    _progress.quizzesCompleted++;
    _addEvent(
      title: 'Completed Quiz',
      description: '$topic - $score%',
      category: 'Quiz',
    );
  }

  void recordStudySession(int minutes) {
    _progress.studyMinutes += minutes;
    _addEvent(
      title: 'Study Session',
      description: '$minutes minutes',
      category: 'Study',
    );
  }

  void recordWeakTopic(String topic) {
    if (_progress.weakTopics.contains(topic)) return;
    _progress.weakTopics.add(topic);
    _progress.strongTopics.remove(topic);
    _addEvent(
      title: 'Weak Topic Detected',
      description: topic,
      category: 'Learning',
    );
  }

  void recordStrongTopic(String topic) {
    if (_progress.strongTopics.contains(topic)) return;
    _progress.strongTopics.add(topic);
    _progress.weakTopics.remove(topic);
    _addEvent(
      title: 'Topic Mastered',
      description: topic,
      category: 'Learning',
    );
  }

  Future<void> reset() async {
    _progress = StudentProgress();
    _timeline.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
    await prefs.remove(_timelineKey);
    notifyListeners();
  }

  void _addEvent({
    required String title,
    required String description,
    required String category,
  }) {
    _timeline.insert(
      0,
      TimelineEvent(
        time: DateTime.now(),
        title: title,
        description: description,
        category: category,
      ),
    );

    if (_timeline.length > _maxTimelineEvents) {
      _timeline.removeLast();
    }

    notifyListeners();
    _save();
  }
}