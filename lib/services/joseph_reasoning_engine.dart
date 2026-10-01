import 'joseph_memory.dart';

class JosephReasoningEngine {
  final JosephMemory memory;

  JosephReasoningEngine(this.memory);

  String generateInsight() {
    if (memory.profile.totalUploads == 0) {
      return "I still don't know enough about your learning habits.";
    }

    if (memory.weakTopics.isNotEmpty &&
        memory.profile.quizzesCompleted == 0) {
      return "You have weak topics, but I need quiz results before making strong conclusions.";
    }

    if (memory.weakTopics.length >
        memory.strongTopics.length) {
      return "Most of your recent activity suggests you need more revision than assessment.";
    }

    if (memory.strongTopics.length >
        memory.weakTopics.length) {
      return "You appear to be improving steadily. It may be time to increase difficulty.";
    }

    return "Your learning profile is becoming balanced.";
  }

  String confidenceExplanation() {
    final uploads = memory.profile.totalUploads;
    final questions = memory.profile.totalQuestions;
    final quizzes = memory.profile.quizzesCompleted;

    if (uploads + questions + quizzes < 5) {
      return "Low confidence because I have limited information.";
    }

    if (uploads + questions + quizzes < 25) {
      return "Moderate confidence based on your recent activity.";
    }

    return "High confidence because I have learned your study behaviour over time.";
  }

  bool knowsStudentWell() {
    return memory.profile.totalUploads > 5 &&
        memory.profile.totalQuestions > 20 &&
        memory.profile.quizzesCompleted > 5;
  }
}