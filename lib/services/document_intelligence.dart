import 'package:jets/models/document_record.dart';
import 'package:jets/services/academic_domain_detector.dart';
import 'package:jets/services/joseph_learning_engine.dart';
import 'package:jets/services/joseph_memory.dart';
import 'package:jets/services/knowledge_extractor.dart';
import 'package:jets/services/topic_detector.dart';

class DocumentIntelligence {
  final JosephMemory memory;
  final JosephLearningEngine learning;
  final TopicDetector detector;
  final AcademicDomainDetector domainDetector;

  late final KnowledgeExtractor extractor = KnowledgeExtractor(detector);

  DocumentIntelligence({
    required this.memory,
    required this.learning,
    required this.detector,
    required this.domainDetector,
  });

  Future<void> analyzeRecord(DocumentRecord record, String text) async {
    final extraction = extractor.extract(text);
    final domains = domainDetector.detectDomains(text);

    for (final topic in extraction['topics'] as List<String>) {
      memory.rememberSubject(topic);
    }

    // Enrich the record with the top detected topics as tags.
    final enriched = record.copyWith(
      tags: (extraction['topics'] as List<String>).take(3).toList(),
    );

    await learning.observeUpload(enriched);

    for (final domain in domains) {
      memory.rememberSubject(domain.name);
    }
  }
}