import '../models/joseph_brain.dart';
import '../models/student_knowledge.dart';
import '../models/student_progress.dart';
import '../state/app_state.dart';

class JosephMemory {
  static final JosephMemory instance = JosephMemory._internal();

  factory JosephMemory() => instance;

  JosephMemory._internal();

  AppState? _state;

  final JosephBrain brain = JosephBrain(studentName: 'Hanley');

  final StudentKnowledge knowledge = StudentKnowledge();

  void attach(AppState state) {
    _state = state;
  }

  StudentProgress get profile {
    assert(_state != null, 'JosephMemory.attach() must be called before use.');
    return _state!.progress;
  }

  List<String> get weakTopics => profile.weakTopics;

  List<String> get strongTopics => profile.strongTopics;

  List<String> get uploadedFiles => profile.uploadedFiles;

  List<String> get subjects => profile.subjects;

  void rememberQuestion(String question) {
    _state?.recordQuestion(question);
    brain.questionsAsked++;
    brain.addActivity('Question: $question');
  }

  void rememberUpload(String file) {
    brain.uploadedDocuments++;
    brain.addActivity('Uploaded: $file');
  }

  void rememberSubject(String subject) {
    brain.topicFrequency.update(
      subject,
      (v) => v + 1,
      ifAbsent: () => 1,
    );
  }

  void rememberWeakTopic(String topic) {
    _state?.recordWeakTopic(topic);
    knowledge.decrease(topic, 5);
    brain.topicConfidence[topic] = knowledge.confidenceOf(topic);
    brain.addActivity('Weak topic: $topic');
  }

  void rememberStrongTopic(String topic) {
    _state?.recordStrongTopic(topic);
    knowledge.increase(topic, 5);
    brain.topicConfidence[topic] = knowledge.confidenceOf(topic);
    brain.addActivity('Mastered: $topic');
  }

  String learningLevel() {
    return _state?.learningLevel() ?? 'Learning You';
  }
}