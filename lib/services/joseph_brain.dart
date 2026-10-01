import 'joseph_memory.dart';

/// Compatibility layer.
/// JosephCore is now the real brain of Joseph.
/// This class simply exposes memory information in a clean way.
class JosephBrainService {
  final JosephMemory memory;

  JosephBrainService(this.memory);

  String greet() {
    return "Welcome back ${memory.brain.studentName}.";
  }

  List<String> recommendations() {
    if (memory.weakTopics.isNotEmpty) {
      return [
        "Revise ${memory.weakTopics.first}",
        "Generate a quiz on ${memory.weakTopics.first}",
      ];
    }

    if (memory.strongTopics.isNotEmpty) {
      return [
        "Challenge yourself with advanced ${memory.strongTopics.first} questions.",
      ];
    }

    return [
      "Upload notes so I can understand how you learn.",
    ];
  }

  int totalQuestions() {
    return memory.profile.totalQuestions;
  }

  int totalUploads() {
    return memory.profile.totalUploads;
  }

  String learningLevel() {
    return memory.learningLevel();
  }
}