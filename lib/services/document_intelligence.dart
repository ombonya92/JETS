import 'academic_domain_detector.dart';
import 'joseph_learning_engine.dart';
import 'joseph_memory.dart';
import 'knowledge_extractor.dart';
import 'topic_detector.dart';

class DocumentIntelligence {
  final JosephMemory memory;

  final JosephLearningEngine learning;

  final TopicDetector detector;

  final AcademicDomainDetector domainDetector;

  late final KnowledgeExtractor extractor =
      KnowledgeExtractor(detector);

  DocumentIntelligence({
    required this.memory,
    required this.learning,
    required this.detector,
    required this.domainDetector,
  });

  Map<String, dynamic> analyze({
    required String fileName,
    required String text,
  }) {
    final extraction =
        extractor.extract(text);

    final domains =
        domainDetector.detectDomains(text);

    learning.observeUpload(
      subject: domains.isEmpty
          ? "General"
          : domains.first.name,
      fileName: fileName,
    );

    for (final topic
        in extraction["topics"] as List<String>) {
      memory.rememberSubject(topic);
    }

    return {
      "file": fileName,
      "domains": domains,
      "analysis": extraction,
    };
  }
}