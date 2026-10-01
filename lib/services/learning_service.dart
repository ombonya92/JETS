import 'joseph_memory.dart';

class LearningService {
  final JosephMemory memory;

  LearningService(this.memory);

  void processQuestion(String question) {
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

  void processQuizResult({
    required String topic,
    required int score,
  }) {
    if (score >= 80) {
      memory.rememberStrongTopic(topic);
    } else {
      memory.rememberWeakTopic(topic);
    }
  }

  void processUpload({
    required String subject,
    required String fileName,
  }) {
    memory.rememberUpload(fileName);

    memory.rememberSubject(subject);
  }
}