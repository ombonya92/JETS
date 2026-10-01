import '../models/joseph_brain.dart';
import '../models/joseph_learning_profile.dart';
import '../models/student_knowledge.dart';

class JosephMemory {
  static final JosephMemory instance =
      JosephMemory._internal();

  factory JosephMemory() => instance;

  JosephMemory._internal();

  // -----------------------------
  // Brain
  // -----------------------------

  final JosephBrain brain = JosephBrain(
    studentName: "Hanley",
  );

  // -----------------------------
  // Learning Profile
  // -----------------------------

  final JosephLearningProfile profile =
      JosephLearningProfile();

  // -----------------------------
  // Student Knowledge Model
  // -----------------------------

  final StudentKnowledge knowledge =
      StudentKnowledge();

  // -----------------------------
  // Memory Collections
  // -----------------------------

  final List<String> previousQuestions = [];

  final List<String> uploadedFiles = [];

  final List<String> subjects = [];

  final List<String> weakTopics = [];

  final List<String> strongTopics = [];

  // -----------------------------
  // Remember Question
  // -----------------------------

  void rememberQuestion(String question) {
    previousQuestions.add(question);

    profile.totalQuestions++;

    brain.questionsAsked++;

    brain.addActivity(
      "Question asked: $question",
    );
  }

  // -----------------------------
  // Remember Upload
  // -----------------------------

  void rememberUpload(String file) {
    uploadedFiles.add(file);

    profile.totalUploads++;

    brain.uploadedDocuments++;

    brain.addActivity(
      "Uploaded $file",
    );
  }

  // -----------------------------
  // Remember Subject
  // -----------------------------

  void rememberSubject(String subject) {
    if (!subjects.contains(subject)) {
      subjects.add(subject);
    }

    profile.favoriteSubject = subject;

    brain.topicFrequency.update(
      subject,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  // -----------------------------
  // Weak Topic
  // -----------------------------

 void rememberWeakTopic(String topic) {
  if (!weakTopics.contains(topic)) {
    weakTopics.add(topic);
  }

  strongTopics.remove(topic);

  if (!brain.weakTopics.contains(topic)) {
    brain.weakTopics.add(topic);
  }

  brain.strongTopics.remove(topic);

  knowledge.decrease(topic, 5);

  brain.topicConfidence[topic] =
      knowledge.confidenceOf(topic);

  brain.addActivity(
    "Weak topic detected: $topic",
  );
}

  // -----------------------------
  // Strong Topic
  // -----------------------------

  void rememberStrongTopic(String topic) {
  if (!strongTopics.contains(topic)) {
    strongTopics.add(topic);
  }

  weakTopics.remove(topic);

  if (!brain.strongTopics.contains(topic)) {
    brain.strongTopics.add(topic);
  }

  brain.weakTopics.remove(topic);

  knowledge.increase(topic, 5);

  brain.topicConfidence[topic] =
      knowledge.confidenceOf(topic);

  brain.addActivity(
    "Mastered topic: $topic",
  );
}

  // -----------------------------
  // Quiz Completed
  // -----------------------------

  void completeQuiz() {
    profile.quizzesCompleted++;

    brain.quizzesGenerated++;
  }

  // -----------------------------
  // Study Session
  // -----------------------------

  void study(int minutes) {
    profile.studyMinutes += minutes;

    brain.studyMinutes += minutes;
  }

  // -----------------------------
  // Joseph Learning Level
  // -----------------------------

  String learningLevel() {

    final interactions =
        profile.totalUploads +
        profile.totalQuestions +
        profile.quizzesCompleted;

    if (interactions < 10) {
      return "Learning You";
    }

    if (interactions < 40) {
      return "Understanding You";
    }

    if (interactions < 80) {
      return "Adapting";
    }

    if (interactions < 150) {
      return "Academic Mentor";
    }

    return "Personal Tutor";
  }
}