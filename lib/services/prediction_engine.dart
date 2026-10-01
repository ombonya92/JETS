import 'joseph_memory.dart';

class PredictionEngine {
  final JosephMemory memory;

  PredictionEngine(this.memory);

  List<String> predictions() {
    final List<String> output = [];

    if (memory.weakTopics.isNotEmpty) {
      output.add(
          "You may struggle with ${memory.weakTopics.first} unless you revise it this week.");
    }

    if (memory.profile.totalUploads >= 10) {
      output.add(
          "You've uploaded enough material for me to generate a personalized revision schedule.");
    }

    if (memory.profile.totalQuestions >= 20) {
      output.add(
          "I now understand your questioning pattern and can recommend targeted quizzes.");
    }

    if (memory.strongTopics.isNotEmpty) {
      output.add(
          "${memory.strongTopics.first} appears to be one of your strongest subjects.");
    }

    if (output.isEmpty) {
      output.add(
          "I need more study data before making accurate predictions.");
    }

    return output;
  }
}