import '../models/document_record.dart';
import '../state/app_state.dart';
import '../utils/text_matcher.dart';
import 'joseph_memory.dart';
import 'joseph_timeline_engine.dart';

class JosephLearningEngine {
  final JosephMemory memory;
  final JosephTimelineEngine timeline;

  JosephLearningEngine(this.memory, this.timeline);

  static const int _masteryScore = 80;

  static const Map<String, String> _trackedTopics = {
    'regression': 'Regression',
    'anova': 'ANOVA',
    'correlation': 'Correlation',
    'hypothesis': 'Hypothesis Testing',
  };

  void observeQuestion(String question) {
    memory.rememberQuestion(question);

    for (final entry in _trackedTopics.entries) {
      if (TextMatcher.containsTerm(question, entry.key)) {
        _markWeak(entry.value);
      }
    }
  }

  Future<void> observeUpload(DocumentRecord record) async {
    memory.rememberUpload(record.fileName);
    for (final subject in record.subjects) {
      memory.rememberSubject(subject);
    }
    await timeline.uploadedFile(record);
  }

  void observeQuiz({required String topic, required int score}) {
    memory.profile.quizzesCompleted++;
    timeline.completedQuiz(topic, score);

    if (score >= _masteryScore) {
      _markStrong(topic);
    } else {
      _markWeak(topic);
    }
  }

  void observeStudySession(int minutes) {
    memory.profile.studyMinutes += minutes;
    timeline.studySession(minutes);
  }

  void _markWeak(String topic) {
    if (memory.weakTopics.contains(topic)) return;
    memory.rememberWeakTopic(topic);
  }

  void _markStrong(String topic) {
    if (memory.strongTopics.contains(topic)) return;
    memory.rememberStrongTopic(topic);
  }
}