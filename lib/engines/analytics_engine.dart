class AnalyticsEngine {
  int totalUploads = 0;

  int totalQuizzes = 0;

  int totalStudySessions = 0;

  int totalMinutesStudied = 0;

  final List<String> weakTopics = [];

  final List<String> strongTopics = [];

  void recordUpload() {
    totalUploads++;
  }

  void recordQuiz() {
    totalQuizzes++;
  }

  void recordStudySession(int minutes) {
    totalStudySessions++;
    totalMinutesStudied += minutes;
  }

  void addWeakTopic(String topic) {
    if (!weakTopics.contains(topic)) {
      weakTopics.add(topic);
    }
  }

  void addStrongTopic(String topic) {
    if (!strongTopics.contains(topic)) {
      strongTopics.add(topic);
    }
  }

  String performanceLevel() {
    if (totalStudySessions >= 30) {
      return "Excellent";
    }

    if (totalStudySessions >= 20) {
      return "Very Good";
    }

    if (totalStudySessions >= 10) {
      return "Good";
    }

    if (totalStudySessions >= 5) {
      return "Fair";
    }

    return "Getting Started";
  }

  List<String> recommendations() {
    List<String> advice = [];

    if (weakTopics.isNotEmpty) {
      advice.add(
        "Focus on: ${weakTopics.join(", ")}",
      );
    }

    if (totalStudySessions < 5) {
      advice.add(
        "Increase your weekly study sessions.",
      );
    }

    if (totalUploads == 0) {
      advice.add(
        "Upload notes so Joseph can personalise your learning.",
      );
    }

    if (advice.isEmpty) {
      advice.add(
        "Excellent work! Keep maintaining your study routine.",
      );
    }

    return advice;
  }

  Map<String, dynamic> dashboardStatistics() {
    return {
      "uploads": totalUploads,
      "quizzes": totalQuizzes,
      "sessions": totalStudySessions,
      "minutes": totalMinutesStudied,
      "performance": performanceLevel(),
      "weakTopics": weakTopics,
      "strongTopics": strongTopics,
    };
  }
}