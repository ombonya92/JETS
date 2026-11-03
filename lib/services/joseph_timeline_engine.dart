import '../models/timeline_event.dart';
import '../state/app_state.dart';

class JosephTimelineEngine {
  final AppState state;

  JosephTimelineEngine(this.state);

  List<TimelineEvent> get events => state.timeline;

  void uploadedFile(String fileName, String subject) {
    state.recordUpload(fileName, subject);
  }

  void askedQuestion(String question) {
    state.recordQuestion(question);
  }

  void completedQuiz(String topic, int score) {
    state.recordQuiz(topic, score);
  }

  void detectedWeakTopic(String topic) {
    state.recordWeakTopic(topic);
  }

  void detectedStrongTopic(String topic) {
    state.recordStrongTopic(topic);
  }

  void studySession(int minutes) {
    state.recordStudySession(minutes);
  }
}