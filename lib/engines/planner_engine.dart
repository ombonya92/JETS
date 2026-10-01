class StudyPlan {
  final String title;
  final String day;
  final String time;
  final String priority;

  StudyPlan({
    required this.title,
    required this.day,
    required this.time,
    required this.priority,
  });
}

class PlannerEngine {
  List<StudyPlan> buildPlan({
    required List<String> weakTopics,
    required List<String> strongTopics,
    required int studyHoursPerWeek,
  }) {
    List<StudyPlan> plan = [];

    int sessions = studyHoursPerWeek;

    // Weak topics receive highest priority.
    for (String topic in weakTopics) {
      if (sessions <= 0) break;

      plan.add(
        StudyPlan(
          title: topic,
          day: _nextDay(plan.length),
          time: "7:00 PM - 8:00 PM",
          priority: "High",
        ),
      );

      sessions--;
    }

    // Strong topics are scheduled for revision.
    for (String topic in strongTopics) {
      if (sessions <= 0) break;

      plan.add(
        StudyPlan(
          title: "$topic Revision",
          day: _nextDay(plan.length),
          time: "7:00 PM - 8:00 PM",
          priority: "Medium",
        ),
      );

      sessions--;
    }

    // Fill remaining sessions with independent study.
    while (sessions > 0) {
      plan.add(
        StudyPlan(
          title: "General Revision",
          day: _nextDay(plan.length),
          time: "7:00 PM - 8:00 PM",
          priority: "Normal",
        ),
      );

      sessions--;
    }

    return plan;
  }

  String _nextDay(int index) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    return days[index % days.length];
  }
}