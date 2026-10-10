import '../models/learning_event.dart';
import 'joseph_memory.dart';

class JosephTimelineEngine {
  final JosephMemory memory;

  final List<LearningEvent> _events = [];

  JosephTimelineEngine(this.memory);

  List<LearningEvent> get events => List.unmodifiable(_events);

  void record({
    required String title,
    required String description,
    required String category,
  }) {
    _events.insert(
      0,
      LearningEvent(
        time: DateTime.now(),
        title: title,
        description: description,
        category: category,
      ),
    );
  }

  void uploadedFile(String file) {
    record(
      title: 'Uploaded Notes',
      description: file,
      category: 'Upload',
    );
  }

  void askedQuestion(String question) {
    record(
      title: 'Asked Joseph',
      description: question,
      category: 'Question',
    );
  }

  void completedQuiz(String topic, int score) {
    record(
      title: 'Completed Quiz',
      description: '$topic - Score: $score%',
      category: 'Quiz',
    );
  }

  void detectedWeakTopic(String topic) {
    record(
      title: 'Weak Topic',
      description: topic,
      category: 'Learning',
    );
  }

  void detectedStrongTopic(String topic) {
    record(
      title: 'Mastered Topic',
      description: topic,
      category: 'Learning',
    );
  }

  void studySession(int minutes) {
    record(
      title: 'Study Session',
      description: '$minutes minutes',
      category: 'Study',
    );
  }
}