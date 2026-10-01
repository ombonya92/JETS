import 'joseph_memory.dart';
import 'joseph_knowledge_graph.dart';

class JosephRecommendationEngine {
  final JosephMemory memory;
  final JosephKnowledgeGraph graph;

  JosephRecommendationEngine({
    required this.memory,
    required this.graph,
  });

  List<String> recommend() {
    final recommendations = <String>[];

    // Weak topics first
    for (final topic in memory.weakTopics) {
      recommendations.add(
        "Revise $topic",
      );

      final related =
          graph.relatedTopics(topic);

      for (final r in related.take(3)) {
        recommendations.add(
          "Review $r after mastering $topic",
        );
      }
    }

    // Encourage strengths
    for (final topic in memory.strongTopics.take(3)) {
      recommendations.add(
        "Keep practicing $topic",
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        "Upload notes to help Joseph understand your learning.",
      );
    }

    return recommendations.toSet().toList();
  }

  String nextAction() {
    if (memory.weakTopics.isNotEmpty) {
      return "Start with ${memory.weakTopics.first}.";
    }

    if (memory.uploadedFiles.isEmpty) {
      return "Upload your first academic document.";
    }

    return "Generate a revision quiz.";
  }
}