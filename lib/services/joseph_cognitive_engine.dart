import 'academic_knowledge_engine.dart';
import 'adaptive_engine.dart';
import 'joseph_document_engine.dart';
import 'joseph_learning_engine.dart';
import 'joseph_memory.dart';
import 'joseph_reasoning.dart';
import 'personality_engine.dart';
import 'prediction_engine.dart';
import 'joseph_quiz_engine.dart';

class JosephCognitiveEngine {
  final JosephMemory memory;
  final AdaptiveEngine adaptive;
  final PredictionEngine prediction;
  final PersonalityEngine personality;
  final JosephReasoning reasoning;
  final JosephLearningEngine learning;

  final AcademicKnowledgeEngine knowledge =
      AcademicKnowledgeEngine();

  final JosephQuizEngine quiz =
      const JosephQuizEngine();

  final JosephDocumentEngine documents =
      const JosephDocumentEngine();

  JosephCognitiveEngine({
    required this.memory,
    required this.adaptive,
    required this.prediction,
    required this.personality,
    required this.reasoning,
    required this.learning,
  });

  Map<String, dynamic> think() {
    return {
      "greeting": personality.greeting(),
      "learningLevel": memory.learningLevel(),
      "recommendation": adaptive.nextRecommendation(),
      "prediction": prediction.predictions(),
      "insight": reasoning.generateInsight(),
      "confidence": adaptive.confidenceScore(),
      "weakTopics": memory.weakTopics,
      "strongTopics": memory.strongTopics,
    };
  }

  String respond(String question) {
    learning.observeQuestion(question);

    final q = question.toLowerCase();

    // ─────────────────────────────
    // DOCUMENT ACTIONS
    // ─────────────────────────────

    if (q.contains("uploaded document:")) {
      final fileName = _extractValue(
        question,
        "Uploaded document:",
      );

      final documentText =
          _extractDocumentText(question);

      if (q.contains("summarize again") ||
          q.contains("summary")) {
        return documents.summarize(
          fileName: fileName,
          text: documentText,
        );
      }

      if (q.contains("important topics")) {
        return documents.importantTopics(
          text: documentText,
        );
      }

      if (q.contains("generate questions")) {
        return documents.generateQuestions(
          text: documentText,
        );
      }

      if (q.contains("exam prediction") ||
          q.contains("possible exam")) {
        return documents.examPrediction(
          text: documentText,
        );
      }

      if (q.contains("study plan")) {
        return documents.studyPlan(
          text: documentText,
        );
      }

      if (q.contains("revision notes")) {
        return documents.revisionNotes(
          text: documentText,
        );
      }
    }

    // ─────────────────────────────
    // GENERAL ACADEMIC KNOWLEDGE
    // ─────────────────────────────

    final academic = knowledge.answer(question);

    if (academic != null) {
      return """
💡 Answer

$academic

──────────────────

🧠 Joseph's Advice

Understanding the idea is more important than memorising it.

Ask me:
• Explain further
• Give examples
• Generate quiz
• Exam tips
""";
    }

    // ─────────────────────────────
    // GREETING
    // ─────────────────────────────

    if (q.contains("hello") ||
        q.contains("hi") ||
        q.contains("hey")) {
      return "${personality.greeting()}\n\nHow can I help you today?";
    }

    // ─────────────────────────────
    // STUDY
    // ─────────────────────────────

    if (q.contains("study") ||
        q.contains("recommend")) {
      return adaptive.nextRecommendation();
    }

    // ─────────────────────────────
    // WEAK TOPICS
    // ─────────────────────────────

    if (q.contains("weak")) {
      if (memory.weakTopics.isEmpty) {
        return "I haven't identified your weak topics yet.";
      }

      return "Weak Topics:\n• ${memory.weakTopics.join("\n• ")}";
    }

    // ─────────────────────────────
    // STRONG TOPICS
    // ─────────────────────────────

    if (q.contains("strong")) {
      if (memory.strongTopics.isEmpty) {
        return "You haven't mastered any topics yet.";
      }

      return "Strong Topics:\n• ${memory.strongTopics.join("\n• ")}";
    }

    // ─────────────────────────────
    // PROGRESS
    // ─────────────────────────────

    if (q.contains("progress")) {
      return """
Learning Level: ${memory.learningLevel()}

Uploads: ${memory.profile.totalUploads}

Questions: ${memory.profile.totalQuestions}

Quizzes: ${memory.profile.quizzesCompleted}

Study Minutes: ${memory.profile.studyMinutes}
""";
    }

    // ─────────────────────────────
    // PREDICTION
    // ─────────────────────────────

    if (q.contains("predict")) {
      return prediction.predictions().join("\n");
    }

    // ─────────────────────────────
    // QUIZ
    // ─────────────────────────────

    if (q.contains("quiz")) {
      final topic =
          question.replaceAll(
        RegExp("quiz", caseSensitive: false),
        "",
      ).trim();

      final questions = quiz.generate(topic);

      final buffer = StringBuffer();

      buffer.writeln("📝 Quiz on $topic\n");

      for (int i = 0; i < questions.length; i++) {
        final quizQuestion = questions[i];

        buffer.writeln(
          "${i + 1}. ${quizQuestion["question"]}",
        );

        final options =
            quizQuestion["options"] as List;

        for (int j = 0; j < options.length; j++) {
          buffer.writeln(
            "   ${String.fromCharCode(65 + j)}. ${options[j]}",
          );
        }

        buffer.writeln();
      }

      return buffer.toString();
    }

    // ─────────────────────────────
    // UNKNOWN QUESTION
    // ─────────────────────────────

    return """
I don't know that topic yet.

Try asking things like:

• ANOVA
• Regression
• Python
• Flutter
• Photosynthesis
• Newton's Laws
• Epidemiology
""";
  }

  String _extractValue(
    String text,
    String label,
  ) {
    final start = text.indexOf(label);

    if (start == -1) {
      return "Uploaded Document";
    }

    final value =
        text.substring(start + label.length);

    final end =
        value.indexOf("\n");

    if (end == -1) {
      return value.trim();
    }

    return value.substring(0, end).trim();
  }

  String _extractDocumentText(String text) {
    const marker = "Full document content:";

    final start = text.indexOf(marker);

    if (start == -1) {
      return "";
    }

    return text
        .substring(start + marker.length)
        .trim();
  }

  void observeQuestion(String question) {
    learning.observeQuestion(question);
  }

  void observeUpload({
    required String subject,
    required String fileName,
  }) {
    learning.observeUpload(
      subject: subject,
      fileName: fileName,
    );
  }

  void observeQuiz({
    required String topic,
    required int score,
  }) {
    learning.observeQuiz(
      topic: topic,
      score: score,
    );
  }

  void observeStudySession(int minutes) {
    learning.observeStudySession(minutes);
  }
}