class JosephDashboard {
  final String studentName;

  final String intelligenceRank;

  final double progress;

  final String learningLevel;

  final String learningStyle;

  final String recommendation;

  final String insight;

  final String confidence;

  final int uploads;

  final int questions;

  final int quizzes;

  final int studyMinutes;

  final List<String> weakTopics;

  final List<String> strongTopics;

  final Map<String, double> knowledge;

  const JosephDashboard({
    required this.studentName,
    required this.intelligenceRank,
    required this.progress,
    required this.learningLevel,
    required this.learningStyle,
    required this.recommendation,
    required this.insight,
    required this.confidence,
    required this.uploads,
    required this.questions,
    required this.quizzes,
    required this.studyMinutes,
    required this.weakTopics,
    required this.strongTopics,
    required this.knowledge,
  });
}