import '../engines/analytics_engine.dart';
import '../engines/planner_engine.dart';
import '../engines/quiz_engine.dart';
import '../engines/upload_engine.dart';
import 'repositories/student_repositories.dart';

class JosephService {
  final UploadEngine uploadEngine = UploadEngine();

  final QuizEngine quizEngine = QuizEngine();

  final PlannerEngine plannerEngine = PlannerEngine();

  final AnalyticsEngine analyticsEngine = AnalyticsEngine();

  final StudentRepository repository = StudentRepository();

  String greetStudent() {
    return "Hello ${repository.studentName}. How can I help you study today?";
  }

  void recordUpload(String fileName) {
    repository.addFile(fileName);

    analyticsEngine.recordUpload();
  }

  List<QuizQuestion> createQuiz({
    int questions = 5,
    String? difficulty,
  }) {
    analyticsEngine.recordQuiz();

    return quizEngine.generateQuiz(
      numberOfQuestions: questions,
      difficulty: difficulty,
    );
  }

  List<StudyPlan> createStudyPlan({
    required int studyHours,
  }) {
    return plannerEngine.buildPlan(
      weakTopics: analyticsEngine.weakTopics,
      strongTopics: analyticsEngine.strongTopics,
      studyHoursPerWeek: studyHours,
    );
  }

  void completeStudySession(int minutes) {
    analyticsEngine.recordStudySession(minutes);
  }

  void markWeakTopic(String topic) {
    analyticsEngine.addWeakTopic(topic);

    repository.addWeakTopic(topic);
  }

  void markStrongTopic(String topic) {
    analyticsEngine.addStrongTopic(topic);

    repository.addStrongTopic(topic);
  }

  Map<String, dynamic> dashboardData() {
    return analyticsEngine.dashboardStatistics();
  }

  List<String> recommendations() {
    return analyticsEngine.recommendations();
  }

  String analyseFileType(String extension) {
    switch (extension.toLowerCase()) {
      case "pdf":
        return "PDF detected. I'll prepare to extract text, identify topics, summarize the material and generate revision questions.";

      case "doc":
      case "docx":
        return "Word document detected. I'll organize headings, concepts and important definitions.";

      case "ppt":
      case "pptx":
        return "Presentation detected. I'll convert your slides into revision notes.";

      case "jpg":
      case "jpeg":
      case "png":
        return "Image detected. OCR support will allow me to read printed and handwritten notes.";

      default:
        return "This file type isn't supported yet.";
    }
  }
}