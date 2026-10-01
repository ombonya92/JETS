import 'joseph_memory.dart';

class AdaptiveEngine {
  final JosephMemory memory;

  AdaptiveEngine(this.memory);

  String nextRecommendation() {
    if (memory.profile.totalUploads == 0) {
      return "Upload your first notes so I can begin learning how you study.";
    }

    if (memory.weakTopics.isNotEmpty) {
      return "Today's priority is ${memory.weakTopics.first}.";
    }

    if (memory.profile.quizzesCompleted < 3) {
      return "I recommend taking another quiz so I can better understand your strengths.";
    }

    if (memory.profile.favoriteSubject.isNotEmpty) {
      return "Let's continue improving your ${memory.profile.favoriteSubject} performance.";
    }

    return "Keep learning consistently. Every interaction helps me understand you better.";
  }

  double confidenceScore() {
    double score = 0;

    score += memory.profile.totalUploads * 4;

    score += memory.profile.totalQuestions * 2;

    score += memory.profile.quizzesCompleted * 5;

    if (score > 100) {
      score = 100;
    }

    return score;
  }
}