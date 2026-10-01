import '../models/knowledge_node.dart';

class JosephKnowledgeGraph {
  final Map<String, KnowledgeNode> _nodes = {};

  List<KnowledgeNode> get nodes =>
      _nodes.values.toList();

  void learn(List<String> topics) {
    for (final topic in topics) {
      final node = _nodes.putIfAbsent(
        topic,
        () => KnowledgeNode(name: topic),
      );

      node.seen();
      node.improve(5);

      for (final related in topics) {
        if (related != topic) {
          node.connect(related);
        }
      }
    }
  }

  KnowledgeNode? node(String topic) {
    return _nodes[topic];
  }

  List<String> relatedTopics(String topic) {
    return node(topic)
            ?.relatedTopics
            .toList() ??
        [];
  }
}