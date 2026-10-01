class JosephBrain {
  String studentName;

  int uploadedDocuments;

  int questionsAsked;

  int quizzesGenerated;

  int studyMinutes;

  final Map<String, int> topicFrequency;

  final Map<String, double> topicConfidence;

  final List<String> weakTopics;

  final List<String> strongTopics;

  final List<String> recentActivities;

  JosephBrain({
    required this.studentName,
    this.uploadedDocuments = 0,
    this.questionsAsked = 0,
    this.quizzesGenerated = 0,
    this.studyMinutes = 0,
    Map<String, int>? topicFrequency,
    Map<String, double>? topicConfidence,
    List<String>? weakTopics,
    List<String>? strongTopics,
    List<String>? recentActivities,
  })  : topicFrequency = topicFrequency ?? {},
        topicConfidence = topicConfidence ?? {},
        weakTopics = weakTopics ?? [],
        strongTopics = strongTopics ?? [],
        recentActivities = recentActivities ?? [];

  void addActivity(String activity) {
    recentActivities.insert(0, activity);

    if (recentActivities.length > 50) {
      recentActivities.removeLast();
    }
  }
}