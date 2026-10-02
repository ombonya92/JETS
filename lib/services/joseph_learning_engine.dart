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
    timeline.askedQuestion(question);

    for (final entry in _trackedTopics.entries) {
      if (TextMatcher.containsTerm(question, entry.key)) {
        _flagWeakTopic(entry.value);
      }
    }
  }

  void observeUpload({
    required String subject,
    required String fileName,
  }) {
    memory.rememberUpload(fileName);
    memory.rememberSubject(subject);
    timeline.uploadedFile(fileName);
  }

  void observeQuiz({
    required String topic,
    required int score,
  }) {
    memory.profile.quizzesCompleted++;
    timeline.completedQuiz(topic, score);

    if (score >= _masteryScore) {
      _flagStrongTopic(topic);
    } else {
      _flagWeakTopic(topic);
    }
  }

  void observeStudySession(int minutes) {
    memory.profile.studyMinutes += minutes;
    timeline.studySession(minutes);
  }

  void _flagWeakTopic(String topic) {
    final isNew = !memory.weakTopics.contains(topic);

    memory.rememberWeakTopic(topic);

    if (isNew) {
      timeline.detectedWeakTopic(topic);
    }
  }

  void _flagStrongTopic(String topic) {
    final isNew = !memory.strongTopics.contains(topic);

    memory.rememberStrongTopic(topic);

    if (isNew) {
      timeline.detectedStrongTopic(topic);
    }
  }
}