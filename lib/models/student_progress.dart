class StudentProgress {
  int totalUploads;
  int totalQuestions;
  int quizzesCompleted;
  int studyMinutes;
  String favoriteSubject;
  final List<String> weakTopics;
  final List<String> strongTopics;
  final List<String> uploadedFiles;
  final List<String> subjects;

  StudentProgress({
    this.totalUploads = 0,
    this.totalQuestions = 0,
    this.quizzesCompleted = 0,
    this.studyMinutes = 0,
    this.favoriteSubject = '',
    List<String>? weakTopics,
    List<String>? strongTopics,
    List<String>? uploadedFiles,
    List<String>? subjects,
  })  : weakTopics = weakTopics ?? [],
        strongTopics = strongTopics ?? [],
        uploadedFiles = uploadedFiles ?? [],
        subjects = subjects ?? [];

  factory StudentProgress.fromJson(Map<String, dynamic> json) {
    return StudentProgress(
      totalUploads: (json['totalUploads'] as int?) ?? 0,
      totalQuestions: (json['totalQuestions'] as int?) ?? 0,
      quizzesCompleted: (json['quizzesCompleted'] as int?) ?? 0,
      studyMinutes: (json['studyMinutes'] as int?) ?? 0,
      favoriteSubject: (json['favoriteSubject'] as String?) ?? '',
      weakTopics: List<String>.from(json['weakTopics'] as List? ?? []),
      strongTopics: List<String>.from(json['strongTopics'] as List? ?? []),
      uploadedFiles: List<String>.from(json['uploadedFiles'] as List? ?? []),
      subjects: List<String>.from(json['subjects'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUploads': totalUploads,
      'totalQuestions': totalQuestions,
      'quizzesCompleted': quizzesCompleted,
      'studyMinutes': studyMinutes,
      'favoriteSubject': favoriteSubject,
      'weakTopics': weakTopics,
      'strongTopics': strongTopics,
      'uploadedFiles': uploadedFiles,
      'subjects': subjects,
    };
  }

  int get totalInteractions => totalUploads + totalQuestions + quizzesCompleted;
}