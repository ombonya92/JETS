import 'package:jets/services/joseph_knowledge_graph.dart';
import 'package:jets/services/joseph_memory.dart';

class JosephIntelligenceEngine {
  final JosephMemory memory;
  final JosephKnowledgeGraph graph;

  JosephIntelligenceEngine({required this.memory, required this.graph});

  List<String> recommendations() {
    final results = <String>[];
    for (final topic in memory.weakTopics) {
      results.add('Revise $topic');
      results.addAll(graph.relatedTopics(topic));
    }
    return results.toSet().toList();
  }

  List<String> predictedExamTopics() {
    return graph.nodes
        .where((n) => n.frequency >= 2 && n.confidence >= 40)
        .map((n) => n.name)
        .toList();
  }

  String insight() {
    if (memory.weakTopics.isEmpty) return 'You are improving consistently.';
    final topic = memory.weakTopics.first;
    final related = graph.relatedTopics(topic);
    if (related.isEmpty) return 'Focus on $topic before moving to new material.';
    return 'Improving $topic will also strengthen ${related.take(3).join(", ")}.';
  }
}