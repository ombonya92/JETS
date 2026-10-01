import 'joseph_memory.dart';

class JosephGrowthEngine {
  final JosephMemory memory;

  JosephGrowthEngine(this.memory);

  int intelligenceLevel() {
    int score = 0;

    score += memory.profile.totalUploads;
    score += memory.profile.totalQuestions;
    score += memory.profile.quizzesCompleted * 2;
    score += memory.profile.studyMinutes ~/ 30;

    return score;
  }

  String currentRank() {
    final level = intelligenceLevel();

    if (level < 20) {
      return "Observer";
    }

    if (level < 50) {
      return "Learner";
    }

    if (level < 100) {
      return "Study Coach";
    }

    if (level < 200) {
      return "Adaptive Tutor";
    }

    if (level < 350) {
      return "Academic Mentor";
    }

    return "Personal AI Scholar";
  }

  double progressToNextLevel() {
    final level = intelligenceLevel();

    if (level < 20) return level / 20;

    if (level < 50) return (level - 20) / 30;

    if (level < 100) return (level - 50) / 50;

    if (level < 200) return (level - 100) / 100;

    if (level < 350) return (level - 200) / 150;

    return 1;
  }

  String description() {
    switch (currentRank()) {
      case "Observer":
        return "I am learning about your study habits.";

      case "Learner":
        return "I understand your subjects and questions.";

      case "Study Coach":
        return "I can recommend personalized revision plans.";

      case "Adaptive Tutor":
        return "I adapt to your strengths and weaknesses automatically.";

      case "Academic Mentor":
        return "I predict your academic needs before you ask.";

      default:
        return "I have grown into your long-term AI academic companion.";
    }
  }
}