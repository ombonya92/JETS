import '../models/document_record.dart';
import '../state/app_state.dart';

class JosephTimelineEngine {
  final AppState state;

  JosephTimelineEngine(this.state);

  List<dynamic> get events => state.timeline;

  Future<void> uploadedFile(DocumentRecord record) async {
    await state.addDocument(record);
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