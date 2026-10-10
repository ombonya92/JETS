import '../services/academic_domain_detector.dart';
import '../services/adaptive_engine.dart';
import '../services/document_intelligence.dart';
import '../services/document_service.dart';
import '../services/joseph_cognitive_engine.dart';
import '../services/joseph_knowledge_graph.dart';
import '../services/joseph_learning_engine.dart';
import '../services/joseph_memory.dart';
import '../services/joseph_reasoning.dart';
import '../services/joseph_recommendation_engine.dart';
import '../services/joseph_service.dart';
import '../services/joseph_timeline_engine.dart';
import '../services/personality_engine.dart';
import '../services/prediction_engine.dart';
import '../services/topic_detector.dart'; 

class AppController {
  static final AppController instance = AppController._internal();

  factory AppController() => instance;

  AppController._internal();

  final JosephMemory memory = JosephMemory();

  late final JosephKnowledgeGraph knowledgeGraph = JosephKnowledgeGraph();

  late final JosephService joseph = JosephService();

  late final TopicDetector detector = TopicDetector();

  late final AcademicDomainDetector domainDetector =
      const AcademicDomainDetector();

  late final JosephTimelineEngine timeline = JosephTimelineEngine(memory);

  late final JosephLearningEngine learning =
      JosephLearningEngine(memory, timeline);

  late final AdaptiveEngine adaptive = AdaptiveEngine(memory);

  late final PredictionEngine prediction = PredictionEngine(memory);

  late final JosephRecommendationEngine recommendation =
      JosephRecommendationEngine(
    memory: memory,
    graph: knowledgeGraph,
  );

  late final PersonalityEngine personality = PersonalityEngine(memory);

  late final JosephReasoning reasoning = JosephReasoning(memory);

  late final DocumentService documents = DocumentService();

  late final DocumentIntelligence intelligence = DocumentIntelligence(
    memory: memory,
    learning: learning,
    detector: detector,
    domainDetector: domainDetector,
  );

  late final JosephCognitiveEngine cognitive = JosephCognitiveEngine(
    memory: memory,
    adaptive: adaptive,
    prediction: prediction,
    personality: personality,
    reasoning: reasoning,
    learning: learning,
  );
}