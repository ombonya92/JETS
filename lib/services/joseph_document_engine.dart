import '../models/document_analysis.dart';
import '../utils/text_matcher.dart';

class JosephDocumentEngine {
  const JosephDocumentEngine();

  static const int _summaryLength = 1200;

  static const int _notesLength = 1800;

  static final RegExp _whitespace = RegExp(r'\s+');

  static const List<String> _topicVocabulary = [
    'algebra',
    'calculus',
    'statistics',
    'probability',
    'regression',
    'correlation',
    'anova',
    'hypothesis testing',
    'biology',
    'cell',
    'genetics',
    'photosynthesis',
    'chemistry',
    'atom',
    'chemical reaction',
    'acid',
    'base',
    'physics',
    'force',
    'velocity',
    'acceleration',
    'momentum',
    'energy',
    'programming',
    'algorithm',
    'python',
    'database',
    'anatomy',
    'physiology',
    'pathology',
    'disease',
    'diagnosis',
    'epidemiology',
    'incidence',
    'prevalence',
    'outbreak',
    'screening',
    'psychology',
    'behavior',
    'history',
    'geography',
  ];

  String summarize(DocumentAnalysis document) {
    if (!document.hasText) {
      return 'Joseph could not find readable text in ${document.fileName}.';
    }

    return [
      'Summary of ${document.fileName}',
      '',
      _excerpt(document.text, _summaryLength),
    ].join('\n');
  }

  String importantTopics(DocumentAnalysis document) {
    if (!document.hasText) {
      return 'No readable topics were found.';
    }

    final topics = _topicsOf(document);

    if (topics.isEmpty) {
      return 'Joseph could not identify specific topics yet.';
    }

    return [
      'Important topics',
      '',
      ..._bullets(topics),
    ].join('\n');
  }

  String generateQuestions(DocumentAnalysis document) {
    if (!document.hasText) {
      return 'Joseph needs readable document content to generate questions.';
    }

    return [
      'Study questions',
      '',
      'Based on ${document.fileName}, review these areas:',
      '',
      ..._topicLines(document),
      '',
      'Possible questions:',
      '',
      '1. Define the main concepts discussed in the document.',
      '2. Explain the important principles covered.',
      '3. Describe the major processes or procedures discussed.',
      '4. Differentiate between important related concepts.',
      '5. Explain the importance of the major topics identified.',
      '6. Give examples related to the concepts discussed.',
      '7. Discuss possible applications of the knowledge covered.',
    ].join('\n');
  }

  String examPrediction(DocumentAnalysis document) {
    if (!document.hasText) {
      return 'Joseph needs readable document content before making an '
          'exam-focused analysis.';
    }

    return [
      'Possible exam areas',
      '',
      'Joseph identified these topics in ${document.fileName}:',
      '',
      ..._topicLines(document),
      '',
      'Areas worth revising carefully:',
      '',
      '- Definitions and key concepts',
      '- Explanations of major principles',
      '- Differences between related concepts',
      '- Applications and examples',
      '- Processes and procedures',
      '- Short-answer questions',
      '- Discussion questions',
    ].join('\n');
  }

  String revisionNotes(DocumentAnalysis document) {
    if (!document.hasText) {
      return 'No readable document content was found.';
    }

    return [
      'Revision notes for ${document.fileName}',
      '',
      _excerpt(document.text, _notesLength),
      '',
      'Focus on:',
      '',
      '- Key definitions',
      '- Main concepts',
      '- Important processes',
      '- Examples',
      '- Possible examination areas',
    ].join('\n');
  }

  String studyPlan(DocumentAnalysis document) {
    if (!document.hasText) {
      return 'Joseph needs readable document content to create a study plan.';
    }

    return [
      'Study plan for ${document.fileName}',
      '',
      'Topics identified:',
      '',
      ..._topicLines(document),
      '',
      'Suggested approach:',
      '',
      'Day 1: Read and understand the major concepts.',
      'Day 2: Review definitions and important principles.',
      'Day 3: Practice questions from the material.',
      'Day 4: Review difficult topics.',
      'Day 5: Test yourself without looking at the notes.',
      'Day 6: Correct mistakes and revise weak areas.',
      'Day 7: Complete a final revision.',
    ].join('\n');
  }

  List<String> _topicsOf(DocumentAnalysis document) {
    return TextMatcher.matchingTerms(document.text, _topicVocabulary);
  }

  List<String> _topicLines(DocumentAnalysis document) {
    final topics = _topicsOf(document);

    if (topics.isEmpty) {
      return ['No specific topics were identified.'];
    }

    return _bullets(topics);
  }

  List<String> _bullets(List<String> items) {
    return items.map((item) => '- $item').toList();
  }

  String _excerpt(String text, int maxLength) {
    final clean = text.replaceAll(_whitespace, ' ').trim();

    if (clean.length <= maxLength) {
      return clean;
    }

    return '${clean.substring(0, maxLength)}...';
  }
}