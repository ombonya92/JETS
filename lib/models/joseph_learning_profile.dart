class JosephLearningProfile {
  // STUDENT LEARNING STATISTICS
  int totalUploads;
  int totalQuestions;
  int quizzesCompleted;
  int studyMinutes;

  // SUBJECT INFORMATION
  String favoriteSubject;

  // MEMORY
  final List<String> weakTopics;
  final List<String> strongTopics;
  final List<String> uploadedFiles;
  final List<String> previousQuestions;
  final List<String> studiedSubjects;

  // AI LEARNING
  int recommendationsAccepted;
  int predictionsMade;
  double confidenceScore;

  // GROWTH STAGE
  String learningStage;

  JosephLearningProfile({
    this.totalUploads = 0,
    this.totalQuestions = 0,
    this.quizzesCompleted = 0,
    this.studyMinutes = 0,
    this.favoriteSubject = "",
    List<String>? weakTopics,
    List<String>? strongTopics,
    List<String>? uploadedFiles,
    List<String>? previousQuestions,
    List<String>? studiedSubjects,
    this.recommendationsAccepted = 0,
    this.predictionsMade = 0,
    this.confidenceScore = 0,
    this.learningStage = "New Student",
  })  : weakTopics = weakTopics ?? [],
        strongTopics = strongTopics ?? [],
        uploadedFiles = uploadedFiles ?? [],
        previousQuestions = previousQuestions ?? [],
        studiedSubjects = studiedSubjects ?? [];

  void updateLearningStage() {
    int interactions =
        totalUploads +
        totalQuestions +
        quizzesCompleted;

    if (interactions < 10) {
      learningStage = "New Student";
    } else if (interactions < 30) {
      learningStage = "Learning You";
    } else if (interactions < 60) {
      learningStage = "Understanding You";
    } else if (interactions < 100) {
      learningStage = "Adaptive Tutor";
    } else {
      learningStage = "Personal Academic Mentor";
    }
  }
}