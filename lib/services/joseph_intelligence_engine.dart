import 'joseph_knowledge_graph.dart';
import 'joseph_memory.dart';

class JosephIntelligenceEngine {
  final JosephMemory memory;

  final JosephKnowledgeGraph graph;

  JosephIntelligenceEngine({
    required this.memory,
    required this.graph,
  });

  List<String> recommendations() {
    final recommendations = <String>[];

    for (final topic in memory.weakTopics) {
      recommendations.add(
        "Revise $topic",
      );

      recommendations.addAll(
        graph.relatedTopics(topic),
      );
    }

    return recommendations.toSet().toList();
  }

  List<String> predictedExamTopics() {
    final predictions = <String>[];

    for (final node in graph.nodes) {
      if (node.frequency >= 2 &&
          node.confidence >= 40) {
        predictions.add(node.name);
      }
    }

    return predictions;
  }

  String insight() {
    if (memory.weakTopics.isEmpty) {
      return "You are improving consistently.";
    }

    final topic = memory.weakTopics.first;

    final related =
        graph.relatedTopics(topic);

    if (related.isEmpty) {
      return
          "Focus on $topic before moving to new material.";
    }

    return
        "Improving $topic will also strengthen ${related.take(3).join(", ")}.";
  }
}