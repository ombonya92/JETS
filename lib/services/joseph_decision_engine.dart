import 'joseph_memory.dart';

class JosephDecisionEngine {
  final JosephMemory memory;

  JosephDecisionEngine(this.memory);

  String todaysPriority() {
    if (memory.weakTopics.isNotEmpty) {
      return memory.weakTopics.first;
    }

    if (memory.profile.favoriteSubject.isNotEmpty) {
      return memory.profile.favoriteSubject;
    }

    return "General Revision";
  }

  String nextAction() {
    if (memory.profile.totalUploads == 0) {
      return "Upload notes so I can start learning how you study.";
    }

    if (memory.profile.quizzesCompleted == 0) {
      return "Take your first quiz.";
    }

    if (memory.weakTopics.isNotEmpty) {
      return "Revise ${memory.weakTopics.first}.";
    }

    if (memory.profile.studyMinutes < 60) {
      return "Increase study time today.";
    }

    return "Maintain your current study pace.";
  }

  bool shouldRecommendQuiz() {
    return memory.profile.quizzesCompleted < 5;
  }

  bool shouldRecommendRevision() {
    return memory.weakTopics.isNotEmpty;
  }

  bool shouldRecommendUpload() {
    return memory.profile.totalUploads < 3;
  }
}