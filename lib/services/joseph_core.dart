import '../models/joseph_dashboard.dart';
import 'adaptive_engine.dart';
import 'joseph_learning_engine.dart';
import 'joseph_memory.dart';
import 'joseph_reasoning.dart';
import 'personality_engine.dart';
import 'prediction_engine.dart';
import 'joseph_timeline_engine.dart';

class JosephCore {
  final JosephMemory memory = JosephMemory();

  late final JosephLearningEngine learning =
      JosephLearningEngine(
  memory,
  JosephTimelineEngine(memory),
);

  late final AdaptiveEngine adaptive =
      AdaptiveEngine(memory);

  late final PredictionEngine prediction =
      PredictionEngine(memory);

  late final PersonalityEngine personality =
      PersonalityEngine(memory);

  late final JosephReasoning reasoning =
      JosephReasoning(memory);

  void askQuestion(String question) {
    learning.observeQuestion(question);
  }

  void uploadNotes({
    required String subject,
    required String fileName,
  }) {
    learning.observeUpload(
      subject: subject,
      fileName: fileName,
    );
  }

  void completeQuiz({
    required String topic,
    required int score,
  }) {
    learning.observeQuiz(
      topic: topic,
      score: score,
    );
  }

  void study(int minutes) {
    learning.observeStudySession(minutes);
  }

  JosephDashboard dashboard() {
    return JosephDashboard(
      studentName: memory.brain.studentName,

      intelligenceRank: intelligenceRank(),

      progress: intelligenceProgress(),

      learningLevel: memory.learningLevel(),

      learningStyle: learningStyle(),

      recommendation:
          adaptive.nextRecommendation(),

      insight:
          reasoning.generateInsight(),

      confidence:
          "${adaptive.confidenceScore().toStringAsFixed(0)}%",

      uploads: memory.profile.totalUploads,

      questions: memory.profile.totalQuestions,

      quizzes: memory.profile.quizzesCompleted,

      studyMinutes:
          memory.profile.studyMinutes,

      weakTopics:
          List.from(memory.weakTopics),

      strongTopics:
          List.from(memory.strongTopics),

      knowledge:
          Map.from(memory.knowledge.confidence),
    );
  }

  String intelligenceRank() {
    final score =
        adaptive.confidenceScore();

    if (score < 20) {
      return "Observer";
    }

    if (score < 40) {
      return "Learning Assistant";
    }

    if (score < 60) {
      return "Adaptive Tutor";
    }

    if (score < 80) {
      return "Academic Mentor";
    }

    return "Joseph AI";
  }

  double intelligenceProgress() {
    return adaptive.confidenceScore() / 100;
  }

  String learningStyle() {
    if (memory.profile.totalQuestions >
        memory.profile.totalUploads) {
      return "Question Driven";
    }

    if (memory.profile.totalUploads >
        memory.profile.totalQuestions) {
      return "Document Driven";
    }

    return "Balanced";
  }
}