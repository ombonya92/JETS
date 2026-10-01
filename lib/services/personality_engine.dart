import 'joseph_memory.dart';

class PersonalityEngine {
  final JosephMemory memory;

  PersonalityEngine(this.memory);

  String greeting() {
    final name = memory.brain.studentName;

    if (memory.profile.totalQuestions == 0 &&
        memory.profile.totalUploads == 0) {
      return "Hello $name! I'm Joseph. I'm ready to start learning with you.";
    }

    if (memory.profile.totalUploads > 20) {
      return "Welcome back $name! I've learned a lot about how you study.";
    }

    if (memory.profile.totalQuestions > 50) {
      return "Good to see you again $name. Every question helps me understand you better.";
    }

    return "Welcome back $name. Let's continue learning together.";
  }

  String encouragement() {
    if (memory.weakTopics.isNotEmpty) {
      return "Don't worry about ${memory.weakTopics.first}. We'll master it together.";
    }

    if (memory.strongTopics.isNotEmpty) {
      return "Excellent work! ${memory.strongTopics.first} is becoming one of your strengths.";
    }

    return "Keep learning consistently. Every interaction helps me become a better tutor.";
  }

  String status() {
    return memory.learningLevel();
  }
}