class KnowledgeNode {
  final String name;

  final Set<String> relatedTopics;

  int frequency;

  double confidence;

  KnowledgeNode({
    required this.name,
    Set<String>? relatedTopics,
    this.frequency = 0,
    this.confidence = 0,
  }) : relatedTopics = relatedTopics ?? {};

  void connect(String topic) {
    relatedTopics.add(topic);
  }

  void seen() {
    frequency++;
  }

  void improve(double amount) {
    confidence += amount;

    if (confidence > 100) {
      confidence = 100;
    }
  }

  void reduce(double amount) {
    confidence -= amount;

    if (confidence < 0) {
      confidence = 0;
    }
  }
}