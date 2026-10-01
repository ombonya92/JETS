class StudentRepository {
  String studentName = "Hanley";

  final List<String> uploadedFiles = [];

  final List<String> completedTopics = [];

  final List<String> weakTopics = [];

  final List<String> strongTopics = [];

  void addFile(String file) {
    uploadedFiles.add(file);
  }

  void completeTopic(String topic) {
    completedTopics.add(topic);
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

  int totalUploads() {
    return uploadedFiles.length;
  }

  int totalCompletedTopics() {
    return completedTopics.length;
  }

  List<String> recommendations() {
    if (weakTopics.isEmpty) {
      return [
        "Keep studying consistently.",
        "Upload more notes for deeper analysis."
      ];
    }

    return weakTopics
        .map((topic) => "Revise $topic")
        .toList();
  }
}