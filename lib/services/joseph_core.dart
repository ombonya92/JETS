import 'package:jets/models/document_record.dart';
import 'package:jets/services/adaptive_engine.dart';
import 'package:jets/services/joseph_learning_engine.dart';
import 'package:jets/services/joseph_memory.dart';
import 'package:jets/services/joseph_reasoning.dart';
import 'package:jets/services/joseph_timeline_engine.dart';
import 'package:jets/services/personality_engine.dart';
import 'package:jets/services/prediction_engine.dart';
import 'package:jets/state/app_state.dart';

// Lightweight facade kept for backward compatibility.
// New code should use AppController directly.
class JosephCore {
  final JosephMemory memory;
  final AppState state;

  late final JosephTimelineEngine timeline = JosephTimelineEngine(state);
  late final JosephLearningEngine learning = JosephLearningEngine(memory, timeline);
  late final AdaptiveEngine adaptive = AdaptiveEngine(memory);
  late final PredictionEngine prediction = PredictionEngine(memory);
  late final PersonalityEngine personality = PersonalityEngine(memory);
  late final JosephReasoning reasoning = JosephReasoning(memory);

  JosephCore({required this.memory, required this.state});

  void askQuestion(String question) => learning.observeQuestion(question);

  Future<void> uploadNotes(DocumentRecord record) =>
      learning.observeUpload(record);

  void completeQuiz({required String topic, required int score}) =>
      learning.observeQuiz(topic: topic, score: score);

  void study(int minutes) => learning.observeStudySession(minutes);
}