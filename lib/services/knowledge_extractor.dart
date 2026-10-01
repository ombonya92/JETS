import '../services/topic_detector.dart';

class KnowledgeExtractor {
  final TopicDetector detector;

  KnowledgeExtractor(this.detector);

  Map<String, dynamic> extract(String text) {
    final topics = detector.detectTopics(text);

    final keywords = detector.detectKeywords(text);

    final concepts = _extractConcepts(text);

    final difficulty =
        _estimateDifficulty(text);

    return {
      "topics": topics,
      "keywords": keywords,
      "concepts": concepts,
      "difficulty": difficulty,
      "wordCount":
          text.split(RegExp(r'\s+')).length,
    };
  }

  List<String> _extractConcepts(
      String text) {
    final sentences = text
        .split(RegExp(r'[.!?]'))
        .where(
          (e) => e.trim().isNotEmpty,
        )
        .toList();

    final concepts = <String>[];

    for (final sentence in sentences) {
      if (sentence.trim().length > 35) {
        concepts.add(sentence.trim());

        if (concepts.length >= 10) {
          break;
        }
      }
    }

    return concepts;
  }

  String _estimateDifficulty(
      String text) {
    final words =
        text.split(RegExp(r'\s+')).length;

    if (words < 250) {
      return "Beginner";
    }

    if (words < 1000) {
      return "Intermediate";
    }

    return "Advanced";
  }
}