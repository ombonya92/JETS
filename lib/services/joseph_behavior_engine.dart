import 'joseph_memory.dart';

class JosephBehaviorEngine {
  final JosephMemory memory;

  JosephBehaviorEngine(this.memory);

  String preferredStudyStyle() {
    if (memory.profile.totalQuestions >
        memory.profile.totalUploads) {
      return "Question-Based Learning";
    }

    if (memory.profile.totalUploads >
        memory.profile.totalQuestions) {
      return "Document-Based Learning";
    }

    return "Balanced Learning";
  }

  String studyCommitment() {
    final minutes = memory.profile.studyMinutes;

    if (minutes < 60) {
      return "Low";
    }

    if (minutes < 300) {
      return "Moderate";
    }

    return "High";
  }

  String strongestArea() {
    if (memory.strongTopics.isEmpty) {
      return "Still Learning";
    }

    return memory.strongTopics.first;
  }

  String weakestArea() {
    if (memory.weakTopics.isEmpty) {
      return "Unknown";
    }

    return memory.weakTopics.first;
  }

  bool isConsistentLearner() {
    return memory.profile.studyMinutes > 300 &&
        memory.profile.totalQuestions > 20;
  }
}