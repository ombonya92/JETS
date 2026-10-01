class Recommendation {
  final String title;
  final String description;
  final String action;
  final int priority;

  Recommendation({
    required this.title,
    required this.description,
    required this.action,
    required this.priority,
  });
}

class RecommendationEngine {

  List<Recommendation> generateRecommendations({

    required bool uploadedNotes,
    required bool uploadedTimetable,
    required bool hasUpcomingExam,
    required bool quizScoreLow,

  }) {

    List<Recommendation> recommendations = [];

    if (!uploadedNotes) {
      recommendations.add(
        Recommendation(
          title: "Upload Notes",
          description: "Upload your lecture notes so Joseph can analyse them.",
          action: "upload_notes",
          priority: 1,
        ),
      );
    }

    if (!uploadedTimetable) {
      recommendations.add(
        Recommendation(
          title: "Upload Exam Timetable",
          description: "Joseph can automatically prepare your revision plan.",
          action: "upload_timetable",
          priority: 1,
        ),
      );
    }

    if (hasUpcomingExam) {
      recommendations.add(
        Recommendation(
          title: "Upcoming Exam",
          description: "Focus on your next examination first.",
          action: "study_plan",
          priority: 2,
        ),
      );
    }

    if (quizScoreLow) {
      recommendations.add(
        Recommendation(
          title: "Practice Quiz",
          description: "Your recent quiz score suggests more practice is needed.",
          action: "generate_quiz",
          priority: 3,
        ),
      );
    }

    recommendations.sort((a, b) => a.priority.compareTo(b.priority));

    return recommendations;
  }
}