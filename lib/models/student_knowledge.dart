class StudentKnowledge {
  /// Topic -> confidence (0–100)
  final Map<String, double> confidence = {};

  double confidenceOf(String topic) {
    return confidence[topic] ?? 0;
  }

  void increase(String topic, double amount) {
    final current = confidenceOf(topic);

    confidence[topic] =
        (current + amount).clamp(0, 100);
  }

  void decrease(String topic, double amount) {
    final current = confidenceOf(topic);

    confidence[topic] =
        (current - amount).clamp(0, 100);
  }

  List<String> weakestTopics() {
    final entries = confidence.entries.toList();

    entries.sort(
      (a, b) => a.value.compareTo(b.value),
    );

    return entries
        .take(5)
        .map((e) => e.key)
        .toList();
  }

  List<String> strongestTopics() {
    final entries = confidence.entries.toList();

    entries.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return entries
        .take(5)
        .map((e) => e.key)
        .toList();
  }

  bool contains(String topic) {
    return confidence.containsKey(topic);
  }

  void clear() {
    confidence.clear();
  }
}