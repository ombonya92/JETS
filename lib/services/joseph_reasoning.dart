import 'joseph_memory.dart';

class JosephReasoning {
  final JosephMemory memory;

  JosephReasoning(this.memory);

  String generateInsight() {
    if (memory.weakTopics.length >= 3) {
      return "I've noticed several recurring weak topics. We should build a personalized revision plan.";
    }

    if (memory.profile.totalQuestions > 30) {
      return "You've been asking many questions. I understand your learning style much better now.";
    }

    if (memory.profile.totalUploads > 10) {
      return "I've analyzed many of your notes. My recommendations are becoming more personalized.";
    }

    return "I'm still learning how you study. Every upload and question helps me improve.";
  }

  bool readyForPrediction() {
    return memory.profile.totalUploads >= 5 &&
        memory.profile.totalQuestions >= 10;
  }
}