import 'package:jets/models/document_action.dart';
import 'package:jets/models/document_analysis.dart';
import 'package:jets/models/document_record.dart';
import 'package:jets/services/academic_knowledge_engine.dart';
import 'package:jets/services/adaptive_engine.dart';
import 'package:jets/services/joseph_document_engine.dart';
import 'package:jets/services/joseph_learning_engine.dart';
import 'package:jets/services/joseph_memory.dart';
import 'package:jets/services/joseph_quiz_engine.dart';
import 'package:jets/services/joseph_reasoning.dart';
import 'package:jets/services/personality_engine.dart';
import 'package:jets/services/prediction_engine.dart';
import 'package:jets/utils/text_matcher.dart';

class JosephCognitiveEngine {
  final JosephMemory memory;
  final AdaptiveEngine adaptive;
  final PredictionEngine prediction;
  final PersonalityEngine personality;
  final JosephReasoning reasoning;
  final JosephLearningEngine learning;

  final AcademicKnowledgeEngine knowledge = const AcademicKnowledgeEngine();
  final JosephDocumentEngine documents = const JosephDocumentEngine();
  late final JosephQuizEngine quiz = JosephQuizEngine(knowledge);

  JosephCognitiveEngine({
    required this.memory,
    required this.adaptive,
    required this.prediction,
    required this.personality,
    required this.reasoning,
    required this.learning,
  });

  static const int _maxDefinitions = 3;
  static const int _maxDocumentTopics = 5;

  static final RegExp _greetingPattern = RegExp(
    r'^\s*(hello|hi|hey)\b',
    caseSensitive: false,
  );

  static const String _fallbackReply =
      'I do not have an answer for that yet.\n\n'
      'What I can do:\n'
      '- Explain topics: ANOVA, regression, Python, photosynthesis\n'
      '- Build a quiz, e.g. quiz anova\n'
      '- Show weak topics, strong topics, progress or predictions\n'
      '- Analyse a PDF from the Upload tab';

  Map<String, dynamic> think() {
    return {
      'greeting': personality.greeting(),
      'learningLevel': memory.learningLevel(),
      'recommendation': adaptive.nextRecommendation(),
      'prediction': prediction.predictions(),
      'insight': reasoning.generateInsight(),
      'confidence': adaptive.confidenceScore(),
      'weakTopics': memory.weakTopics,
      'strongTopics': memory.strongTopics,
    };
  }

  String respond(String question) {
    learning.observeQuestion(question);

    if (TextMatcher.containsAny(question, ['quiz', 'quizzes'])) {
      return _quizReply(question);
    }

    final definitions = knowledge.definitionsIn(question);
    if (definitions.isNotEmpty) return _definitionReply(definitions);

    if (TextMatcher.containsAny(question, ['study', 'studies', 'recommend'])) {
      return adaptive.nextRecommendation();
    }

    if (TextMatcher.containsAny(question, ['weak', 'weakness'])) {
      return _topicList('Weak topics', memory.weakTopics,
          'I have not identified your weak topics yet.');
    }

    if (TextMatcher.containsAny(question, ['strong', 'strength'])) {
      return _topicList('Strong topics', memory.strongTopics,
          'You have not mastered any topics yet.');
    }

    if (TextMatcher.containsAny(question, ['progress'])) {
      return _progressReply();
    }

    if (TextMatcher.containsAny(question, ['predict', 'prediction'])) {
      return prediction.predictions().join('\n');
    }

    if (_greetingPattern.hasMatch(question)) {
      return '${personality.greeting()}\n\nHow can I help you today?';
    }

    return _fallbackReply;
  }

  String respondToDocument(DocumentAction action, DocumentAnalysis document) {
    return switch (action) {
      DocumentAction.askAboutDocument => _askAboutDocument(document),
      DocumentAction.generateQuiz => _quizFromDocument(document),
      DocumentAction.generateQuestions => documents.generateQuestions(document),
      DocumentAction.summarize => documents.summarize(document),
      DocumentAction.importantTopics => documents.importantTopics(document),
      DocumentAction.examPrediction => documents.examPrediction(document),
      DocumentAction.studyPlan => documents.studyPlan(document),
      DocumentAction.revisionNotes => documents.revisionNotes(document),
    };
  }

  Future<void> observeUpload(DocumentRecord record) async {
    await learning.observeUpload(record);
  }

  void observeQuiz({required String topic, required int score}) {
    learning.observeQuiz(topic: topic, score: score);
  }

  void observeStudySession(int minutes) {
    learning.observeStudySession(minutes);
  }

  String _quizReply(String question) {
    var topics = knowledge.definitionsIn(question).keys.toList();
    if (topics.isEmpty) {
      topics = knowledge.definitionsIn(memory.weakTopics.join(' ')).keys.toList();
    }
    final items = quiz.generateForTopics(topics);
    if (items.isEmpty) {
      return 'I need a topic to build a quiz.\n\n'
          'Try: quiz anova, quiz regression or quiz photosynthesis.';
    }
    return quiz.render('Quiz on ${topics.map(knowledge.displayName).join(", ")}', items);
  }

  String _definitionReply(Map<String, String> definitions) {
    final labelled = definitions.length > 1;
    final buffer = StringBuffer('Answer\n');
    for (final entry in definitions.entries.take(_maxDefinitions)) {
      final label = labelled ? '${knowledge.displayName(entry.key)}: ' : '';
      buffer.write('\n$label${entry.value}\n');
    }
    buffer
      ..writeln()
      ..writeln("Joseph's advice")
      ..writeln('Understanding the concept matters more than memorising it.')
      ..writeln()
      ..write('To practise: quiz ${definitions.keys.first}');
    return buffer.toString();
  }

  String _topicList(String title, List<String> topics, String empty) {
    if (topics.isEmpty) return empty;
    return '$title:\n${topics.map((t) => '- $t').join('\n')}';
  }

  String _progressReply() {
    final p = memory.profile;
    return [
      'Learning level: ${memory.learningLevel()}',
      'Uploads: ${p.totalUploads}',
      'Questions: ${p.totalQuestions}',
      'Quizzes: ${p.quizzesCompleted}',
      'Study minutes: ${p.studyMinutes}',
    ].join('\n');
  }

  String _askAboutDocument(DocumentAnalysis document) {
    if (!document.hasText) return documents.summarize(document);
    final topics = document.keywords
        .where((k) => knowledge.definitionFor(k) != null)
        .take(_maxDocumentTopics)
        .toList();
    if (topics.isEmpty) {
      return 'I did not find explainable topics in ${document.fileName}.\n\n'
          'Try Important Topics or Revision Notes.';
    }
    return [
      'Topics from ${document.fileName}:',
      '',
      ...topics.map((t) => '- ${knowledge.displayName(t)}: ${knowledge.definitionFor(t)}'),
      '',
      'Ask about any of them, or type "quiz <topic>" for practice.',
    ].join('\n');
  }

  String _quizFromDocument(DocumentAnalysis document) {
    final items = quiz.generateForTopics(document.keywords);
    if (items.isEmpty) {
      return 'Could not build quiz questions from ${document.fileName}.\n\n'
          'Try Generate Questions or Revision Notes instead.';
    }
    return quiz.render('Quiz from ${document.fileName}', items);
  }
}