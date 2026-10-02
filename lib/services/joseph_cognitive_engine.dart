import '../models/document_action.dart';
import '../models/document_analysis.dart';
import '../utils/text_matcher.dart';
import 'academic_knowledge_engine.dart';
import 'adaptive_engine.dart';
import 'joseph_document_engine.dart';
import 'joseph_learning_engine.dart';
import 'joseph_memory.dart';
import 'joseph_quiz_engine.dart';
import 'joseph_reasoning.dart';
import 'personality_engine.dart';
import 'prediction_engine.dart';

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

  static const List<String> _quizTerms = ['quiz', 'quizzes'];

  static const List<String> _studyTerms = [
    'study',
    'studies',
    'studying',
    'recommend',
    'recommendation',
  ];

  static const List<String> _weakTerms = ['weak', 'weakness'];

  static const List<String> _strongTerms = ['strong', 'strength'];

  static const List<String> _progressTerms = ['progress'];

  static const List<String> _predictTerms = ['predict', 'prediction'];

  static final RegExp _greetingPattern = RegExp(
    r'^\s*(hello|hi|hey)\b',
    caseSensitive: false,
  );

  static const String _quizGuidance =
      'I need a topic to build a quiz.\n\n'
      'Try: quiz anova, quiz regression, quiz photosynthesis or '
      'quiz epidemiology.';

  static const String _fallbackReply =
      'I do not have an answer for that yet.\n\n'
      'Here is what I can do right now:\n'
      '- Explain topics such as ANOVA, regression, Python or photosynthesis\n'
      '- Build a quiz, for example: quiz anova\n'
      '- Recommend what to study next\n'
      '- Show your weak topics, strong topics, progress and predictions\n'
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

  // Answers a free-text question typed by the student.
  String respond(String question) {
    learning.observeQuestion(question);

    if (_mentions(question, _quizTerms)) {
      return _quizReply(question);
    }

    final definitions = knowledge.definitionsIn(question);

    if (definitions.isNotEmpty) {
      return _definitionReply(definitions);
    }

    if (_mentions(question, _studyTerms)) {
      return adaptive.nextRecommendation();
    }

    if (_mentions(question, _weakTerms)) {
      return _topicListReply(
        title: 'Weak topics',
        topics: memory.weakTopics,
        emptyMessage: 'I have not identified your weak topics yet.',
      );
    }

    if (_mentions(question, _strongTerms)) {
      return _topicListReply(
        title: 'Strong topics',
        topics: memory.strongTopics,
        emptyMessage: 'You have not mastered any topics yet.',
      );
    }

    if (_mentions(question, _progressTerms)) {
      return _progressReply();
    }

    if (_mentions(question, _predictTerms)) {
      return prediction.predictions().join('\n');
    }

    if (_greetingPattern.hasMatch(question)) {
      return '${personality.greeting()}\n\nHow can I help you today?';
    }

    return _fallbackReply;
  }

  // Runs [action] on an analysed [document].
  String respondToDocument(
    DocumentAction action,
    DocumentAnalysis document,
  ) {
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

  void observeQuestion(String question) {
    learning.observeQuestion(question);
  }

  void observeUpload({
    required String subject,
    required String fileName,
  }) {
    learning.observeUpload(
      subject: subject,
      fileName: fileName,
    );
  }

  void observeQuiz({
    required String topic,
    required int score,
  }) {
    learning.observeQuiz(
      topic: topic,
      score: score,
    );
  }

  void observeStudySession(int minutes) {
    learning.observeStudySession(minutes);
  }

  bool _mentions(String text, List<String> terms) {
    return TextMatcher.containsAny(text, terms);
  }

  String _quizReply(String question) {
    var topics = knowledge.definitionsIn(question).keys.toList();

    if (topics.isEmpty) {
      topics = knowledge
          .definitionsIn(memory.weakTopics.join(' '))
          .keys
          .toList();
    }

    final items = quiz.generateForTopics(topics);

    if (items.isEmpty) {
      return _quizGuidance;
    }

    final names = topics.map(knowledge.displayName).join(', ');

    return quiz.render('Quiz on $names', items);
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
      ..writeln('Understanding the idea is more important than memorising it.')
      ..writeln()
      ..write(
        'To practise, ask me for a quiz, for example: '
        'quiz ${definitions.keys.first}',
      );

    return buffer.toString();
  }

  String _topicListReply({
    required String title,
    required List<String> topics,
    required String emptyMessage,
  }) {
    if (topics.isEmpty) {
      return emptyMessage;
    }

    return [
      '$title:',
      ...topics.map((topic) => '- $topic'),
    ].join('\n');
  }

  String _progressReply() {
    final profile = memory.profile;

    return [
      'Learning level: ${memory.learningLevel()}',
      'Uploads: ${profile.totalUploads}',
      'Questions: ${profile.totalQuestions}',
      'Quizzes: ${profile.quizzesCompleted}',
      'Study minutes: ${profile.studyMinutes}',
    ].join('\n');
  }

  String _askAboutDocument(DocumentAnalysis document) {
    if (!document.hasText) {
      return documents.summarize(document);
    }

    final topics = document.keywords
        .where((keyword) => knowledge.definitionFor(keyword) != null)
        .take(_maxDocumentTopics)
        .toList();

    if (topics.isEmpty) {
      return 'I did not find topics in ${document.fileName} that I can '
          'explain yet.\n\n'
          'Try Important Topics or Revision Notes for an overview.';
    }

    return [
      'Topics from ${document.fileName} that I can explain:',
      '',
      ...topics.map(
        (topic) => '- ${knowledge.displayName(topic)}: '
            '${knowledge.definitionFor(topic)}',
      ),
      '',
      'Ask about any of them in the Joseph tab, or type "quiz <topic>" '
          'for practice questions.',
    ].join('\n');
  }

  String _quizFromDocument(DocumentAnalysis document) {
    final items = quiz.generateForTopics(document.keywords);

    if (items.isEmpty) {
      return 'I could not build quiz questions from the topics found in '
          '${document.fileName} yet.\n\n'
          'Try Generate Questions or Revision Notes instead.';
    }

    return quiz.render('Quiz from ${document.fileName}', items);
  }
}