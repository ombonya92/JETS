import 'joseph_memory.dart';
import 'joseph_timeline_engine.dart';

class JosephLearningEngine {
  final JosephMemory memory;
final JosephTimelineEngine timeline;

JosephLearningEngine(
    this.memory,
    this.timeline);

  void observeQuestion(String question) {
    memory.rememberQuestion(question);

    final q = question.toLowerCase();

    if (q.contains("regression")) {
      memory.rememberWeakTopic("Regression");
    }

    if (q.contains("anova")) {
      memory.rememberWeakTopic("ANOVA");
    }

    if (q.contains("correlation")) {
      memory.rememberWeakTopic("Correlation");
    }

    if (q.contains("hypothesis")) {
      memory.rememberWeakTopic("Hypothesis Testing");
    }
  }

  void observeUpload({
    required String subject,
    required String fileName,
  }) {
    memory.rememberUpload(fileName);

    memory.rememberSubject(subject);
  }

  void observeQuiz({
    required String topic,
    required int score,
  }) {
    memory.profile.quizzesCompleted++;

    if (score >= 80) {
      memory.rememberStrongTopic(topic);
    } else {
      memory.rememberWeakTopic(topic);
    }
  }

  void observeStudySession(int minutes) {
    memory.profile.studyMinutes += minutes;
  }
}