import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/document_analysis.dart';
import '../utils/text_matcher.dart';

class DocumentService {
  static const int _maxKeywords = 15;

  static const int _previewLength = 600;

  static final RegExp _whitespace = RegExp(r'\s+');

  static const Map<String, List<String>> _subjectRules = {
    'Mathematics': [
      'algebra',
      'calculus',
      'equation',
      'quadratic',
      'matrix',
      'geometry',
      'trigonometry',
      'statistics',
      'probability',
    ],
    'Biology': [
      'cell',
      'mitosis',
      'meiosis',
      'genetics',
      'photosynthesis',
      'organism',
      'ecosystem',
      'dna',
      'rna',
    ],
    'Chemistry': [
      'atom',
      'molecule',
      'chemical',
      'reaction',
      'acid',
      'base',
      'organic chemistry',
      'periodic table',
    ],
    'Physics': [
      'force',
      'velocity',
      'acceleration',
      'momentum',
      'energy',
      'motion',
      'newton',
      'electricity',
      'wave',
    ],
    'Computer Science': [
      'algorithm',
      'programming',
      'python',
      'computer',
      'database',
      'software',
      'network',
      'data structure',
    ],
    'Medicine': [
      'patient',
      'diagnosis',
      'disease',
      'clinical',
      'anatomy',
      'physiology',
      'pathology',
      'treatment',
    ],
    'Nursing': [
      'nursing',
      'patient care',
      'clinical',
      'diagnosis',
      'vital signs',
      'medication',
    ],
    'Epidemiology': [
      'epidemiology',
      'incidence',
      'prevalence',
      'outbreak',
      'surveillance',
      'screening',
      'risk factor',
    ],
    'Economics': [
      'economics',
      'demand',
      'supply',
      'inflation',
      'market',
      'gdp',
      'unemployment',
    ],
    'Psychology': [
      'psychology',
      'behavior',
      'cognition',
      'memory',
      'personality',
      'learning',
    ],
    'History': [
      'history',
      'war',
      'colonial',
      'revolution',
      'empire',
      'civilization',
    ],
    'Geography': [
      'geography',
      'climate',
      'population',
      'map',
      'environment',
      'landform',
    ],
  };

  static const List<String> _keywordVocabulary = [
    'algebra',
    'calculus',
    'statistics',
    'probability',
    'regression',
    'correlation',
    'anova',
    'hypothesis testing',
    'cell',
    'genetics',
    'photosynthesis',
    'mitosis',
    'meiosis',
    'atom',
    'chemical reaction',
    'acid',
    'base',
    'organic chemistry',
    'force',
    'velocity',
    'acceleration',
    'momentum',
    'energy',
    "newton's laws",
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
    'economics',
    'supply',
    'demand',
    'inflation',
    'psychology',
    'behavior',
    'history',
    'geography',
  ];

  Future<DocumentAnalysis> analyzePdf(
    Uint8List bytes,
    String fileName,
  ) async {
    final document = PdfDocument(inputBytes: bytes);

    try {
      final pageCount = document.pages.count;
      final text = PdfTextExtractor(document).extractText().trim();
      final subjects = _detectSubjects(text);
      final keywords = _detectKeywords(text);

      return DocumentAnalysis(
        fileName: fileName,
        pageCount: pageCount,
        subjects: subjects,
        keywords: keywords,
        summary: _createSummary(
          fileName: fileName,
          pageCount: pageCount,
          text: text,
          subjects: subjects,
          keywords: keywords,
        ),
        text: text,
      );
    } finally {
      document.dispose();
    }
  }

  List<String> _detectSubjects(String text) {
    final detected = [
      for (final entry in _subjectRules.entries)
        if (TextMatcher.containsAny(text, entry.value)) entry.key,
    ];

    if (detected.isEmpty) {
      return ['General Academics'];
    }

    return detected;
  }

  List<String> _detectKeywords(String text) {
    return TextMatcher.matchingTerms(text, _keywordVocabulary)
        .take(_maxKeywords)
        .toList();
  }

  String _createSummary({
    required String fileName,
    required int pageCount,
    required String text,
    required List<String> subjects,
    required List<String> keywords,
  }) {
    if (text.isEmpty) {
      return 'Joseph received "$fileName", but no readable text was found.\n\n'
          'The PDF may contain scanned images rather than selectable text.';
    }

    final preview = text.replaceAll(_whitespace, ' ').trim();

    final shortened = preview.length > _previewLength
        ? '${preview.substring(0, _previewLength)}...'
        : preview;

    final pages = pageCount == 1 ? '1 page' : '$pageCount pages';

    return [
      'Joseph analysed "$fileName" ($pages).',
      '',
      'Detected subject areas:',
      ...subjects.map((subject) => '- $subject'),
      '',
      'Detected topics:',
      if (keywords.isEmpty)
        'No specific keywords detected yet.'
      else
        ...keywords.map((keyword) => '- $keyword'),
      '',
      'Document preview:',
      shortened,
    ].join('\n');
  }
}