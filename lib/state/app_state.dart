import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/document_record.dart';
import '../models/student_progress.dart';
import '../models/study_task.dart';
import '../models/timeline_event.dart';

class AppState extends ChangeNotifier {
  static const String _progressKey = 'student_progress';
  static const String _timelineKey = 'timeline_events';
  static const String _documentsKey = 'documents';
  static const String _tasksKey = 'study_tasks';
  static const int _maxTimelineEvents = 100;

  StudentProgress _progress = StudentProgress();
  final List<TimelineEvent> _timeline = [];
  final List<DocumentRecord> _documents = [];
  final List<StudyTask> _tasks = [];

  bool _loaded = false;

  StudentProgress get progress => _progress;
  List<TimelineEvent> get timeline => List.unmodifiable(_timeline);
  List<DocumentRecord> get documents => List.unmodifiable(_documents);
  List<StudyTask> get tasks => List.unmodifiable(_tasks);
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

    final docsJson = prefs.getString(_documentsKey);
    if (docsJson != null) {
      final list = jsonDecode(docsJson) as List;
      _documents.addAll(
        list.map((e) => DocumentRecord.fromJson(e as Map<String, dynamic>)),
      );
    }

    final tasksJson = prefs.getString(_tasksKey);
    if (tasksJson != null) {
      final list = jsonDecode(tasksJson) as List;
      _tasks.addAll(
        list.map((e) => StudyTask.fromJson(e as Map<String, dynamic>)),
      );
    }

    _loaded = true;
    notifyListeners();
  }

  // --- document CRUD ---

  Future<void> addDocument(DocumentRecord doc) async {
    _documents.insert(0, doc);
    _progress.totalUploads++;

    if (!_progress.uploadedFiles.contains(doc.fileName)) {
      _progress.uploadedFiles.add(doc.fileName);
    }

    for (final subject in doc.subjects) {
      if (!_progress.subjects.contains(subject)) {
        _progress.subjects.add(subject);
      }
    }

    _addEvent(
      title: 'Uploaded Notes',
      description: doc.fileName,
      category: 'Upload',
    );
  }

  Future<void> updateDocument(DocumentRecord updated) async {
    final index = _documents.indexWhere((d) => d.id == updated.id);
    if (index == -1) return;
    _documents[index] = updated;
    await _persist();
    notifyListeners();
  }

  Future<void> deleteDocument(String id) async {
    final doc = _documents.firstWhere(
      (d) => d.id == id,
      orElse: () => throw StateError('Document not found'),
    );
    _documents.removeWhere((d) => d.id == id);
    _progress.uploadedFiles.remove(doc.fileName);
    _progress.totalUploads =
        (_progress.totalUploads - 1).clamp(0, double.maxFinite).toInt();
    await _persist();
    notifyListeners();
  }

  // --- task CRUD ---

  Future<void> addTask(StudyTask task) async {
    _tasks.insert(0, task);
    _addEvent(
      title: 'Task Added',
      description: task.title,
      category: 'Task',
    );
  }

  Future<void> updateTask(StudyTask updated) async {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;
    _tasks[index] = updated;
    await _persist();
    notifyListeners();
  }

  Future<void> completeTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(completed: true);
    _addEvent(
      title: 'Task Completed',
      description: _tasks[index].title,
      category: 'Task',
    );
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _persist();
    notifyListeners();
  }

  // --- progress ---

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
    _documents.clear();
    _tasks.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
    await prefs.remove(_timelineKey);
    await prefs.remove(_documentsKey);
    await prefs.remove(_tasksKey);
    notifyListeners();
  }

  static String generateId() {
    final rng = Random.secure();
    return List.generate(16, (_) => rng.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
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
    _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_progressKey, jsonEncode(_progress.toJson())),
      prefs.setString(
        _timelineKey,
        jsonEncode(_timeline.map((e) => e.toJson()).toList()),
      ),
      prefs.setString(
        _documentsKey,
        jsonEncode(_documents.map((e) => e.toJson()).toList()),
      ),
      prefs.setString(
        _tasksKey,
        jsonEncode(_tasks.map((e) => e.toJson()).toList()),
      ),
    ]);
  }
}